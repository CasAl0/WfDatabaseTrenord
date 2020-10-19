CREATE TABLE [dbo].[Card] (
    [CardId]                BIGINT       NOT NULL,
    [CardKey]               VARCHAR (25) NOT NULL,
    [HolderId]              INT          NOT NULL,
    [CrsKey]                CHAR (20)    NOT NULL,
    [ChipType]              CHAR (4)     NOT NULL,
    [ChipId]                VARCHAR (20) NOT NULL,
    [ExpirationDate]        DATE         NOT NULL,
    [IssuingDate]           DATE         NOT NULL,
    [ProfileKey]            VARCHAR (10) NOT NULL,
    [ProfileCategory]       VARCHAR (8)  NOT NULL,
    [ProfileExpirationDate] DATE         NOT NULL,
    [ProfileDescription]    VARCHAR (40) NOT NULL,
    [CardStatus]            VARCHAR (6)  NOT NULL,
    CONSTRAINT [PK__Card__CardId] PRIMARY KEY CLUSTERED ([CardId] ASC)
);



