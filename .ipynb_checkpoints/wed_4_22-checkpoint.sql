-- wednesday 4/22 notes

-- SELF-JOINs
SELECT * FROM A CROSS JOIN B;
-- result: number of columns in a + number of columns in b
-- number of rows in a * number of rows in b
-- cartesian product of all the rows 

-- select specific columns from the cross join (join happens first, bc it is in ())
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B);

SELECT acol1, acol2, COUNT(*) 
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;
-- creates error

SELECT acol1, ANY_VALUE(acol2), COUNT(*) 
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1; -- not wrong to put both vars in GROUP BY, but ANY_VALUE is better for readability 

SELECT acol1, ANY_VALUE(acol2), COUNT(bcol3) 
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1; 
-- results in 2, because instead of 3 because NULL is ignored!

-- REMINDER: COUNT(*) simply counts rows, but COUNT(column) counts values

-- using a condition: only do join when acol1 is smaller than bcol1
-- system always does a cross join, then filters out based on what we want 
SELECT * FROM A JOIN b ON acol1 < bcol1;

-- INNER or OUTER JOINs
SELECT * FROM Student;
SELECT * FROM House;

-- INNER: 
-- (JOIN = INNER JOIN)
SELECT * FROM Student AS S JOIN House AS H ON S.House_ID = H.House_ID;
-- or
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;
-- don't have to include 'AS'!

-- even more compact notation
-- but, requires the same column names 
SELECT * FROM Student JOIN House USING (House_ID); -- USING requires ()
-- another pro: House_ID does not repeat

-- OUTER JOINs:
SELECT * FROM Student FULL JOIN House USING (House_ID);

SELECT * FROM Student LEFT JOIN House USING (House_ID); -- Student is on the left

-- on order: will not change order randomly, but can't assume that it will always be the same!
SELECT * FROM Student CROSS JOIN House;

-- CREATE TABLE!
CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");

-- creating temp tables is useful for when you want to change table without making permanent changes
-- (will disappear after session)
CREATE TEMP TABLE Camp_assignment_copy AS
   SELECT * FROM Camp_assignment; 

CREATE TEMP TABLE Camp_personnel_tmp AS
   SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

SELECT Year, Site, Name FROM Camp_assignment_copy 
    JOIN Personnel ON Observer = Abbreviation;

-- create view:
CREATE VIEW Camp_personnel_v AS
   SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;


-- in duckdb, list all of the Views:
SELECT view_name FROM duckdb_views;

-- deleting and differences between views and temp tables
SELECT * FROM Camp_assignment_copy WHERE Site == 'bylo';
SELECT * FROM Camp_personnel_v LIMIT 10;

-- delete rows
DELETE FROM Camp_assignment_copy WHERE Site == 'bylo';
-- deleted from view as well!
SELECT * FROM Camp_personnel_v LIMIT 10;

-- once session is ended, views stay when you go back into it, temp tables are gone