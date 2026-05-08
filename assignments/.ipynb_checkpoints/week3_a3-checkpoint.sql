-- Week 3, Problem 3: Sofia Sarak

-- Your mission is to list the scientific names of bird species in descending order 
-- of their maximum average egg volumes. That is, compute the average volume of the eggs 
-- in each nest, and then for the nests of each species compute the maximum of those average volumes,  
--and list by species in descending order of maximum volume.

-- STEP 1: create table with average egg volume by Nest_ID
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG(3.14 / 6 * Width * Width * Length) AS Avg_volume
        FROM Bird_eggs
        GROUP BY Nest_ID;


-- STEP 2a: join to Bird_nest table (has species info)
SELECT Species, MAX(Avg_volume) AS Max_avg_volume
    FROM Bird_nests JOIN Averages USING (Nest_ID)
    GROUP BY Species;
-- returns the maximum average egg volume, by species

-- STEP 2b: turn the query above into a temp table
CREATE TEMP TABLE Max_avg_volumes AS
SELECT Species, MAX(Avg_volume) AS Max_avg_volume
    FROM Bird_nests JOIN Averages USING (Nest_ID)
    GROUP BY Species;

-- STEP 3a: join the above table to the Species table (which contains scientific names)
SELECT * FROM Max_avg_volumes M JOIN Species S
    ON M.Species == S.Code;

-- STEP 3b: since that worked (!), we can alter the query a bit to order by volume and select only the columns we want
SELECT Scientific_name, Max_avg_volume FROM
    (SELECT * FROM Max_avg_volumes M JOIN Species S
    ON M.Species == S.Code)
    ORDER BY Max_avg_volume DESC; -- make sure to denote that we want descending order

-- complete!