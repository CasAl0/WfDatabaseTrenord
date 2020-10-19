CREATE TABLE [dbo].[Holidays] (
    [HolidayId]   INT  IDENTITY (1, 1) NOT NULL,
    [HolidayDate] DATE NOT NULL,
    CONSTRAINT [PK_Holidays] PRIMARY KEY CLUSTERED ([HolidayId] ASC)
);

