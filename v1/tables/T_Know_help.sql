-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Know_help'
    )
    DROP EXTERNAL TABLE Know_help

-- create external table
CREATE EXTERNAL TABLE Know_help
    WITH (
        LOCATION = 'Know_help/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
WITH Aggregated_Help
AS
(
    SELECT Distinct
        Respondent_Serial AS id_owner,
        main_Q70_01 AS known_transition,
        main_Q70_02 AS known_eco_ptz,
        main_Q70_03 AS known_tva,
        main_Q70_04 AS known_cee,
        main_Q70_05 AS known_anah,
        main_Q70_06 AS known_local_subsidy,
        -- sort regional help to reduce null values (regional help from another region always null)
        -- {1: 'Alsace, Champagne-Ardenne, Lorraine', 2: 'Aquitaine, Limousin, Poitou-Charentes', 3: 'Auvergne, Rhône-Alpes', 4: 'Bourgogne, Franche-Comté', 
        -- 5: 'Bretagne', 6: 'Centre', 99: 'NR', 8: 'I.D.F.', 9: 'Languedoc-Roussillon, Midi-Pyrénées', 10: 'Nord, Pas-de-Calais, Picardie', 
        -- 11: 'Basse-Normandie, Haute-Normandie', 12: 'Pays de la Loire', 13: "Provence-Alpes-Côte d'Azur"}
        CASE
            WHEN Tremi.main_region IN (10, 11, 9, 12, 6, 2) THEN 
                CASE
                    WHEN Tremi.main_region = 2 THEN
                        Tremi.main_Q70_13
                    WHEN Tremi.main_region = 6 THEN
                        Tremi.main_Q70_12
                    WHEN Tremi.main_region = 9 THEN
                        CASE 
                            WHEN Tremi.main_dep IN (11, 30, 34, 48, 66)THEN
                                Tremi.main_Q70_10
                            ELSE      
                                Tremi.main_Q70_09
                        END
                    WHEN Tremi.main_region = 10 THEN
                        Tremi.main_Q70_07
                    WHEN Tremi.main_region = 11 THEN
                        Tremi.main_Q70_08
                    ELSE -- Tremi.main_region = 12
                        Tremi.main_Q70_11
                END
            ELSE NULL -- no regional subsidy in this region
        END AS known_regional
    FROM
        dbo.Tremi 
    WHERE
        -- has taken a loan and has responded
        Tremi.main_Q70_15 <> 1 AND
        Tremi.main_Q70_14 <> 1
)
SELECT id_owner, help_name
FROM 
   (SELECT id_owner, known_transition, known_eco_ptz, known_tva, known_cee, known_anah, known_local_subsidy, known_regional
   FROM Aggregated_Help) h
UNPIVOT
   (help_answer FOR help_name IN 
      (known_transition, known_eco_ptz, known_tva, known_cee, known_anah, known_local_subsidy, known_regional)
)AS unpvt
WHERE
    -- select only known help
    help_answer = 1

