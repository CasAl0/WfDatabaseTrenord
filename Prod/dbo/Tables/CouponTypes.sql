CREATE TABLE [dbo].[CouponTypes] (
    [CouponTypeId]          INT          NOT NULL,
    [CouponTypeDescription] VARCHAR (50) NOT NULL,
    [MailTemplateId]        VARCHAR (20) NULL,
    CONSTRAINT [PK_PaymentDiscountTypes] PRIMARY KEY CLUSTERED ([CouponTypeId] ASC),
    CONSTRAINT [FK_CouponTypes_MailTemplate] FOREIGN KEY ([MailTemplateId]) REFERENCES [dbo].[MailTemplate] ([MailTemplateId])
);



