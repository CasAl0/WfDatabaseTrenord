CREATE TABLE [dbo].[Client_Product_Map] (
    [ClientId]      INT          NOT NULL,
    [ProductSku]    CHAR (8)     NOT NULL,
    [WorkflowId]    CHAR (8)     NOT NULL,
    [EndWorkflowId] CHAR (8)     NULL,
    [UserProfiles]  VARCHAR (50) NULL,
    [BeginDate]     DATE         CONSTRAINT [DF_Client_Product_Map_BeginDate] DEFAULT ('20140101') NOT NULL,
    [EndDate]       DATE         CONSTRAINT [DF_Client_Product_Map_EndDate] DEFAULT ('29990101') NOT NULL,
    CONSTRAINT [PK_Client_Product_Map] PRIMARY KEY CLUSTERED ([ClientId] ASC, [ProductSku] ASC),
    CONSTRAINT [FK_Client_Product_Map_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([ClientId]),
    CONSTRAINT [FK_Client_Product_Map_ProductCodes] FOREIGN KEY ([ProductSku]) REFERENCES [dbo].[ProductCodes] ([ProductSku]),
    CONSTRAINT [FK_Client_Product_Map_Workflows] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId]),
    CONSTRAINT [FK_Client_Product_Map_Workflows1] FOREIGN KEY ([EndWorkflowId]) REFERENCES [dbo].[Workflows] ([WorkflowId])
);





