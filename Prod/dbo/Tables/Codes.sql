CREATE TABLE [dbo].[Codes] (
    [CouponCode] VARCHAR (50)  COLLATE Latin1_General_CS_AI NOT NULL,
    [FileName]   VARCHAR (100) NULL,
    CONSTRAINT [PK_Codes] PRIMARY KEY CLUSTERED ([CouponCode] ASC)
);

