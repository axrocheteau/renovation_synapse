-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Incentive_works'
    )
    DROP EXTERNAL TABLE Incentive_works

-- create external table
CREATE EXTERNAL TABLE Incentive_works
    WITH (
        LOCATION = 'Incentive_works/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH All_incentive
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_q81_1 AS word_of_mouth,
        main_q81_2 AS mall_seller,
        main_q81_3 AS craftsman,
        main_q81_4 AS energy_advisor,
        main_q81_5 AS advertising,
        main_q81_6 AS energy_supplier,
        main_q81_7 AS research
    FROM
        dbo.Tremi 
    WHERE
        -- remove owners that hasn't done renovation
        main_q81_8 <> 1
)
SELECT id_owner, incentive_name
FROM 
   (SELECT id_owner, word_of_mouth, mall_seller, craftsman, energy_advisor, advertising, energy_supplier, research
    FROM All_incentive) i
UNPIVOT
   (incentive_answer FOR incentive_name IN 
      (word_of_mouth, mall_seller, craftsman, energy_advisor, advertising, energy_supplier, research)
)AS unpvt
WHERE
    -- select only selected answers help
    incentive_answer = 1
