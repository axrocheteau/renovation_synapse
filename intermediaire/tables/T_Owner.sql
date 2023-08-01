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
    -- if owner answer yes to this question it means they have done no renovation
    CASE
        WHEN main_Q1_97 = 1 THEN
        0
        ELSE 1
    END AS has_done_renov,
    main_rs102_c AS nb_persons_home,
    main_RS182 AS income_home,
    main_Q73 AS amount_help,
    main_Q75 AS loan_amount,
    main_Q76 AS loan_duration,
    main_q77 AS loan_rate
FROM
    dbo.Tremi