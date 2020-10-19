CREATE TABLE [dbo].[ProductGroup] (
    [ProductGroupId]          INT          NOT NULL,
    [ProductGroupDescription] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ReportGroup] PRIMARY KEY CLUSTERED ([ProductGroupId] ASC)
);




GO
GRANT SELECT
    ON OBJECT::[dbo].[ProductGroup] TO [reporting]
    AS [dbo];

