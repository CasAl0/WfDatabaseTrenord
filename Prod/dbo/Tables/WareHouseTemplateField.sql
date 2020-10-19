CREATE TABLE [dbo].[WareHouseTemplateField] (
    [WareHouseTemplateFieldId] VARCHAR (50)  NOT NULL,
    [ObjectType]               VARCHAR (50)  NOT NULL,
    [PropertyName]             VARCHAR (500) NULL,
    [FixedValue]               VARCHAR (500) NULL,
    [ValueFormat]              VARCHAR (50)  NULL,
    CONSTRAINT [PK_WareHouseTemplateField] PRIMARY KEY CLUSTERED ([WareHouseTemplateFieldId] ASC)
);

