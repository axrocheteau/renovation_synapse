CREATE OR ALTER VIEW Dpe
AS
SELECT
    date_etablissement_dpe AS date_dpe,
    consommation_energie AS energy_consumption,
    CASE
        WHEN classe_consommation_energie = 'A' THEN 1.0
        WHEN classe_consommation_energie = 'B' THEN 2.0
        WHEN classe_consommation_energie = 'C' THEN 3.0
        WHEN classe_consommation_energie = 'D' THEN 4.0
        WHEN classe_consommation_energie = 'E' THEN 5.0
        WHEN classe_consommation_energie = 'F' THEN 6.0
        WHEN classe_consommation_energie = 'G' THEN 7.0
        ELSE 0.0
        END AS dpe,
    estimation_ges AS gas_emission,
    CASE
        WHEN classe_estimation_ges = 'A' THEN 1.0
        WHEN classe_estimation_ges = 'B' THEN 2.0
        WHEN classe_estimation_ges = 'C' THEN 3.0
        WHEN classe_estimation_ges = 'D' THEN 4.0
        WHEN classe_estimation_ges = 'E' THEN 5.0
        WHEN classe_estimation_ges = 'F' THEN 6.0
        WHEN classe_estimation_ges = 'G' THEN 7.0
        ELSE 0.0  
        END AS ges,
    annee_construction AS construction_date,
    surface_thermique_lot AS thermal_surface,
    tr001_modele_dpe_type_libelle AS dpe_type,
    tr002_type_batiment_description AS housing_type,
    code_insee_commune_actualise AS id_commune,
    tv016_departement_code AS id_dep
FROM
    OPENROWSET(
        BULK 'files/dpe-france.csv',
        DATA_SOURCE = 'root',
        FORMAT = 'CSV',
        FIELDTERMINATOR = ',',
        FIRSTROW = 2,
        CODEPAGE = 'RAW'
    ) 
    WITH(
        nom_methode_dpe VARCHAR(255) COLLATE Latin1_General_100_BIN2_UTF8,
        version_methode_dpe VARCHAR(255) COLLATE Latin1_General_100_BIN2_UTF8,
        date_etablissement_dpe DATE,
        consommation_energie FLOAT,
        classe_consommation_energie VARCHAR(1),
        estimation_ges FLOAT,
        classe_estimation_ges VARCHAR(1),
        annee_construction INT,
        surface_thermique_lot FLOAT,
        latitude FLOAT,
        longitude FLOAT,
        tr001_modele_dpe_type_libelle VARCHAR(255),
        tr002_type_batiment_description VARCHAR(255),
        code_insee_commune_actualise VARCHAR(255),
        tv016_departement_code VARCHAR(255),
        geo_adresse VARCHAR(255),
        geo_score VARCHAR(255)
    ) AS dpe
WHERE
    date_etablissement_dpe >= '2014-01-01' AND
    date_etablissement_dpe < '2017-01-01' AND
    classe_consommation_energie <> 'N' AND
    classe_estimation_ges <> 'N' AND
    annee_construction < 2017 -- eliminate invalid values