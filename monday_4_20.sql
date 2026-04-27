-- first review item: tri-value logiv
-- expressions can have a value (if Boolean, TRUE or FALSE), but they can also be NULL
-- in selecting rows, NULL doesn't cut it, NULL doesn't count as TRUE

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge < 7 OR floatAge >=7;

-- wrong:
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge = NULL;

-- correct:
SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge IS NULL;

-- Review item: relational algebra
-- Everything is a table! every operation returns a table!
-- Even a simple COUNT(*) returns a table

SELECT COUNT(*) FROM Bird_nests;

-- We looked at one example of nesting SELECTS

SELECT Scientific_name
    FROM Species
    WHERE Code NOT IN ( SELECT DISTINCT Species FROM Bird_nests );

-- Let's pretend that SQL didn't have a HAVING clause. Could we somehow get the same functionality?
-- Let's go back to the example where we used a HAVING clause.

SELECT Location, MAX(Area) AS Max_area
    FROM Site
    WHERE Location LIKE '%Canada' -- "" doesn't work in SQL!
    GROUP BY Location
    HAVING Max_area > 200;

-- % is the wildcard (like *)

-- as a reminder, the site table:
SELECT * FROM Site LIMIT 5;

-- similar to tidyverse: can create separate tables within ()
SELECT * FROM
    (SELECT Location, MAX(Area) AS Max_area
        FROM Site
        WHERE Location LIKE '%Canada' -- "" doesn't work in SQL!
        GROUP BY Location)
    WHERE Max_area > 200;

-- REVIEW AND CONTINUING DISCUSSION OF JOINS

-- what is a join? 
-- Conceptually, the database performs a "Cartesian product" of the tables, then matches up rows based on some kind of join condition.

-- In some databases, to do a Cartesian product you would just do a JOIN without a conditions e.g.;
SELECT * FROM A JOIN B;
--**BUT** in Duckdb, you have to say
SELECT * FROM A CROSS JOIN B;
SELECT * FROM A;
SELECT * FROM B;

-- let's add a join condition, which can be *any* expression!
SELECT * FROM A JOIN B ON acol1 < bcol1; -- an inner join. # of rows = 5

-- This is what's referred to as an INNER JOIN
SELECT * FROM A INNER JOIN B ON acol1 < bcol1;

-- Outer join: we're adding rows from one table that never got matched.

SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1; -- will insert NULLS where A doesn't match up to B

SELECT * FROM A LEFT JOIN B ON acol1 < bcol1; -- will insert NULLS where B doesn't match up to A

-- Just from completeness (this is whay more rare that you would want to do this):
SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

-- Now, joining on a foreign key relationship is way more common
SELECT * FROM House;
SELECT * FROM STUDENTS;

-- typical thing to do:
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;
-- if alias not used, would have to type out Student.House_ID and House.House_ID

-- one nice benefit of joining on a column that has the same name (i.e., HOUSE_ID here), is you can use the USING clause
SELECT * FROM Student JOIN House USING (House_ID); -- this version will not duplicate the House_ID column
-- INNER join is default

-- Meanwhile, back in the bird database:
SELECT COUNT(*) FROM Bird_eggs;

-- For better viewing, 
.mode line

SELECT * FROM Bird_eggs LIMIT 1;
SELECT * FROM Bird_eggs JOIN Bird_nests USING (Nest_ID) LIMIT 1;

SELECT COUNT(*) FROM Bird_eggs JOIN Bird_nests USING (Nest_ID);

-- Important point! Ordering is assuredly lost doing a JOIN. So don't say this:
-- ordering should always and only be the very last thing

SELECT * FROM 
    (SELECT * FROM Bird_eggs ORDER BY Width) -- this order does NOT get preserved
    JOIN Bird_nests
    USING (Nest_ID);

-- Gotcha with DuckDB.. it's not as smart as some other databases
SELECT Nest_ID, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- Some databases allow you to say:
SELECT Nest_ID, Species, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- Workaround 1:
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*) -- ANY_VALUE()
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- Workaround 2:
SELECT Nest_ID, Species, COUNT(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID, Species;

SELECT Nest_ID, Species, Width, Length FROM 
    Bird_eggs JOIN Bird_nests USING (Nest_ID) 
    ORDER BY Nest_ID, Egg_num LIMIT 10;

-- ANY_VALUE literally returns any value (returns any width from each nest)
SELECT Nest_ID, ANY_VALUE(Width)
    FROM Bird_eggs
    GROUP BY Nest_ID;