-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Received_help'
    )
    DROP EXTERNAL TABLE Received_help

-- create external table
CREATE EXTERNAL TABLE Received_help
    WITH (
        LOCATION = 'Received_help/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH Aggregated_Help 
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_Q71_01 AS received_transition,
        main_Q71_03 AS received_tva,
        main_Q71_04 AS received_cee,
        main_Q71_05 AS received_anah,
        main_Q71_06 AS received_local_subsidy,
        -- sort regional help to reduce null values (regional help from another region always null)
        -- {1: 'Alsace, Champagne-Ardenne, Lorraine', 2: 'Aquitaine, Limousin, Poitou-Charentes', 3: 'Auvergne, Rhône-Alpes', 4: 'Bourgogne, Franche-Comté', 
        -- 5: 'Bretagne', 6: 'Centre', 99: 'NR', 8: 'I.D.F.', 9: 'Languedoc-Roussillon, Midi-Pyrénées', 10: 'Nord, Pas-de-Calais, Picardie', 
        -- 11: 'Basse-Normandie, Haute-Normandie', 12: 'Pays de la Loire', 13: "Provence-Alpes-Côte d'Azur"}
        case
            WHEN Tremi.main_region IN (10, 11, 9, 12, 6, 2) THEN 
                CASE
                    WHEN Tremi.main_region = 2 THEN
                        Tremi.main_Q71_13
                    WHEN Tremi.main_region = 6 THEN
                        Tremi.main_Q71_12
                    WHEN Tremi.main_region = 9 THEN
                        CASE 
                            WHEN Tremi.main_dep IN (11, 30, 34, 48, 66)THEN
                                Tremi.main_Q71_10
                            ELSE      
                                Tremi.main_Q71_09
                        END
                    WHEN Tremi.main_region = 10 THEN
                        Tremi.main_Q71_07
                    WHEN Tremi.main_region = 11 THEN
                        Tremi.main_Q71_08
                    ELSE -- Tremi.main_region = 12
                        Tremi.main_Q71_11
                END
            ELSE NULL -- no regional subsidy in this region
        END AS received_regional,
        main_Q73 as amount
    FROM
        dbo.Tremi 
    WHERE
        -- has received subsidy and has responded
        Tremi.main_Q71_15 <> 1 AND
        Tremi.main_Q71_14 <> 1
)
SELECT id_owner, help_name, amount
FROM 
   (SELECT id_owner, received_transition, received_tva, received_cee, received_anah, received_local_subsidy, received_regional, amount
   FROM Aggregated_Help) h
UNPIVOT
   (help_answer FOR help_name IN 
      (received_transition, received_tva, received_cee, received_anah, received_local_subsidy, received_regional)
)AS unpvt
WHERE
    -- select only received help
    help_answer = 1

