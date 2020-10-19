CREATE TABLE [trains].[PassengerClass] (
    [PassengerClassId] INT          NOT NULL,
    [Description]      VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PassengerClass] PRIMARY KEY CLUSTERED ([PassengerClassId] ASC)
);

