CREATE TABLE [dbo].[FreeGiftCredit] (
    [Token]      VARCHAR (32) NOT NULL,
    [FreeGiftId] INT          NOT NULL,
    [Available]  INT          NULL,
    CONSTRAINT [PK_FreeGiftCredit] PRIMARY KEY CLUSTERED ([Token] ASC, [FreeGiftId] ASC)
);

