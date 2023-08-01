-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Apartment'
    )
    DROP EXTERNAL TABLE Apartment

-- create external table
CREATE EXTERNAL TABLE Apartment
    WITH (
        LOCATION = 'Apartment/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_housing,
    floor_nb
FROM
    (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY id_owner) AS id_housing,
        type,
        floor_nb
    FROM 
        dbo.StageHousing
    ) AS housing
WHERE
    type = 2 AND -- this housing is a house
    floor_nb IS NOT NULL