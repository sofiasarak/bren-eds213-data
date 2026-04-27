-- have to be in the database directly for duckdb database.duckdb to work!!
-- SQL isn't case sensitive actually

-- to verify that we have the "right" database open, look at what tables are in the database:
.table

-- to see that the Duck-DB specific commands, do this:
.help

-- to try again, ctrl + C

-- use .exit to exit, or ctrl-D

-- in SQl, comments are delimited with --

-- .table -- lists tables
-- .schema -- lists the whole schema

-- getting help on SQL: look at the "railroad" diagrams in SQLite (sqlite.org/lang.html)

-- our first query:
SELECT * FROM Species; -- the * means all columns; all rows are implied becuase we didn't specify a WHERE clause
SELECT * FROM Species WHERE Code = 'wrsa';

-- a couple gotchas
-- 1. don't forget the closing semicolon, DuckDB will wait for it forever
-- 2. watch for missing closing quotes

-- select 5 species (equivalent to head())
SELECT * FROM Species LIMIT 5;

-- show me a different (next) set of 5:
SELECT * FROM Species LIMIT 5 OFFSET 5;

-- We can select which columns we want (instead of SELECT *)
SELECT Code, Scientific_name FROM Species;

-- Another handy query to explore data:
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests; -- number of rows is number of unique codes 

-- Can also get distinct pairs or tuples that occur
SELECT DISTINCT Species, Observer from Bird_nests;

-- can ask that the results be ordered (alphabetical)
SELECT Scientific_name FROM Species ORDER BY Scientific_name;


-- the default ordering (which is undefined) can be subtle
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests LIMIT 3; -- pulls a completely random 3! not the first ones from the line before

-- let's try again, but ask that results be ordered
SELECT DISTINCT Species from Bird_nests ORDER BY Species;
SELECT DISTINCT Species from Bird_nests ORDER BY Species LIMIT 3;

-- In-class challange:
-- select distinct locations from the Site table. Are they in order? If not, order them.
SELECT DISTINCT Location FROM Site ORDER BY Location; -- alphabetical