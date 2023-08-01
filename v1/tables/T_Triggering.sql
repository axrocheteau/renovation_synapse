-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Triggering'
    )
    DROP EXTERNAL TABLE Triggering

-- create external table
CREATE EXTERNAL TABLE Triggering
    WITH (
        LOCATION = 'Triggering/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH All_trigger
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_q2_1 AS damage_replacement,
        main_q2_2 AS funding_opportunity,
        main_q2_3 AS DPE,
        main_q2_4 AS development_works,
        main_q2_5 AS acquaintances_renovation,
        main_q2_6 AS favorable_time,
        main_q2_7 AS landlord_co_ownership,
        main_q2_8 AS nothing_peculiar
    FROM
        dbo.Tremi 
    WHERE
        -- has responded
        Tremi.main_q2_9 <> 1
)
SELECT id_owner, reason_name
FROM 
   (SELECT id_owner, damage_replacement, funding_opportunity, DPE, development_works, acquaintances_renovation, favorable_time, landlord_co_ownership, nothing_peculiar
   FROM All_trigger) t
UNPIVOT
   (triggering_answer FOR reason_name IN 
      (damage_replacement, funding_opportunity, DPE, development_works, acquaintances_renovation, favorable_time, landlord_co_ownership, nothing_peculiar)
)AS unpvt
WHERE
    -- select only selected answer
    triggering_answer = 1

