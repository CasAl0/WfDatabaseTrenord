CREATE TABLE [dbo].[Partners] (
    [PartnerId]                   INT            NOT NULL,
    [Description]                 NVARCHAR (50)  NOT NULL,
    [ClientId]                    INT            NOT NULL,
    [ScoreAttributionServiceCall] NVARCHAR (500) NULL,
    [PartnerCallCode]             NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Partners] PRIMARY KEY CLUSTERED ([PartnerId] ASC)
);

