CREATE TABLE [dbo].[CardHolder] (
    [SsoId]           INT          NOT NULL,
    [FiscalCode]      VARCHAR (16) NOT NULL,
    [HolderId]        INT          NULL,
    [HolderFirstname] VARCHAR (40) NULL,
    [HolderLastname]  VARCHAR (40) NULL,
    CONSTRAINT [PK__CardHolder_SsoId] PRIMARY KEY CLUSTERED ([SsoId] ASC)
);



