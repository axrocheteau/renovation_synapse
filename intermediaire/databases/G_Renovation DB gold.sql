Use Renovation_gold;
GO;

CREATE EXTERNAL DATA SOURCE licence WITH (
    LOCATION = 'https://datalakerenov.dfs.core.windows.net/storage/files/licence/'
);
GO;

CREATE EXTERNAL DATA SOURCE tremi WITH (
    LOCATION = 'https://datalakerenov.dfs.core.windows.net/storage/files/tremi/'
);
GO;

CREATE EXTERNAL DATA SOURCE pop WITH (
    LOCATION = 'https://datalakerenov.dfs.core.windows.net/storage/files/pop/'
);
GO;

CREATE EXTERNAL DATA SOURCE root WITH (
    LOCATION = 'https://datalakerenov.dfs.core.windows.net/storage/'
);
GO;