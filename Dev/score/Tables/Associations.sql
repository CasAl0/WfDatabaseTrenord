CREATE TABLE [score].[Associations] (
    [AssociationId]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [InternalUserName] NVARCHAR (50) NOT NULL,
    [PartnerId]        INT           NOT NULL,
    [PartnerUserName]  NVARCHAR (50) NOT NULL,
    [AssociationDate]  DATETIME      NOT NULL,
    [ValidFrom]        DATE          NOT NULL,
    [ValidTo]          DATE          NOT NULL,
    [LastUpdate]       DATETIME      NOT NULL,
    [SaleDeviceId]     INT           NULL,
    [SerialNo]         BIGINT        NULL,
    [HolderId]         BIGINT        NULL,
    [SsoUserId]        INT           NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([AssociationId] ASC),
    CONSTRAINT [FK_Associations_Partners] FOREIGN KEY ([PartnerId]) REFERENCES [dbo].[Partners] ([PartnerId])
);

