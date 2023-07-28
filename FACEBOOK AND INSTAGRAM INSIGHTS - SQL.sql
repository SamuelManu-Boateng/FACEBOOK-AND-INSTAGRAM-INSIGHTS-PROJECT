--VIEW TABLE

SELECT *
FROM ADVERTS

--DATA CLEANING

--Change Date column data type to DATE
ALTER TABLE 
	ADVERTS
ALTER COLUMN 
	Date DATE

--Change Ad_Spend column data type to MONEY
ALTER TABLE
	ADVERTS
ALTER COLUMN
	AD_SPEND MONEY

--KEY PERFORMANCE INDICATORS (KPIs)

-- KPI 1: Calculate growth rate for Facebook and Instagram audience reach.

-- Monthly growth rate for Facebook Audience reach 
SELECT 
    DATENAME(MONTH, DATEADD(MONTH, Month-1, '1900-01-01')) AS MonthName,
    Total_FB_reach,
    LAG(Total_FB_reach) OVER (ORDER BY Month) AS Previous_Month_FB_reach,
    ROUND((Total_FB_reach - LAG(Total_FB_reach) OVER (ORDER BY Month)) / LAG(Total_FB_reach) OVER (ORDER BY Month) * 100, 2) AS FB_Growth_Rate
	--250753-211093/250753 * 100
	--278785-116110/116110 * 100
FROM
    (	
SELECT 
	DATEPART(MONTH, Date) AS Month,
	SUM(Facebook_Page_reach) AS Total_FB_reach	
FROM ADVERTS
GROUP BY
	DATEPART(MONTH, Date)
	) AS Monthly_FB_Reach
ORDER BY
    Month

--	Monthly growth rate for Instagram Audience reach
SELECT 
    DATENAME(MONTH, DATEADD(MONTH, Month-1, '1900-01-01')) AS MonthName,
    Total_IG_reach,
    LAG(Total_IG_reach) OVER (ORDER BY Month) AS Previous_Month_IG_reach,
    ROUND((Total_IG_reach - LAG(Total_IG_reach) OVER (ORDER BY Month)) / LAG(Total_IG_reach) OVER (ORDER BY Month) * 100, 2) AS IG_Growth_Rate
FROM
    (	
SELECT 
	DATEPART(MONTH, Date) AS Month,
	SUM(Instagram_reach) AS Total_IG_reach	
FROM ADVERTS
GROUP BY
	DATEPART(MONTH, Date)
	) AS Monthly_IG_Reach
ORDER BY
    Month

--KPI 2: Compare Facebook Page Likes and Instagram followers.

-- Check Total FB page likes and IG followers
SELECT 
	SUM(Facebook_Page_likes) AS Total_FB_likes, 
	SUM(Instagram_followers) AS Total_IG_followers
FROM ADVERTS

--Monthly basis
SELECT 
	DATENAME(MONTH, Date) AS MonthName,
	--DATEPART(MONTH, Date) AS Monthnumber,
	SUM(Facebook_Page_likes) AS Total_FB_likes, 
	SUM(Instagram_followers) AS Total_IG_followers
FROM ADVERTS
GROUP BY
	DATENAME(MONTH, Date),
	DATEPART(MONTH, Date)
ORDER BY
    DATEPART(MONTH, Date)

--Calculating MontHly Growth Rate
SELECT 
    DATENAME(MONTH, Date) AS MonthName,
    --DATEPART(MONTH, Date) AS Monthnumber,
    SUM(Facebook_Page_likes) AS Total_FB_likes, 
    SUM(Instagram_followers) AS Total_IG_followers,
    (SUM(Instagram_followers) - LAG(SUM(Instagram_followers), 1, 0) OVER (ORDER BY DATEPART(MONTH, Date))) / LAG(SUM(Instagram_followers), 1, 1) OVER (ORDER BY DATEPART(MONTH, Date)) * 100 AS IG_growth_rate,
    (SUM(Facebook_Page_likes) - LAG(SUM(Facebook_Page_likes), 1, 0) OVER (ORDER BY DATEPART(MONTH, Date))) / LAG(SUM(Facebook_Page_likes), 1, 1) OVER (ORDER BY DATEPART(MONTH, Date)) * 100 AS FB_growth_rate
FROM ADVERTS
GROUP BY
    DATENAME(MONTH, Date),
    DATEPART(MONTH, Date)
ORDER BY
    DATEPART(MONTH, Date)


--	KPI 3: Show on a trend diagram, total amount spent for Ad.
SELECT 
	DATENAME(MONTH, Date) AS MonthName,
	SUM(Ad_Spend) AS Total_Ad_Spend
FROM ADVERTS
GROUP BY
	DATENAME(MONTH, Date),
	DATEPART(MONTH, Date)
ORDER BY
    DATEPART(MONTH, Date)

--KPI 4: Calculate the percentage increase or decrease of Amount spent for Ad.
SELECT 
    MonthName,
     Total_Ad_Spend,
    LAG(Total_Ad_Spend) OVER (ORDER BY Month) AS Previous_Month_Ad_Spend,
    ROUND((Total_Ad_Spend - LAG(Total_Ad_Spend) OVER (ORDER BY Month)) / LAG(Total_Ad_Spend) OVER (ORDER BY Month) * 100, 2) AS AD_Spend_Growth_Rate
FROM
	(
SELECT 
	DATEPART(MONTH, Date) AS Month,
	DATENAME(MONTH, Date) AS MonthName,
	SUM(Ad_Spend) AS Total_Ad_Spend
FROM ADVERTS
GROUP BY
	DATENAME(MONTH, Date),
	DATEPART(MONTH, Date)
	) AS Monthly_FB_Reach
ORDER BY
    Month

--EDA
-- Facebook Conversion rate  = Likes/FB Reach*100
-- Instagram Conversion rate = Followers/IG Reach
-- Ad efficiency = Ad_Spend/Conversions * 100

--VIEW TABLE

SELECT *
FROM ADVERTS



