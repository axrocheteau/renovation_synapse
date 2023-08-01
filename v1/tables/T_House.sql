-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'House'
    )
    DROP EXTERNAL TABLE House

-- create external table
CREATE EXTERNAL TABLE House
    WITH (
        LOCATION = 'House/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_housing,
    adjoining,
    n_floors
FROM
    (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY id_owner) AS id_housing,
        type,
        adjoining,
        n_floors
    FROM 
        dbo.StageHousing
    ) AS housing
WHERE
    type = 1 AND -- this housing is a house
    (adjoining IS NOT NULL OR
    n_floors IS NOT NULL)