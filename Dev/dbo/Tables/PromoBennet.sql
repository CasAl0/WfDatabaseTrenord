CREATE TABLE [dbo].[PromoBennet] (
    [Voucher]          VARCHAR (20) NOT NULL,
    [Stato]            INT          NOT NULL,
    [ChangeTracking]   DATETIME     NULL,
    [CanaleVendita]    INT          NULL,
    [Token]            VARCHAR (50) NULL,
    [DateValidityFrom] DATE         NOT NULL,
    [DateValidityTo]   DATE         NOT NULL,
    [CouponTypeId]     INT          CONSTRAINT [DF_PromoBennet_CouponTypeId] DEFAULT ((2)) NOT NULL,
    CONSTRAINT [PK_PromoBennet] PRIMARY KEY CLUSTERED ([Voucher] ASC),
    CONSTRAINT [CK_Stato_PromoBennet] CHECK ([Stato]=(3) OR [Stato]=(2) OR [Stato]=(1)),
    CONSTRAINT [FK_PromoBennet_Client] FOREIGN KEY ([CanaleVendita]) REFERENCES [dbo].[Client] ([ClientId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Valori ammessi: 1=Attivo / 2=Bloccato / 3=Bruciato', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PromoBennet', @level2type = N'COLUMN', @level2name = N'Stato';

