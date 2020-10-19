CREATE TABLE [dbo].[ContractPortfolio] (
    [SSOUserId]      INT           NOT NULL,
    [CardKey]        VARCHAR (50)  NOT NULL,
    [ContractKey]    VARCHAR (50)  NOT NULL,
    [CardHolderName] VARCHAR (100) NULL,
    [LoadStationKey] VARCHAR (10)  NULL,
    CONSTRAINT [PK_ContractPortfolio] PRIMARY KEY CLUSTERED ([SSOUserId] ASC)
);

