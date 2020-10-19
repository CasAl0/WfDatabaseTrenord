CREATE TABLE [dbo].[WareHouseTemplate] (
    [WareHouseTemplateId] VARCHAR (20)  NOT NULL,
    [DescriptionTemplate] VARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_WareHouseTemplate] PRIMARY KEY CLUSTERED ([WareHouseTemplateId] ASC)
);

