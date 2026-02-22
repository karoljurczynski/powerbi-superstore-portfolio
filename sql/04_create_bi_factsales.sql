/* Build FactSales with typed columns + join to Returns */

IF OBJECT_ID('bi.FactSales','U') IS NOT NULL DROP TABLE bi.FactSales;
GO

SELECT
    TRY_CAST(o.Row_ID AS BIGINT) AS SalesKey,

    CAST(o.Order_ID AS NVARCHAR(50)) AS OrderID,

    -- Source dates are M/D/YYYY -> style 101
    TRY_CONVERT(date, o.Order_Date, 101) AS OrderDate,
    TRY_CONVERT(date, o.Ship_Date, 101)  AS ShipDate,

    CAST(o.Ship_Mode      AS NVARCHAR(50)) AS ShipMode,
    CAST(o.Order_Priority AS NVARCHAR(30)) AS OrderPriority,

    CAST(o.Customer_ID AS NVARCHAR(50)) AS CustomerID,
    CAST(o.Product_ID  AS NVARCHAR(50)) AS ProductID,

    CAST(o.Region AS NVARCHAR(50)) AS Region,
    CAST(o.Market AS NVARCHAR(50)) AS Market,

    CAST(o.Country     AS NVARCHAR(50))  AS Country,
    CAST(o.State       AS NVARCHAR(50))  AS State,
    CAST(o.City        AS NVARCHAR(100)) AS City,
    CAST(o.Postal_Code AS NVARCHAR(20))  AS PostalCode,

    -- Handle decimal comma and spaces
    TRY_CAST(REPLACE(REPLACE(o.Sales,         ' ', ''), ',', '.') AS DECIMAL(18,2)) AS Sales,
    TRY_CAST(REPLACE(REPLACE(o.Profit,        ' ', ''), ',', '.') AS DECIMAL(18,2)) AS Profit,
    TRY_CAST(REPLACE(REPLACE(o.Shipping_Cost, ' ', ''), ',', '.') AS DECIMAL(18,2)) AS ShippingCost,

    TRY_CAST(REPLACE(o.Quantity, ',', '.') AS INT)          AS Quantity,
    TRY_CAST(REPLACE(o.Discount, ',', '.') AS DECIMAL(9,4)) AS Discount,

    ISNULL(r.IsReturned, 0) AS IsReturned
INTO bi.FactSales
FROM stg.Orders o
LEFT JOIN bi.Returns r
    ON CAST(o.Order_ID AS NVARCHAR(50)) = r.OrderID;
GO

-- If SalesKey isn't reliable, add identity surrogate
IF EXISTS (SELECT 1 FROM bi.FactSales WHERE SalesKey IS NULL)
BEGIN
    ALTER TABLE bi.FactSales ADD SalesKey2 BIGINT IDENTITY(1,1);
END
GO

-- Optional PK on SalesKey if unique and not null
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_bi_FactSales')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM bi.FactSales WHERE SalesKey IS NULL)
       AND NOT EXISTS (
            SELECT SalesKey
            FROM bi.FactSales
            GROUP BY SalesKey
            HAVING COUNT(*) > 1
       )
    BEGIN
        ALTER TABLE bi.FactSales
        ADD CONSTRAINT PK_bi_FactSales PRIMARY KEY (SalesKey);
    END
END
GO