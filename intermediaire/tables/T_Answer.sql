-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Answer'
    )
    DROP EXTERNAL TABLE Answer

-- create external table
CREATE EXTERNAL TABLE Answer
    WITH (
        LOCATION = 'Answer/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT
    id_owner,
    id_answer
FROM
    ( -- multiple choice question we are interested in :
        -- q2 triggering of the renovation
        -- q3 motivation of the renovation
        -- q4 why owner has not done renovation
        -- q70 known subsidy/help
        -- q71 received subsidy/help
        -- q74 taken loan
        -- q81 what made owner decide to do a renovation

        SELECT id_owner, answer_name
        FROM 
        ( -- Do not select Not answered choices (last option of multiple choice questions)
            SELECT DISTINCT
                Respondent_Serial AS id_owner,
                -- q2 triggering of the renovation
                main_q2_1,
                main_q2_2,
                main_q2_3,
                main_q2_4,
                main_q2_5,
                main_q2_6,
                main_q2_7,
                main_q2_8,
                -- q3 motivation of the renovation
                main_q3_1,
                main_q3_2,
                main_q3_3,
                main_q3_4,
                main_q3_5,
                main_q3_6,
                main_q3_7,
                -- q4 why owner has not done renovation
                main_q4_1,
                main_q4_2,
                main_q4_3,
                main_q4_4,
                main_q4_5,
                main_q4_6,
                main_q4_7,
                main_q4_8,
                -- q70 known subsidy/help
                main_Q70_01,
                main_Q70_02,
                main_Q70_03,
                main_Q70_04,
                main_Q70_05,
                main_Q70_06,
                main_Q70_07,
                main_Q70_08,
                main_Q70_09,
                main_Q70_10,
                main_Q70_11,
                main_Q70_12,
                main_Q70_13,
                main_Q70_14,
                -- q71 received subsidy/help
                main_Q71_01,
                main_Q71_03,
                main_Q71_04,
                main_Q71_05,
                main_Q71_06,
                main_Q71_07,
                main_Q71_08,
                main_Q71_09,
                main_Q71_10,
                main_Q71_11,
                main_Q71_12,
                main_Q71_13,
                main_Q71_14,
                -- q74 taken loan
                main_Q74_1,
                main_Q74_2,
                main_Q74_3,
                main_Q74_4,
                main_Q74_5,
                -- q81 what made owner decide to do a renovation
                main_q81_1,
                main_q81_2,
                main_q81_3,
                main_q81_4,
                main_q81_5,
                main_q81_6,
                main_q81_7
            FROM
                dbo.Tremi
            ) AS a
            UNPIVOT
                (answer_number FOR answer_name IN 
                (main_q2_1, main_q2_2, main_q2_3, main_q2_4, main_q2_5, main_q2_6, main_q2_7, main_q2_8, main_q3_1, main_q3_2, main_q3_3, main_q3_4, main_q3_5, main_q3_6, main_q3_7, main_q4_1, main_q4_2, main_q4_3, main_q4_4, main_q4_5, main_q4_6, main_q4_7, main_q4_8, main_Q70_01, main_Q70_02, main_Q70_03, main_Q70_04, main_Q70_05, main_Q70_06, main_Q70_07, main_Q70_08, main_Q70_09, main_Q70_10, main_Q70_11, main_Q70_12, main_Q70_13, main_Q70_14, main_Q71_01, main_Q71_03, main_Q71_04, main_Q71_05, main_Q71_06, main_Q71_07, main_Q71_08, main_Q71_09, main_Q71_10, main_Q71_11, main_Q71_12, main_Q71_13, main_Q71_14, main_Q74_1, main_Q74_2, main_Q74_3, main_Q74_4, main_Q74_5, main_q81_1, main_q81_2, main_q81_3, main_q81_4, main_q81_5, main_q81_6, main_q81_7)
            ) AS unpvt
        WHERE
            -- only answers with yes
            answer_number = 1
    ) AS a_name
    JOIN
    dbo.Dictionnary AS dict
    ON dict.column_name = a_name.answer_name


