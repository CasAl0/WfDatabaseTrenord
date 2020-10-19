CREATE TABLE [trains].[SpecialTrains] (
    [SpecialTrainId]             INT           IDENTITY (1, 1) NOT NULL,
    [TrainNumber]                VARCHAR (10)  NOT NULL,
    [TrainCategoryCode]          VARCHAR (10)  NOT NULL,
    [OriginLegacyStationId]      INT           NULL,
    [OriginDescription]          NVARCHAR (50) NOT NULL,
    [DestinationLegacyStationId] INT           NULL,
    [DestinationDescription]     NVARCHAR (50) NOT NULL,
    [DepartureTime]              DATETIME      NOT NULL,
    [ArrivalTime]                DATETIME      NOT NULL,
    [TotalPassengerNumber]       INT           NOT NULL,
    [TargetPassengerNumber]      INT           NULL,
    [ReservedPassengerNumber]    INT           NOT NULL,
    [ReturnTrain]                BIT           NOT NULL,
    [DisabledPeopleTrain]        BIT           NOT NULL,
    [SpecialTrainsDirectionId]   INT           NOT NULL,
    CONSTRAINT [PK_SpecialTrains] PRIMARY KEY CLUSTERED ([SpecialTrainId] ASC),
    CONSTRAINT [FK_SpecialTrains_SpecialTrainsDirections] FOREIGN KEY ([SpecialTrainsDirectionId]) REFERENCES [trains].[SpecialTrainsDirections] ([SpecialTrainsDirectionId])
);







