-- RECAP: Views

-- a view is a kind of virtual table
-- stored in the database
-- viewed every time it's references
-- in effect, a view is a kind of shortcut
-- it's similar to a function in a programming language 

-- Example: suppose we want to look at bird nests, we but always would rather see scientific names, not species codes

CREATE VIEW Nest_view AS
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer
    FROM Bird_nests JOIN species
    ON Species = Code;

SELECT * FROM Nest_view LIMIT 1;
-- for comparison:
SELECT * FROM Bird_nests LIMIT 1:

-- Let's use our view for a more substantial purpose: counting eggs, but we'd like to see the Nest ID
-- and the scientific name for each nest

SELECT Nest_ID, ANY_VALUE(Scientific_name), COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID;

    -- can use ANY_VALUE because the group_by collapses those rows, and we're telling it to be any of the collapsed values 
    -- (should be the same)

-- View compared to temp tables:
-- Temp table is more like a variable in a programming language 
-- as the name suggests, a "TEMP" table only lasts for the session 

-- Another option: use a with clause 

WITH X AS (
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID)
SELECT Scientific_name, AVG(Num_eggs) AS Avg_num_eggs FROM X
    GROUP BY Scientific_name;
-- in this case, x only exists during the execution of the query

-- SET OPERATIONS
-- recall that tables are **sets** of rows, not ordered lists
-- we can do set operations on tables
-- UNION, INTERSECT, EXCEPT (set difference)
-- one note: these are set operations, so duplicates are eliminated in UNIONs
-- but, if you do want to preserve all rows, UNION ALL

-- example of a UNION (let's go back to last week's quiz)
-- we want a table of bird nests and egg counts, but we also want entries for nests that have no eggs (they should have a count of 0)

-- answer for last week:
SELECT Nest_ID, COUNT(Egg_num) AS Num_eggs
FROM Bird_nests LEFT JOIN Bird_eggs
USING (Nest_ID)
GROUP BY Nest_ID;

-- let's try solving the same problem, but using UNION:

SELECT Nest_ID, COUNY(*) AS Num_eggs
    FROM Bird_eggs
    GROUP BY Nest_ID

UNION

SELECT Nest_ID, 0 AS Num_eggs -- create column called 0
    FROM Bird_nests
    WHERE Nest_ID IS NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs);

-- Note on UNIONs: SQL will UNION any two tables that have the same number of columns
-- and compatible data types (kind of like rbind in R)

-- Example of when you might want to use EXCEPT:
-- Question: which species do we *not* have data for?

-- Three ways:

-- Way #1
SELECT Code FROM Species  
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- Way #2
SELECT Code 
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Species IS NULL;

-- Way #3
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;

-- enough with SELECT! data management statements 

-- INSERT statements
SELECT * FROM Personnel;
INSERT INTO Personnel VALUES ('gjanee', 'Greg Janee');
SELECT * FROM Personnel;

-- good practice for safer code: name the columns 
INSERT INTO Personnel (Abbreviation, Name) VALUES ('jbrun', 'Julien Brun');

-- also, when you insert a row in a table, you don't necessarily have to specify all of the values;
-- anything not specified will either be filled with NULL or a default value

-- so that's another reason for spelling out the column names

-- Databases typically have some kind of load functions to load data in bulk

-- updates and deletes:

SELECT * FROM Bird_nests LIMIT 10;

UPDATE Bird_nests SET floatAge = 6.5, ageMethod = 'float'
    WHERE Nest_ID = '14HPE1';

SELECT * FROM Bird_nests LIMIT 10;

-- DELETE is very similar

-- DELETE from Bird_nests WHERE ...;

-- The above two commands (UPDATE, DELETE) are just incredibly dangerous 

-- The weird/terrible behavior: if not WHERE clause, they operate on **all** rows in the table
-- if original database was not backed up in GitHub and we couldn't restore it, our changes would be permanent!

-- What's a strategy to not make this terrible mistake?
-- One idea: 
-- First, do a SELECT to confirm the rows you want to operate on, and then edit the statement to do
-- an UPDATE

SELECT * FROM Bird_nests WHERE Nest_ID = '98nome7';

-- Another idea:
-- use a fake table name, then change to the real name
UPDATE Bird_nestsxxx SET ... WHERE ...;