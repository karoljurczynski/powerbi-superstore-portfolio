/* Build BI dimensions from stg.Orders */

IF OBJECT_ID('bi.DimCustomer','U') IS NOT NULL DROP TABLE bi.DimCustomer;
IF OBJECT_ID('bi.DimProduct','U')  IS NOT NULL DROP TABLE bi.DimProduct;
GO

-- Customer dimension
SELECT DISTINCT
    CAST(Customer_ID   AS NVARCHAR(50))  AS CustomerID,
    CAST(Customer_Name AS NVARCHAR(200)) AS CustomerName,
    CAST(Segment       AS NVARCHAR(50))  AS Segment,
    CAST(Region        AS NVARCHAR(50))  AS Region,
    CAST(Market        AS NVARCHAR(50))  AS Market,
    CAST(Country       AS NVARCHAR(50))  AS Country,
    CAST(State         AS NVARCHAR(50))  AS State,
    CAST(City          AS NVARCHAR(100)) AS City,
    CAST(Postal_Code   AS NVARCHAR(20))  AS PostalCode
INTO bi.DimCustomer
FROM stg.Orders
WHERE NULLIF(LTRIM(RTRIM(Customer_ID)), '') IS NOT NULL;
GO

ALTER TABLE bi.DimCustomer
ALTER COLUMN CustomerID NVARCHAR(50) NOT NULL;
GO

ALTER TABLE bi.DimCustomer
ADD CONSTRAINT PK_bi_DimCustomer PRIMARY KEY (CustomerID);
GO

-- Product dimension
SELECT DISTINCT
    CAST(Product_ID   AS NVARCHAR(50))  AS ProductID,
    CAST(Product_Name AS NVARCHAR(250)) AS ProductName,
    CAST(Category     AS NVARCHAR(50))  AS Category,
    CAST(Sub_Category AS NVARCHAR(50))  AS SubCategory
INTO bi.DimProduct
FROM stg.Orders
WHERE NULLIF(LTRIM(RTRIM(Product_ID)), '') IS NOT NULL;
GO

ALTER TABLE bi.DimProduct
ALTER COLUMN ProductID NVARCHAR(50) NOT NULL;
GO

ALTER TABLE bi.DimProduct
ADD CONSTRAINT PK_bi_DimProduct PRIMARY KEY (ProductID);
GO