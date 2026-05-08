-- Week 4, Part 1
-- Sofia Sarak

-- Which sites have no egg data? 

-- OUTER JOIN METHOD

-- Using an outer join, join the Site and Bird_eggs tables so that NULLs are placed where 
-- the Bird_nests table doesn't match up to Site

SELECT Code FROM Site S LEFT JOIN Bird_eggs B 
    ON S.Code == B.Site
    WHERE Nest_ID IS NULL
    ORDER BY Code;
    
-- Because Nest_ID is the primary key in Bird_nests, we know it would only NULL here if it is missing from the Site table

-- NOT IN METHOD
 SELECT Code FROM Site
 
   -- select only codes that do not match up with Site in Bird_eggs
    WHERE Code NOT IN (SELECT Site FROM Bird_eggs)
    ORDER BY Code;
    















