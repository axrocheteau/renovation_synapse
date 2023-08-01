CREATE OR ALTER VIEW Codebook
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'TREMI_2017_CodeBook_public8.txt',
        DATA_SOURCE = 'tremi',
        FORMAT = 'CSV',
        FIELDTERMINATOR = '\t',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    ) AS dico