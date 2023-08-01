-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Region'
    )
    DROP EXTERNAL TABLE Region

-- create external table
CREATE EXTERNAL TABLE Region
    WITH (
        LOCATION = 'Region/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT Distinct
    CODREG AS id_region,
    REG AS name
FROM
    OPENROWSET(
        BULK 'Regions.csv',
        DATA_SOURCE = 'pop',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS reg
