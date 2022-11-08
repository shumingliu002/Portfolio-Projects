--
--this project is to visualize the relationship between CPI(Consumer Purchasing Index) and Weekly sales in a departmental store
--such an analysis can be used to forecast consumer spending habits

SELECT *
FROM PortfolioProject4.dbo.cpi_data

SELECT *
FROM PortfolioProject4.dbo.sales_data


--change table name for easier access---------------------------------------------

sp_rename 'dbo.cpi_data.CPALTT01USM657N', 'cpi_values', 'COLUMN'


-- Standardize Date Format for sales_data date entries--------------------------------------------------------------------------------

--standardizing date from cpi_data table
select * from information_schema.columns


ALTER TABLE PortfolioProject4.dbo.cpi_data
Add DateConverted Date;

UPDATE PortfolioProject4.dbo.cpi_data
SET DateConverted = CONVERT(Date,Date)


--standardizing data from sales_data table
ALTER TABLE sales_data
Add SalesDateConverted Date;


UPDATE PortfolioProject4.dbo.sales_data
SET SalesDateConverted = CONVERT(NVARCHAR(255),CONVERT(SMALLDATETIME, DATE,103))


--joining sales data table and cpi table via INNER JOIN
SELECT cpi_data.DATE  , cpi_data.cpi_values AS 'Consumer Purchasing Index' , sales_data.Weekly_Sales AS 'Weekly Sale Numbers'
FROM PortfolioProject4.dbo.cpi_data
JOIN PortfolioProject4.dbo.sales_data
ON cpi_data.DateConverted = sales_data.SalesDateConverted
ORDER BY 1




