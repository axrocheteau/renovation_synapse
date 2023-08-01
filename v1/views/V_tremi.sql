CREATE OR ALTER VIEW Tremi
AS
SELECT
    *,
    CASE
        WHEN cd_postal < 10000 THEN 
            CONCAT('0', CAST(cd_postal AS VARCHAR(4)))
        ELSE CAST(cd_postal AS VARCHAR(5))
        END AS cd_postal_corrected
FROM
    OPENROWSET(
        BULK '*.csv',
        DATA_SOURCE = 'tremi',
        FORMAT = 'CSV',
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) As Tremi
