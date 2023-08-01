-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Home'
    )
    DROP EXTERNAL TABLE Home

-- create external table
CREATE EXTERNAL TABLE Home
    WITH (
        LOCATION = 'Home/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT Distinct
    Respondent_Serial AS id_owner,
    main_rs102_c AS nb_persons,
    main_RS182 AS income
FROM
    dbo.Tremi