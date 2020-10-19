CREATE TABLE [dbo].[WfToken] (
    [Token]         VARCHAR (32) NOT NULL,
    [CreationDate]  DATETIME     CONSTRAINT [DF_WfToken_CreationDate] DEFAULT (getdate()) NOT NULL,
    [ClientId]      INT          NOT NULL,
    [ProductSku]    CHAR (8)     NULL,
    [WorkflowId]    CHAR (8)     NOT NULL,
    [EndWorkflowId] CHAR (8)     NULL,
    CONSTRAINT [PK_WfToken_1] PRIMARY KEY CLUSTERED ([Token] ASC)
);

