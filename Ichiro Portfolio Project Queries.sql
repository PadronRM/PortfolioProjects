/* SQL Project to analyze one of my favorite Mariner's of all time using queries. 
This project will then be uploaded to Tableau for visualization.
*/

--Ensuring the table generated correctly
Select * 
From Ichiro


-- This query calculates Ichiro's batting average throughout his career. This query shows that his highest Batting average was .372 in 2004
Select Year, tm, SUM(cast(h as numeric))/SUM(cast(ab as numeric)) as Batting_Avg --Casting hits and at bats as numeric due to the dataset having them as nvarchar data types
From Ichiro
Group by YEAR, tm
Order by Batting_Avg desc

--Same query as above for yearly batting average. However, we are limiting it to the top 5 batting averages. Those being 2004, 2009, 2007, 2001, and 2006.
Select TOP 5 year, tm, sum(cast(h as numeric)) / sum(cast(ab as numeric)) as Batting_Avg
From Ichiro
Group by year, Tm
Order by Batting_Avg desc

--This small query shows Ichiro's career batting average. Ichiro's career batting average was .311
Select sum(cast(h as numeric)) / sum(cast(ab as numeric)) as Batting_average
From Ichiro
Where tm <> 'ToT' --This dataset has 3 seperates rows for 2012. Those being the Mariners, the Yankees, and Two other teams. I am excluding the tot value to avoid doubling values







-- This query calculates Ichiro's total home runs by year. The query shows that Ichiro's best year in terms of home runs was in 2005 with 15 home runs. 
Select Year, tm, sum(cast(hr as numeric)) as Total_Home_Runs
From Ichiro
Group by Year, Tm
Order by Total_Home_Runs desc

-- Small query that shows Ichiro's total career home runs. That being 117 home runs.
Select sum(cast(hr as numeric)) as Total_Home_Runs
From Ichiro
Where Tm <> 'ToT'







--This query calculates Ichiro's On base percentage by year. 2004 was his best year in terms of OBP at .414.
Select year, Tm, (SUM(cast(h as numeric)) + sum(cast(bb as numeric)) + sum(cast(hbp as numeric))) / (sum(cast(ab as numeric)) + sum(cast(bb as numeric)) + sum(cast(hbp as numeric)) + sum(cast(sf as numeric))) as On_Base_Percentage
From Ichiro
Group by year, Tm
Order by On_Base_Percentage desc

--Same query as above, but we are limiting it to the top 5 on base percentages. In order being 2004, 2007, 2002, 2009, and 2001.
Select top 5 year, Tm, (SUM(cast(h as numeric)) + sum(cast(bb as numeric)) + sum(cast(hbp as numeric))) / (sum(cast(ab as numeric)) + sum(cast(bb as numeric)) + sum(cast(hbp as numeric)) + sum(cast(sf as numeric))) as On_Base_Percentage
From Ichiro
Group by year, Tm
Order by On_Base_Percentage desc




-- This query calculates Ichiro's total strikeouts per year. Ichiro had the most strikeouts in 2010 with 86.
Select year, tm, Sum(cast(so as numeric)) as Total_Strikeouts
From Ichiro
Group by year, tm
Order by Total_Strikeouts desc
