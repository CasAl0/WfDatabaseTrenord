CREATE TABLE [trains].[TrainStationsBCK] (
    [TrainStationId]        INT           IDENTITY (1, 1) NOT NULL,
    [LegacyStationId]       INT           NULL,
    [LegacyStationCode]     VARCHAR (10)  NULL,
    [Description]           VARCHAR (200) NOT NULL,
    [WithdrawalCardStation] BIT           NOT NULL,
    [LoadStation]           BIT           NOT NULL,
    [Valid]                 BIT           NOT NULL,
    [Mxp]                   BIT           NOT NULL,
    [SEA]                   BIT           NOT NULL,
    [MirCode]               NVARCHAR (10) NULL,
    [HafasCode]             NVARCHAR (10) NULL,
    [NFPVersion]            VARCHAR (50)  NULL,
    [OrderExpression]       INT           NOT NULL
);

