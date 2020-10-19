CREATE TABLE [dbo].[WorkflowTypes] (
    [WorkflowTypeId]          INT          NOT NULL,
    [WorkflowTypeDescription] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_WorkflowTypes] PRIMARY KEY CLUSTERED ([WorkflowTypeId] ASC)
);

