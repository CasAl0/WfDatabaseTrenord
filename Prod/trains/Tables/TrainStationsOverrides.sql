CREATE TABLE [trains].[TrainStationsOverrides] (
    [LegacyStationId]    INT           NOT NULL,
    [Description]        VARCHAR (200) NOT NULL,
    [NewLegacyStationId] INT           NULL,
    CONSTRAINT [PK_TrainStationsOverride] PRIMARY KEY CLUSTERED ([LegacyStationId] ASC)
);



