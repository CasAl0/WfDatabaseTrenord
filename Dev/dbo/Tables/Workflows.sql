CREATE TABLE [dbo].[Workflows] (
    [WorkflowId]          CHAR (8)      NOT NULL,
    [WorkflowDescription] VARCHAR (150) NOT NULL,
    [WorkflowTypeId]      INT           NOT NULL,
    CONSTRAINT [PK_Workflows] PRIMARY KEY CLUSTERED ([WorkflowId] ASC),
    CONSTRAINT [FK_Workflows_WorkflowTypes] FOREIGN KEY ([WorkflowTypeId]) REFERENCES [dbo].[WorkflowTypes] ([WorkflowTypeId])
);

