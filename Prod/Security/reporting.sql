CREATE ROLE [reporting]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [reporting] ADD MEMBER [WfReporting];

