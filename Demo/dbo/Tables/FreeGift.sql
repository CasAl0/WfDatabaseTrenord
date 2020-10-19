CREATE TABLE [dbo].[FreeGift] (
    [FreeGiftId]   INT          IDENTITY (1, 1) NOT NULL,
    [Sku]          VARCHAR (8)  NOT NULL,
    [TariffKey]    VARCHAR (10) NOT NULL,
    [DateFrom]     DATE         NOT NULL,
    [DateTo]       DATE         NOT NULL,
    [PeriodType]   VARCHAR (5)  NULL,
    [NumCredits]   INT          NOT NULL,
    [CalendarCode] VARCHAR (10) NULL,
    CONSTRAINT [PK_FreeGift] PRIMARY KEY CLUSTERED ([FreeGiftId] ASC),
    CONSTRAINT [CK_FreeGift_PeriodType] CHECK ([PeriodType]='YEAR' OR [PeriodType]='MONTH' OR [PeriodType]='DAY')
);

