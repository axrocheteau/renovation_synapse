CREATE OR ALTER VIEW Destruction_licence
AS
SELECT
    REG,
    DEP,
    COMM,
    Num_PD,
    Etat_PD,
    DATE_REELLE_AUTORISATION,
    SUPERFICIE_TERRAIN
FROM
    OPENROWSET(
        BULK 'detruire/permis_demolir.csv',
        DATA_SOURCE = 'licence',
        FORMAT = 'CSV',
        FIELDTERMINATOR = ';',
        FIRSTROW = 2,
        CODEPAGE = 'RAW'
    ) 
    WITH (
        REG VARCHAR(10),
        DEP VARCHAR(10),
        COMM VARCHAR(10),
        Num_PD VARCHAR(255),
        Etat_PD VARCHAR(255),
        DATE_REELLE_AUTORISATION DATE,
        AN_DEPOT INT,
        DPC_PREM VARCHAR(255),
        DPC_AUT VARCHAR(255),
        DPC_DERN VARCHAR(255),
        APE_DEM VARCHAR(255),
        CJ_DEM VARCHAR(255),
        DENOM_DEM VARCHAR(255),
        SIREN_DEM VARCHAR(255),
        SIRET_DEM VARCHAR(255),
        CODPOST_DEM VARCHAR(255),
        LOCALITE_DEM VARCHAR(255),
        REC_ARCHI VARCHAR(255),
        ADR_NUM_TER VARCHAR(255),
        ADR_TYPEVOIE_TER VARCHAR(255),
        ADR_LIBVOIE_TER VARCHAR(255),
        ADR_LIEUDIT_TER VARCHAR(255),
        ADR_LOCALITE_TER VARCHAR(255),
        ADR_CODPOST_TER VARCHAR(255),
        sec_cadastre1 VARCHAR(255),
        num_cadastre1 VARCHAR(255),
        sec_cadastre2 VARCHAR(255),
        num_cadastre2 VARCHAR(255),
        sec_cadastre3 VARCHAR(255),
        num_cadastre3 VARCHAR(255),
        SUPERFICIE_TERRAIN BIGINT,
        ZONE_OP VARCHAR(255)
    ) AS pd
WHERE
    DATE_REELLE_AUTORISATION >= '2014-01-01' AND
    DATE_REELLE_AUTORISATION < '2017-01-01'