-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Housing'
    )
    DROP EXTERNAL TABLE Housing

-- create external table
CREATE EXTERNAL TABLE Housing
    WITH (
        LOCATION = 'Housing/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_housing,
    type,
    construction_date,
    heating_system,
    hot_water_system,
    surface,
    DPE_before,
    adjoining,
    n_floors,
    floor_nb
FROM
    (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY id_owner) AS id_housing,
        id_owner,
        type,
        construction_date,
        heating_system,
        hot_water_system,
        surface,
        DPE_before,
        adjoining,
        n_floors,
        floor_nb
    FROM
        dbo.StageHousing
    ) AS housing