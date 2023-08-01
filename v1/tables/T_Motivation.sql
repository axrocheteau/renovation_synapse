-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Motivation'
    )
    DROP EXTERNAL TABLE Motivation

-- create external table
CREATE EXTERNAL TABLE Motivation
    WITH (
        LOCATION = 'Motivation/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH All_motivation
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_q3_1 AS reduce_invoice,
        main_q3_2 AS value_property,
        main_q3_3 AS heat,
        main_q3_4 AS soundproof,
        main_q3_5 AS air_quality,
        main_q3_6 AS gesture_environnement,
        main_q3_7 AS embellish
    FROM
        dbo.Tremi
    WHERE
        -- has taken a loan and has responded
        Tremi.main_q3_8 <> 1
)
SELECT id_owner, reason_name
FROM 
   (SELECT id_owner, reduce_invoice, value_property, heat, soundproof, air_quality, gesture_environnement, embellish
   FROM All_motivation) l
UNPIVOT
   (motivation_answer FOR reason_name IN 
      (reduce_invoice, value_property, heat, soundproof, air_quality, gesture_environnement, embellish)
)AS unpvt
WHERE
    -- select only taken loans
    motivation_answer = 1

