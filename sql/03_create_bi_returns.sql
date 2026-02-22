/* Curate returns table */

IF OBJECT_ID('bi.Returns','U') IS NOT NULL DROP TABLE bi.Returns;
GO

SELECT DISTINCT
    CAST(Order_ID AS NVARCHAR(50)) AS OrderID,
    CASE
        WHEN UPPER(LTRIM(RTRIM(CAST(Returned AS NVARCHAR(20))))) IN ('YES','Y','TRUE','1') THEN 1
        ELSE 0
    END AS IsReturned
INTO bi.Returns
FROM stg.Returns;
GO

ALTER TABLE bi.Returns
ALTER COLUMN OrderID NVARCHAR(50) NOT NULL;
GO

ALTER TABLE bi.Returns
ADD CONSTRAINT PK_bi_Returns PRIMARY KEY (OrderID);
GO