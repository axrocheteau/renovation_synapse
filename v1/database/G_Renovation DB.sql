CREATE DATABASE Renovation
COLLATE Latin1_General_100_BIN2_UTF8;
GO;

Use Renovation;
GO;

CREATE EXTERNAL DATA SOURCE licence WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/DatalakeRenovation/permis/'
);
GO;

CREATE EXTERNAL DATA SOURCE tremi WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/DatalakeRenovation/tremi/'
);
GO;

CREATE EXTERNAL DATA SOURCE pop WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/DatalakeRenovation/population/'
);
GO;

CREATE EXTERNAL DATA SOURCE carto WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/DatalakeRenovation/cartographie/'
);
GO;

CREATE EXTERNAL DATA SOURCE root WITH (
    LOCATION = 'https://renovationstockage.dfs.core.windows.net/sysfilesrenovation/'
);
GO;