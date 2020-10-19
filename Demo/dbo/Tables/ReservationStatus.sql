CREATE TABLE [dbo].[ReservationStatus] (
    [ReservationStatusId] INT          NOT NULL,
    [Description]         VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ReservationStatus] PRIMARY KEY CLUSTERED ([ReservationStatusId] ASC)
);

