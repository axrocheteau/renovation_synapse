-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Not_done'
    )
    DROP EXTERNAL TABLE Not_done

-- create external table
CREATE EXTERNAL TABLE Not_done
    WITH (
        LOCATION = 'Not_done/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH All_renov
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_q4_1 AS thought,
        main_q4_2 AS envy,
        main_q4_3 AS financial,
        main_q4_4 AS economic_benefits,
        main_q4_5 AS hox,
        main_q4_6 AS leaving,
        main_q4_7 AS not_owner,
        main_q4_8 AS no_need
    FROM
        dbo.Tremi 
    Where
        -- remove owner that has done a renovation
        main_q4_9 <> 1
)
SELECT id_owner, reason_name
FROM 
   (SELECT id_owner, thought, envy, financial, economic_benefits, hox, leaving, not_owner, no_need
    FROM All_renov) r
UNPIVOT
   (reason_answer FOR reason_name IN 
      (thought, envy, financial, economic_benefits, hox, leaving, not_owner, no_need)
)AS unpvt
WHERE
    -- select only selected reasons help
    reason_answer = 1