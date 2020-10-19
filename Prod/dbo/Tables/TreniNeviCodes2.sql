CREATE TABLE [dbo].[TreniNeviCodes2] (
    [CouponCode] VARCHAR (50)  COLLATE Latin1_General_CS_AI NOT NULL,
    [FileName]   VARCHAR (100) NULL,
    CONSTRAINT [PK_TreniNeviCodes2] PRIMARY KEY CLUSTERED ([CouponCode] ASC)
);

