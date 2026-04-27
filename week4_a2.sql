-- Week 4, Part 2
-- Sofia Sarak

-- Who worked with whom?

-- STEP 0: Self-join
SELECT * FROM Camp_assignment A JOIN Camp_assignment B USING ( );

-- STEP 1: Add ON condition
SELECT * FROM Camp_assignment A JOIN Camp_assignment B 
    ON A.Site == B.Site;

-- STEP 2: Add date condition
SELECT * FROM Camp_assignment A JOIN Camp_assignment B 
    ON A.Site == B.Site 
    AND A.Start <= B.End 
    AND A.End >= B.Start;

-- STEP 3: Filter and fix duplicates
SELECT * FROM Camp_assignment A JOIN Camp_assignment B 

    -- Join conditions: same site and overlapping timeframes
    ON A.Site == B.Site 
    AND A.Start <= B.End 
    AND A.End >= B.Start    

    -- Filter for site and remove duplicates
    WHERE A.Site = 'lkri' 
    AND A.Observer < B.Observer;

-- STEP 4: Clean up table
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2  FROM Camp_assignment A JOIN Camp_assignment B 

    -- Join conditions: same site and overlapping timeframes
    ON A.Site == B.Site 
    AND A.Start <= B.End 
    AND A.End >= B.Start    

    -- Filter for site and remove duplicates
    WHERE A.Site = 'lkri' 
    AND A.Observer < B.Observer;

-- BONUS PROBLEM: Add full observer name
SELECT A.Site, A.Name AS Name_1, B.Name AS Name_2 FROM 

-- Join on Personnel tables that include observer name 
(SELECT Site, "Start", "End", Observer, Name FROM Camp_assignment C JOIN Personnel P ON C.Observer = P.Abbreviation) A 
JOIN (SELECT Site, "Start", "End", Observer, Name FROM Camp_assignment C JOIN Personnel P ON C.Observer = P.Abbreviation) B 

    -- Join conditions: same site and overlapping timeframes
    ON A.Site == B.Site 
    AND A.Start <= B.End 
    AND A.End >= B.Start    

    -- Filter for site and remove duplicates
    WHERE A.Site = 'lkri' 
    AND A.Observer < B.Observer;