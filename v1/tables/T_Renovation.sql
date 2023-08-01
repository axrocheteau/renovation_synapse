-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Renovation'
    )
    DROP EXTERNAL TABLE Renovation

-- create external table
CREATE EXTERNAL TABLE Renovation
    WITH (
        LOCATION = 'Renovation/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_renov,
    stage_renov.id_owner,
    cd_postal,
    id_housing,
    work_type,
    start_date,
    end_date,
    done_by,
    amount
FROM
    (
        SELECT
            ROW_NUMBER() OVER(ORDER BY id_owner) AS id_renov,
            cd_postal,
            id_owner,
            work_type,
            start_date,
            end_date,
            done_by,
            amount
        FROM
            dbo.StageRenovation
    ) AS stage_renov
    LEFT JOIN
    (
        SELECT 
            ROW_NUMBER() OVER(ORDER BY id_owner) AS id_housing,
            id_owner
        FROM dbo.StageHousing
    ) AS housing
    ON stage_renov.id_owner = housing.id_owner
