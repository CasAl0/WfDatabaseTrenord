CREATE TABLE [dbo].[Cities] (
    [CityId]       INT            IDENTITY (1, 1) NOT NULL,
    [CityCode]     VARCHAR (4)    NULL,
    [ProvinceCode] VARCHAR (2)    NULL,
    [Description]  NVARCHAR (100) NULL,
    CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED ([CityId] ASC)
);

