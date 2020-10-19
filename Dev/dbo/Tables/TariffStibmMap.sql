CREATE TABLE [dbo].[TariffStibmMap] (
    [Id]          INT          NOT NULL,
    [TarTicket]   VARCHAR (10) NULL,
    [TarAnnual]   VARCHAR (10) NOT NULL,
    [STarAnnual]  VARCHAR (10) NOT NULL,
    [UTarAnnual]  VARCHAR (10) NOT NULL,
    [TarMonthly]  VARCHAR (10) NOT NULL,
    [STarMonthly] VARCHAR (10) NOT NULL,
    [UTarMonthly] VARCHAR (10) NOT NULL,
    [TarWeekly]   VARCHAR (10) NULL,
    CONSTRAINT [PK_TariffStibmMap] PRIMARY KEY CLUSTERED ([Id] ASC)
);

