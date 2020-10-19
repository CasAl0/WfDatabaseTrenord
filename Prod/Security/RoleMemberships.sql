ALTER ROLE [db_owner] ADD MEMBER [DMZ-NC\WfEngine];


GO
ALTER ROLE [db_owner] ADD MEMBER [WfBatchUsr];


GO
ALTER ROLE [db_owner] ADD MEMBER [WfDataUsr];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [DMZ-NC\malse0-cons];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [DMZ-NC\pedma0];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [WonderBox];


GO
ALTER ROLE [db_datareader] ADD MEMBER [DMZ-NC\malse0-cons];


GO
ALTER ROLE [db_datareader] ADD MEMBER [DMZ-NC\900279];


GO
ALTER ROLE [db_datareader] ADD MEMBER [DMZ-NC\pedma0];


GO
ALTER ROLE [db_datareader] ADD MEMBER [WonderBox];

