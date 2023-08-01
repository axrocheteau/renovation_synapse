-- drop existing table
IF EXISTS (
        SELECT * FROM sys.external_tables
        WHERE name = 'Commune'
    )
    DROP EXTERNAL TABLE Commune

-- create external table
CREATE EXTERNAL TABLE Commune
    WITH (
        LOCATION = 'Commune/',
        DATA_SOURCE = relationalDB,
        FILE_FORMAT = ParquetFormat
    )
AS
SELECT DISTINCT
    ROW_NUMBER() OVER(ORDER BY pop.id_commune) AS id_commune,
    pop.id_commune AS code_insee,
    code.code_postal AS cd_postal, -- carefull, a postal code can lead to several towns 
    pop.name AS commune_name,
    pop.id_department AS department_number,
    region.department_name,
    region.former_region_number,
    region.former_region_name,
    region.new_region_name,
    region.new_region_number,
    pop.population,
    -- if no licence in the town then put the number to 0
    CASE
        WHEN pa.nb_pa IS NULL THEN 0
        ELSE pa.nb_pa 
        END AS n_development_licence,
    CASE
        WHEN pc.nb_housing_created IS NULL THEN 0
        ELSE pc.nb_housing_created 
        END AS n_construction_licence,
    CASE
        WHEN pd.nb_pd IS NULL THEN 0
        ELSE pd.nb_pd
        END AS n_destruction_licence,
    dpe.n_dpe,
    dpe.avg_dpe,
    dpe.avg_ges,
    consumption.consumption_by_residence
FROM
    ( -- population of the town
    SELECT
        DEPCOM AS id_commune,
        SUBSTRING(DEPCOM, 1, 2) AS id_department,
        COM AS name,
        PTOT AS population
    FROM
        OPENROWSET(
            BULK 'Communes.csv',
            DATA_SOURCE = 'pop',
            FORMAT = 'CSV',
            FIELDTERMINATOR = ';',
            FIRSTROW = 2,
            CODEPAGE = 'RAW'
        ) 
        WITH (
            DEPCOM VARCHAR(10) COLLATE Latin1_General_100_BIN2_UTF8,
            COM VARCHAR(255),
            PMUN bigint,
            PCA bigint,
            PTOT bigint
        ) AS pop
    ) AS pop
    LEFT JOIN
    ( -- devlopment licence
    SELECT
        COMM AS id_commune,
        Count(*) AS nb_pa
    FROM
        dbo.Development_licence
    GROUP BY
        COMM
    ) AS pa
    ON pop.id_commune  = pa.id_commune
    LEFT JOIN
    ( -- construction licence
        SELECT
            COMM AS id_commune,
            SUM(NB_LGT_TOT_CREES) AS nb_housing_created
        FROM
            dbo.Construction_licence
        GROUP BY
            COMM
    ) AS pc
    ON pop.id_commune  = pc.id_commune
    LEFT JOIN
    ( -- destruction licence
        SELECT
            COMM AS id_commune,
            Count(*) AS nb_pd
        FROM
            dbo.Destruction_licence
        GROUP BY
            COMM
    ) AS pd
    ON pop.id_commune = pd.id_commune
    LEFT JOIN
    ( -- dpe
        SELECT
            id_commune,
            COUNT(*) AS n_dpe,
            ROUND(AVG(dpe), 2) AS avg_dpe,
            ROUND(AVG(ges), 2) AS avg_ges
        FROM
            dbo.Dpe
        GROUP BY
            id_commune
    ) AS dpe
    ON pop.id_commune = dpe.id_commune
    LEFT JOIN
    ( -- code postal
        SELECT
            Code_commune_INSEE as id_commune,
            Code_postal as code_postal
        FROM
            OPENROWSET(
            BULK 'files/code_commune.csv',
            DATA_SOURCE = 'root',
            FORMAT = 'CSV',
            FIELDTERMINATOR = ';',
            FIRSTROW = 2,
            CODEPAGE = 'RAW'
        ) 
        WITH (
            Code_commune_INSEE VARCHAR(10),
            Nom_commune VARCHAR(255),
            Code_postal VARCHAR(10),
            Ligne_5 VARCHAR(255),
            Libellé_d_acheminement VARCHAR(255),
            coordonnees_gps VARCHAR(255)
        ) AS code
    ) AS code
    ON pop.id_commune = code.id_commune
    LEFT JOIN
    ( -- elec consumption
        SELECT
            id_commune,
            ROUND(AVG(consumption_by_residence),2) AS consumption_by_residence
        FROM
            dbo.Electric_comsumption
        GROUP BY
            id_commune
    ) AS consumption
    ON pop.id_commune = consumption.id_commune
    JOIN
    ( -- region nd dep names and numbers
        SELECT DISTINCT
            new_ancient."Anciens Code" AS former_region_number,
            new_ancient."Anciens Nom" AS former_region_name,
            new_ancient."Nouveau Nom" AS new_region_name,
            new_ancient."Nouveau Code" AS new_region_number,
            dep.CODDEP AS departement_number,
            dep.DEP AS department_name
        FROM
            dbo.Development_licence AS dl,
            OPENROWSET(
                BULK 'Departements.csv',
                DATA_SOURCE = 'pop',
                FORMAT = 'CSV',
                HEADER_ROW = TRUE,
                FIELDTERMINATOR = ';',
                ROWTERMINATOR = '\n',
                PARSER_VERSION = '2.0'
            ) AS dep,
            OPENROWSET(
                BULK 'files/anciennes-nouvelles-regions.csv',
                DATA_SOURCE = 'root',
                FORMAT = 'CSV',
                HEADER_ROW = TRUE,
                FIELDTERMINATOR = ';',
                ROWTERMINATOR = '\n',
                PARSER_VERSION = '2.0'
            ) AS new_ancient
        WHERE
            dl.DEP = dep.CODDEP AND
            new_ancient."Anciens Code" = dl.REG
    ) AS region
    ON pop.id_department = region.departement_number
