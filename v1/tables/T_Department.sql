-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Department'
    )
    DROP EXTERNAL TABLE Department

-- create external table
CREATE EXTERNAL TABLE Department
    WITH (
        LOCATION = 'Department/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT Distinct
    dl.REG AS id_region,
    dl.DEP AS id_department,
    dep.DEP AS name
FROM
    dbo.Development_licence AS dl,
    OPENROWSET(
        BULK 'Departements.csv',
        DATA_SOURCE = 'pop',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0'
    ) AS dep
WHERE
    dl.DEP = dep.CODDEP
