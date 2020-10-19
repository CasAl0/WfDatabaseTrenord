CREATE TABLE [dbo].[ReservationStatusActions] (
    [ReservationStatusActionId] INT           IDENTITY (1, 1) NOT NULL,
    [ReservationStatusId]       INT           NOT NULL,
    [Name]                      NVARCHAR (50) NOT NULL,
    [Tag]                       NVARCHAR (50) NOT NULL,
    [WorkflowId]                CHAR (8)      NOT NULL,
    CONSTRAINT [PK_ReservationStatusActions] PRIMARY KEY CLUSTERED ([ReservationStatusActionId] ASC),
    CONSTRAINT [FK_ReservationStatusActions_ReservationStatus] FOREIGN KEY ([ReservationStatusId]) REFERENCES [dbo].[ReservationStatus] ([ReservationStatusId]),
    CONSTRAINT [FK_ReservationStatusActions_Workflows] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId])
);

