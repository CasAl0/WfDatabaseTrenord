CREATE TABLE [score].[Attributions] (
    [AttributionId]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [AssociationId]       BIGINT         NOT NULL,
    [CombinationId]       INT            NOT NULL,
    [AttributionDate]     DATETIME       NOT NULL,
    [Reason]              NVARCHAR (200) NOT NULL,
    [AttributionStatusId] INT            NOT NULL,
    [Token]               VARCHAR (32)   NOT NULL,
    [SentToPartnerDate]   DATETIME       NULL,
    [PeriodNumber]        INT            NOT NULL,
    [PeriodFrom]          DATETIME       NOT NULL,
    [PeriodTo]            DATETIME       NOT NULL,
    [Points]              INT            NOT NULL,
    CONSTRAINT [PK_Assignments] PRIMARY KEY CLUSTERED ([AttributionId] ASC),
    CONSTRAINT [FK_Attributions_Associations] FOREIGN KEY ([AssociationId]) REFERENCES [score].[Associations] ([AssociationId]),
    CONSTRAINT [FK_Attributions_AttributionStatus] FOREIGN KEY ([AttributionStatusId]) REFERENCES [score].[AttributionStatus] ([AttributionStatusId]),
    CONSTRAINT [FK_Attributions_Combinations] FOREIGN KEY ([CombinationId]) REFERENCES [score].[Combinations] ([CombinationId])
);

