-- Week 3, Problem 2: Sofia Sarak

-- PART 1
-- the following results in an error...
SELECT Site_name, MAX(Area) FROM Site;

-- This is because the function/aggregation MAX(Area) collapses Area into a single row. SQL does not
-- know what to do with *all* of the Site_name columns, or how to match up Site_name to MAX(Area).
-- Therefore, it throws an error. To fix this, SQL requires an explicit GROUP BY argument, or, like
-- the error message says, Site_name itself must be part of an aggregate function.


-- PART 2
-- Find the site name and area of the site having the largest area.
SELECT Site_name, Area FROM Site 
    ORDER BY Area DESC -- order, in descending order, by Area
    LIMIT 1; -- select only the top observation

-- PART 3
-- Do the same, but use a nested query.
SELECT Site_name, Area FROM Site 
    WHERE Area = (SELECT Area FROM Site -- find the top Area value
                    ORDER BY Area DESC
                    LIMIT 1);

-- This works because the result of the query within the () is just a float with the maximum area.
-- Therefore, SQL can find where Area is equal to that value, and which Site_name corresponds to it