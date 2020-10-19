CREATE TABLE [trains].[ProductCodesDetails] (
    [ProductSku]                 CHAR (8)      NOT NULL,
    [ChangeableTravelDate]       BIT           NOT NULL,
    [OutgoingDate]               DATETIME      NULL,
    [OutgoingValidityHours]      INT           NULL,
    [ReturnDate]                 DATETIME      NULL,
    [ReturnValidityHours]        INT           NULL,
    [OriginLegacyStationId]      INT           NOT NULL,
    [OriginDescription]          NVARCHAR (50) NOT NULL,
    [DestinationLegacyStationId] INT           NOT NULL,
    [DestinationDescription]     NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ProductCodesDetails] PRIMARY KEY CLUSTERED ([ProductSku] ASC),
    CONSTRAINT [FK_ProductCodesDetails_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku])
);

