﻿

CREATE VIEW [dbo].[FullWfFinalQueue]
AS
SELECT [Token]
      ,[ClientId]
      ,[ProductSku]
      ,[OrderDate]
      ,[Expiration]
      ,[StateCode]
      ,[EndWorkflowId]
      ,[LegacyOrderId]
      ,[StoreOrderId]
      ,[ProductName]
      ,[Description]
      ,[UserFirstname]
      ,[UserLastname]
      ,[UserEmail]
      ,[OrderSmsNumber]
      ,[ErrorLog]
      ,[ReleaseDate]
      ,[ReleasePlace]
FROM WfFinalQueue WITH (nolock)
union
SELECT [Token]
      ,[ClientId]
      ,[ProductSku]
      ,[OrderDate]
      ,[Expiration]
      ,[StateCode]
      ,[EndWorkflowId]
      ,[LegacyOrderId]
      ,[StoreOrderId]
      ,[ProductName]
      ,[Description]
      ,[UserFirstname]
      ,[UserLastname]
      ,[UserEmail]
      ,[OrderSmsNumber]
      ,[ErrorLog]
      ,[ReleaseDate]
      ,[ReleasePlace]
FROM History.WfFinalQueue WITH (nolock)