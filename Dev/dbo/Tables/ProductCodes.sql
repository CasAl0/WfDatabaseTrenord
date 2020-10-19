CREATE TABLE [dbo].[ProductCodes] (
    [ProductSku]                CHAR (8)      NOT NULL,
    [CompanyId]                 INT           NOT NULL,
    [ProductDescription]        VARCHAR (100) NOT NULL,
    [ProductDescription_en]     VARCHAR (100) NULL,
    [LongProductDescription]    VARCHAR (500) NULL,
    [LongProductDescription_en] VARCHAR (500) NULL,
    [LegacyId]                  INT           NULL,
    [LegacyCode]                VARCHAR (50)  NULL,
    [Giftable]                  BIT           CONSTRAINT [DF_ProductCodes_Gift] DEFAULT ((0)) NOT NULL,
    [SaleableAfterDays]         INT           NOT NULL,
    [CheckAvailableDays]        BIT           NOT NULL,
    [ProductBeginDate]          DATE          NOT NULL,
    [ProductEndDate]            DATE          NOT NULL,
    [IsPdfTicket]               BIT           CONSTRAINT [DF_ProductCodes_IsPdfTicket] DEFAULT ((0)) NOT NULL,
    [IsCredit]                  BIT           CONSTRAINT [DF_ProductCodes_IsCredit] DEFAULT ((0)) NOT NULL,
    [IsTpe]                     BIT           NOT NULL,
    [IsReservable]              BIT           CONSTRAINT [DF_ProductCodes_IsReservable] DEFAULT ((0)) NOT NULL,
    [ProductGroupId]            INT           NOT NULL,
    [ExpirationReservationDays] INT           CONSTRAINT [DF_ProductCodes_ExpirationReservationDays] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ProductCodes] PRIMARY KEY CLUSTERED ([ProductSku] ASC),
    CONSTRAINT [FK_ProductCodes_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]),
    CONSTRAINT [FK_ProductCodes_ProductGroup] FOREIGN KEY ([ProductGroupId]) REFERENCES [dbo].[ProductGroup] ([ProductGroupId])
);














GO
GRANT SELECT
    ON OBJECT::[dbo].[ProductCodes] TO [reporting]
    AS [dbo];

