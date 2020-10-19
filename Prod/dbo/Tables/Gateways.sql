CREATE TABLE [dbo].[Gateways] (
    [GatewayId]  INT          NOT NULL,
    [GatewayKey] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_Gateways] PRIMARY KEY CLUSTERED ([GatewayId] ASC)
);

