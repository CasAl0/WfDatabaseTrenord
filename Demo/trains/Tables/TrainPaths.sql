CREATE TABLE [trains].[TrainPaths] (
    [TrainPathId]        INT          IDENTITY (1, 1) NOT NULL,
    [LegacyPathId]       INT          NULL,
    [SubnetId]           INT          NOT NULL,
    [DepartureStationId] INT          NOT NULL,
    [ArrivalStationId]   INT          NOT NULL,
    [DistanceKm]         INT          NOT NULL,
    [ViaStaionId1]       INT          NOT NULL,
    [ViaStaionId2]       INT          NOT NULL,
    [Valid]              BIT          CONSTRAINT [DF_TrainPaths_Valid] DEFAULT ((1)) NOT NULL,
    [NFPVersion]         VARCHAR (50) NULL,
    CONSTRAINT [PK_TrainPaths] PRIMARY KEY CLUSTERED ([TrainPathId] ASC),
    CONSTRAINT [FK_TrainPaths_TrainStations] FOREIGN KEY ([DepartureStationId]) REFERENCES [trains].[TrainStations] ([TrainStationId]),
    CONSTRAINT [FK_TrainPaths_TrainStations1] FOREIGN KEY ([ArrivalStationId]) REFERENCES [trains].[TrainStations] ([TrainStationId])
);

