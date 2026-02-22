CREATE OR ALTER VIEW bi.vw_FactSales_Customer AS
SELECT
    f.*,
    c.CustomerName,
    c.Segment,
    c.Region AS CustomerRegion
FROM bi.FactSales f
LEFT JOIN bi.DimCustomer c
    ON f.CustomerID = c.CustomerID;
GO