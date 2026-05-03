-- Week 5, Assignment 1
-- Sofia Sarak


-- PART 1

-- Create tables from CSV files
CREATE TABLE Nests_big AS SELECT * FROM 'nests_big.csv';
CREATE TABLE Eggs_big AS SELECT * FROM 'eggs_big.csv';

-- Three-way join between Eggs_big, Nests_big, and Species
CREATE VIEW Egg_volume_v AS 
  SELECT Site, (3.14 / 6 * Width * Width * Length) AS Volume FROM Eggs_big
  JOIN Nests_big USING (Nest_ID)
  JOIN Species ON Species.Code == Nests_big.Species
  WHERE Scientific_name == 'Calidris alpina';
  
  
-- Join view and site table to get longitude column
SELECT Longitude, Volume FROM Egg_volume_v V
    JOIN Site S ON S.Code == V.Site;
    
-- Fix longitude column
CREATE VIEW Egg_volume_v2 AS
SELECT Volume, 
CASE 
    WHEN  Longitude > 0 
    THEN Longitude - 360
    ELSE Longitude
END AS Longitude 
FROM Egg_volume_v V
    JOIN Site S ON S.Code == V.Site;

-- Check range of new column to make sure CASE WHEN worked
SELECT MIN(Longitude) AS MinValue, MAX(Longitude) AS MaxValue
    FROM Egg_volume_v2;
    
-- Calculate linear regression slope and Pearson correlation coefficient
-- Format: REGR_SLOPE(y, x) and CORR(y , x)
SELECT REGR_SLOPE(Volume, Longitude) AS Slope, 
       CORR(Volume, Longitude) AS PCC
    FROM Egg_volume_v2;

-- PART 2

-- 1. Do the tables created automatically by DuckDB guarantee that a nest ID mentioned in the Eggs_big table actually exists in the Nests_big table? If yes, explain how that is guaranteed, if not, explain why not. (6pts)

The automatically created tables do NOT guarantee that a Nest_ID mentioned in the Eggs_big table exists in the Nests_big table because it is not specified as a foreign key in the table schema. For example, the schema for Eggs_big is 

CREATE TABLE Eggs_big(Nest_ID VARCHAR, Egg_num BIGINT, Length DOUBLE, Width DOUBLE);

whereas our original eggs table is defined by

CREATE TABLE Bird_eggs(Book_page VARCHAR, "Year" INTEGER NOT NULL, Site VARCHAR NOT NULL, Nest_ID VARCHAR, Egg_num INTEGER, Length FLOAT NOT NULL, Width FLOAT NOT NULL, CHECK(("Year" BETWEEN 1950 AND 2015)), CHECK((Egg_num BETWEEN 1 AND 20)), CHECK(((Length > 0) AND (Length < 100))), CHECK(((Width > 0) AND (Width < 100))), PRIMARY KEY(Nest_ID, Egg_num), FOREIGN KEY (Site) REFERENCES Site(Code), FOREIGN KEY (Nest_ID) REFERENCES Bird_nests(Nest_ID));

In the second example, Nest_ID is specified as a foreign key and references the Bird_nests table. This ensures that what is in Bird_eggs actually exists in Bird_nests, but that is not defined for our "big" tables.

-- 2. What queries did you use (or could you use) to find the minimum and maximum longitude values in the Site table? (2pts)

SELECT MIN(Longitude) AS MinValue, MAX(Longitude) AS MaxValue
    FROM Egg_volume_v2;

-- 3. The interpretation of the Pearson correlation coefficient is: +1 is a perfect positive correlation, -1 is a perfect negative correlation, and 0 is no correlation at all. How would you characterize the correlation between egg volume and longitude for the eggs of Calidris alpina in the Arctic above Canada? (2pts)

The correlation between egg volume and longitude for this sample of eggs is a very weak, negative correlation.