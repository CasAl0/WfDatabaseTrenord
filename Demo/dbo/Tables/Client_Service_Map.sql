CREATE TABLE [dbo].[Client_Service_Map] (
    [ClientId]   INT      NOT NULL,
    [WorkflowId] CHAR (8) NOT NULL,
    [BeginDate]  DATE     CONSTRAINT [DF_Client_Service_Map_BeginDate] DEFAULT ('20140101') NOT NULL,
    [EndDate]    DATE     CONSTRAINT [DF_Client_Service_Map_EndDate] DEFAULT ('29990101') NOT NULL,
    CONSTRAINT [PK_Client_Service_Map] PRIMARY KEY CLUSTERED ([ClientId] ASC, [WorkflowId] ASC),
    CONSTRAINT [FK_Client_Service_Map_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_Client_Service_Map_Workflows] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId])
);



