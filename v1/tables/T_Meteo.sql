-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Meteo'
    )
    DROP EXTERNAL TABLE Meteo

-- create external table
CREATE EXTERNAL TABLE Meteo
    WITH (
        LOCATION = 'Meteo/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_commune,
    year AS year,
    month AS month,
    ROUND(AVG(wind_direction),2) AS wind_direction,
    ROUND(AVG(wind_speed),2) AS wind_speed,
    ROUND(AVG(temp_kelvin),2) AS temp_kelvin,
    ROUND(AVG(humidity),2) AS humidity,
    ROUND(AVG(heigh_clouds),2) AS heigh_clouds,
    ROUND(AVG(temp_degree),2) AS temp_degree,
    ROUND(AVG(altitude),2) AS altitude
FROM
    dbo.View_Meteo
WHERE
    id_commune IS NOT NULL
GROUP BY
    year, month, id_commune
