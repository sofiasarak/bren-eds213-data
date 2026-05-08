-- Week 4, Past 3
-- Sofia Sarak

-- Who's the culprit?


-- Select data that is only within the proper year range and site nome
SELECT * FROM Bird_nests WHERE Year BETWEEN 1998 AND 2008
    AND Site = 'nome';

-- Continue filtering for ageMethod as well
SELECT * FROM Bird_nests WHERE Year BETWEEN 1998 AND 2008
    AND Site = 'nome'
    AND ageMethod = 'float';

-- Count the number of observations and group by observer
SELECT Observer, COUNT(*) FROM Bird_nests WHERE Year BETWEEN 1998 AND 2008
    AND Site = 'nome'
    AND ageMethod = 'float'
    GROUP BY Observer;

-- It was edastrous! Now join this with the personell column for full name

-------------------------------FINAL ANSWER --------------------------------
SELECT Name, Num_floated_nests -- select specific columns

-- original table that tells us number of observations and observer abbreviation
FROM (SELECT Observer, COUNT(*) AS Num_floated_nests FROM Bird_nests WHERE Year BETWEEN 1998 AND 2008
    AND Site = 'nome'
    AND ageMethod = 'float'
    GROUP BY Observer) X 

    -- join to Personnel
    LEFT JOIN Personnel P ON X.Observer == P.Abbreviation

    -- filter for 36 nests
    WHERE Num_floated_nests = 36;

-- Complete!