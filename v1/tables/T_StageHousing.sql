-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'StageHousing'
    )
    DROP EXTERNAL TABLE StageHousing

-- create external table
CREATE EXTERNAL TABLE StageHousing
    WITH (
        LOCATION = 'StageHousing/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT DISTINCT
    Respondent_Serial AS id_owner,
    main_Q101 AS type,
    main_Q102 AS construction_date,
    main_Q103 AS heating_system,
    main_Q104 AS hot_water_system,
    main_Q41q42 AS surface,
    main_Q43 AS DPE_before,
    main_Q38 AS adjoining,
    main_Q39 AS n_floors,
    main_Q40 AS floor_nb
FROM
    dbo.Tremi