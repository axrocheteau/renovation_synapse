-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Owner'
    )
    DROP EXTERNAL TABLE Owner

-- create external table
CREATE EXTERNAL TABLE Owner
    WITH (
        LOCATION = 'Owner/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT Distinct
    Respondent_Serial AS id_owner,
    main_rs1 AS gender,
    main_rs2_c AS age,
    main_rs5 AS work_state,
    main_rs6 AS job,
    main_Q100 AS home_state,
    main_Q44 AS arrival_date,
    CASE
        WHEN main_q4_1 IS NULL THEN 0
        ELSE 1
    END AS has_done_renov,
    main_Q52 AS thermal_comfort,
    main_Q53 AS energy_reduction
FROM
    dbo.Tremi 