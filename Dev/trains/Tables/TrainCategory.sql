CREATE TABLE [trains].[TrainCategory] (
    [TrainCategoryId]   INT          NOT NULL,
    [TrainCategoryCode] VARCHAR (10) NOT NULL,
    [Description]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_TrainCategory] PRIMARY KEY CLUSTERED ([TrainCategoryId] ASC)
);

