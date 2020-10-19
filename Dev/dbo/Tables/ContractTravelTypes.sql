CREATE TABLE [dbo].[ContractTravelTypes] (
    [ContractTravelTypeId] INT           NOT NULL,
    [Description]          NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ContractTravelTypes] PRIMARY KEY CLUSTERED ([ContractTravelTypeId] ASC)
);

