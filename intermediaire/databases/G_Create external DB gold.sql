CREATE DATABASE Renovation_gold
COLLATE Latin1_General_100_BIN2_UTF8;
GO;

Use Renovation_gold;
GO;

CREATE EXTERNAL DATA SOURCE relationalDB WITH (
    LOCATION = 'https://datalakerenov.dfs.core.windows.net/storage/goldDB/'
);
GO;

-- Format for table files
CREATE EXTERNAL FILE FORMAT ParquetFormat
    WITH (
            FORMAT_TYPE = PARQUET,
            DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
        );
GO;