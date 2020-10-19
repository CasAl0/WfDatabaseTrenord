CREATE TABLE [dbo].[CardProfiles] (
    [CardProfileId] INT             NOT NULL,
    [Description]   VARCHAR (100)   NOT NULL,
    [Price]         DECIMAL (18, 2) NOT NULL,
    [Valid]         BIT             NOT NULL,
    [ProfileRule]   INT             NOT NULL,
    [NFPVersion]    VARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_CardProfiles] PRIMARY KEY CLUSTERED ([CardProfileId] ASC)
);

