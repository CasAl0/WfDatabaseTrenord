CREATE TABLE [dbo].[CP_Profile] (
    [ProfileMapId]       INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]           INT           NOT NULL,
    [ProductSku]         CHAR (8)      NOT NULL,
    [ProfileKey]         VARCHAR (10)  NOT NULL,
    [ProfileDescription] VARCHAR (200) NULL,
    [CRP]                INT           NULL,
    [BeginDate]          DATE          NOT NULL,
    [EndDate]            DATE          NOT NULL,
    [AgeRange]           VARCHAR (10)  NULL,
    CONSTRAINT [PK_CP_Profile] PRIMARY KEY CLUSTERED ([ProfileMapId] ASC),
    CONSTRAINT [FK_CP_Profile_CardProfiles] FOREIGN KEY ([CRP]) REFERENCES [dbo].[CardProfiles] ([CardProfileId]),
    CONSTRAINT [FK_CP_Profile_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku])
);





