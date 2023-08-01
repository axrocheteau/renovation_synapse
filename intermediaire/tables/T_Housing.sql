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
    ROW_NUMBER() OVER(ORDER BY id_owner) AS id_housing,
    *
FROM
    (
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            cd_postal_corrected AS cd_postal,
            main_Q101 AS type,
            main_Q102 AS construction_date,
            main_Q103 AS heating_system,
            main_Q104 AS hot_water_system,
            main_Q41q42 AS surface,
                -- if owner answer yes to this question it means they have done no renovation
            CASE
                WHEN main_Q1_97 = 1 THEN
                0
                ELSE 1
            END AS has_done_renov,
            main_Q43 AS DPE_before,
            main_Q52 AS thermal_comfort,
            main_Q53 AS energy_reduction,
            main_Q38 AS adjoining,
            main_Q39 AS n_floors,
            main_Q40 AS floor_nb
        FROM
            dbo.Tremi
        WHERE
            Respondent_Serial IS NOT NULL
    ) AS tremi