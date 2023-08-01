-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Renovation'
    )
    DROP EXTERNAL TABLE Renovation

-- create external table
CREATE EXTERNAL TABLE Renovation
    WITH (
        LOCATION = 'Renovation/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    ROW_NUMBER() OVER(ORDER BY id_owner) AS id_renov, 
    *
FROM
    ( -- separate the question 5,6,18,20 to correspond to the type of renovation they are referring to
      -- exemple : main_q5_11 refers to roof with isulation
      -- whereas main_q5_12 refers to roof without insulation 
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'roof_with_insulation' AS work_type,
            11 AS work_type_number,
            main_Q5_11 AS start_date,
            main_Q6_11 AS end_date,
            main_Q18_11 AS done_by,
            main_Q20_11 AS amount
            FROM
            dbo.Tremi
        WHERE
            main_Q1_11 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'rooth_without_insulation' AS work_type,
            12 AS work_type_number,
            main_Q5_12 AS start_date,
            main_Q6_12 AS end_date,
            main_Q18_12 AS done_by,
            main_Q20_12 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_12 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'insulation_roof_without_renovation' AS work_type,
            13 AS work_type_number,
            main_Q5_13 AS start_date,
            main_Q6_13 AS end_date,
            main_Q18_13 AS done_by,
            main_Q20_13 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_13 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'insulation_flooring_attic' AS work_type,
            14 AS work_type_number,
            main_Q5_14 AS start_date,
            main_Q6_14 AS end_date,
            main_Q18_14 AS done_by,
            main_Q20_14 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_14 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'roof_terrace_with_insulation' AS work_type,
            15 AS work_type_number,
            main_Q5_15 AS start_date,
            main_Q6_15 AS end_date,
            main_Q18_15 AS done_by,
            main_Q20_15 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_15 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'roof_terrase_without_insulation' AS work_type,
            16 AS work_type_number,
            main_Q5_16 AS start_date,
            main_Q6_16 AS end_date,
            main_Q18_16 AS done_by,
            main_Q20_16 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_16 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'ext_wall_with_insulation' AS work_type,
            21 AS work_type_number,
            main_Q5_21 AS start_date,
            main_Q6_21 AS end_date,
            main_Q18_21 AS done_by,
            main_Q20_21 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_21 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'ext_wall_without_insulation' AS work_type,
            22 AS work_type_number,
            main_Q5_22 AS start_date,
            main_Q6_22 AS end_date,
            main_Q18_22 AS done_by,
            main_Q20_22 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_22 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'int_wall_with_insulation' AS work_type,
            23 AS work_type_number,
            main_Q5_23 AS start_date,
            main_Q6_23 AS end_date,
            main_Q18_23 AS done_by,
            main_Q20_23 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_23 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'int_wall_without_insulation' AS work_type,
            24 AS work_type_number,
            main_Q5_24 AS start_date,
            main_Q6_24 AS end_date,
            main_Q18_24 AS done_by,
            main_Q20_24 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_24 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'down_flooring_with_insulation' AS work_type,
            31 AS work_type_number,
            main_Q5_31 AS start_date,
            main_Q6_31 AS end_date,
            main_Q18_31 AS done_by,
            main_Q20_31 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_31 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'down_flooring_without_insulation' AS work_type,
            32 AS work_type_number,
            main_Q5_32 AS start_date,
            main_Q6_32 AS end_date,
            main_Q18_32 AS done_by,
            main_Q20_32 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_32 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'opening_common_areas' AS work_type,
            41 AS work_type_number,
            main_Q5_41 AS start_date,
            main_Q6_41 AS end_date,
            NULL AS done_by,
            NULL AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_41 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'opening_accomodation' AS work_type,
            42 AS work_type_number,
            main_Q5_42 AS start_date,
            main_Q6_42 AS end_date,
            main_Q18_42 AS done_by,
            main_Q20_42 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_42 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'ext_doors' AS work_type,
            43 AS work_type_number,
            main_Q5_43 AS start_date,
            main_Q6_43 AS end_date,
            main_Q18_43 AS done_by,
            main_Q20_43 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_43 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'heating_system' AS work_type,
            51 AS work_type_number,
            main_Q5_51 AS start_date,
            main_Q6_51 AS end_date,
            main_Q18_51 AS done_by,
            main_Q20_51 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_51 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'heating_regulation' AS work_type,
            52 AS work_type_number,
            main_Q5_52 AS start_date,
            main_Q6_52 AS end_date,
            main_Q18_52 AS done_by,
            main_Q20_52 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_52 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'hot_water' AS work_type,
            53 AS work_type_number,
            main_Q5_53 AS start_date,
            main_Q6_53 AS end_date,
            main_Q18_53 AS done_by,
            main_Q20_53 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_53 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'insulation' AS work_type,
            54 AS work_type_number,
            main_Q5_54 AS start_date,
            main_Q6_54 AS end_date,
            main_Q18_54 AS done_by,
            main_Q20_54 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_54 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'ventilation_system' AS work_type,
            55 AS work_type_number,
            main_Q5_55 AS start_date,
            main_Q6_55 AS end_date,
            main_Q18_55 AS done_by,
            main_Q20_55 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_55 = 1
        UNION ALL
        SELECT DISTINCT
            Respondent_Serial AS id_owner,
            'air_consitioning_system' AS work_type,
            56 AS work_type_number,
            main_Q5_56 AS start_date,
            main_Q6_56 AS end_date,
            main_Q18_56 AS done_by,
            main_Q20_56 AS amount
        FROM
            dbo.Tremi
        WHERE
            main_Q1_56 = 1
    ) AS renov