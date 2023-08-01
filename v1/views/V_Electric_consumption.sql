CREATE OR ALTER VIEW Electric_comsumption
AS
SELECT
    "Année" AS year,
    "Consommation Résidentiel  (MWh)" AS consumption,
    "Nombre de points Résidentiel" AS n_residence,
    "Nombre de mailles secretisées (résidentiel)" AS mesh,
    "Indice qualité Résidentiel" AS quality_index,
    "Code Commune" AS id_commune,
    "Libellé Commune" AS commune_name,
    CASE
        WHEN "Nombre de points Résidentiel" <> 0 AND "Nombre de points Résidentiel" IS NOT NULL THEN
            ROUND("Consommation Résidentiel  (MWh)"/"Nombre de points Résidentiel",2)
        ELSE
            NULL
        END AS consumption_by_residence
FROM
    OPENROWSET(
        BULK 'DatalakeRenovation/elec.csv',
        DATA_SOURCE = 'root',
        FORMAT = 'CSV',
        FIELDTERMINATOR = ';',
        FIRSTROW = 2,
        CODEPAGE = 'RAW'
    ) 
    WITH(
        "Opérateur" VARCHAR(50),
        "Année" INT,
        "Filière" VARCHAR(50),
        "Consommation Agriculture (MWh)" FLOAT,
        "Nombre de points Agriculture" INT,
        "Nombre de mailles secretisées (agriculture)" INT,
        "Indique qualité Agriculture" FLOAT,
        "Consommation Industrie (MWh)" FLOAT,
        "Nombre de points Industrie" INT,
        "Nombre de mailles secretisées (industrie)" INT,
        "Indice qualité Industrie" FLOAT,
        "Consommation Tertiaire  (MWh)" FLOAT,
        "Nombre de points Tertiaire" VARCHAR(255),
        "Nombre de mailles secretisées (tertiaire)" VARCHAR(255),
        "Indice qualité Tertiaire" VARCHAR(255),
        "Consommation Résidentiel  (MWh)" FLOAT,
        "Nombre de points Résidentiel" INT,
        "Nombre de mailles secretisées (résidentiel)" INT,
        "Indice qualité Résidentiel" FLOAT,
        "Thermosensibilité (MWh/degré-jour)" FLOAT,
        "Part Thermosensible" FLOAT,
        "Consommation Secteur Inconnu (MWh)" FLOAT,
        "Nombre de points Secteur Inconnu" INT,
        "Nombre de mailles secretisées (secteur inconnu)" INT,
        "Indice qualité Non Affecté" FLOAT,
        "Code Commune" VARCHAR(10),
        "Libellé Commune" VARCHAR(255),
        "Code EPCI" VARCHAR(255),
        "Libellé EPCI" VARCHAR(255),
        "Code Département" VARCHAR(10),
        "Libellé Département" VARCHAR(255),
        "Code Région" VARCHAR(10),
        "Libellé Région" VARCHAR(255),
        "id_filiere" INT,
        "Consommation totale (MWh)" FLOAT,
        "Code_postal" VARCHAR(10)
    ) AS conso
WHERE
    "Année" > 2013 AND
    "Année" < 2017