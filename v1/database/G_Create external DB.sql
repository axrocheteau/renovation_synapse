Use Renovation;
GO;

CREATE EXTERNAL DATA SOURCE relationalDB WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/relationalDB/'
);
GO;

-- Format for table files
CREATE EXTERNAL FILE FORMAT ParquetFormat
    WITH (
            FORMAT_TYPE = PARQUET,
            DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
        );
GO;