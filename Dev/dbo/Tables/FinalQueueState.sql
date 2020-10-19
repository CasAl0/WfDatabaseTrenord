CREATE TABLE [dbo].[FinalQueueState] (
    [StateCode]        INT           NOT NULL,
    [StateName]        VARCHAR (50)  NOT NULL,
    [StateDescription] VARCHAR (100) NULL,
    [StateCreator]     VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_FinalQueueState] PRIMARY KEY CLUSTERED ([StateCode] ASC)
);

