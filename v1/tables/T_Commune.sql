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
    pop.id_commune,
    code.code_postal AS cd_postal,
    pop.id_department,
    pop.name,
    pop.population,
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
    (
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
    (
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
    (
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
    (
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
    (
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
    (
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
    (
        SELECT
            id_commune,
            ROUND(AVG(consumption_by_residence),2) AS consumption_by_residence
        FROM
            dbo.Electric_comsumption
        GROUP BY
            id_commune
    ) AS consumption
    ON pop.id_commune = consumption.id_commune
