



/* README ME
A couple of restrictions & factoids abount SCHEMABINDING clause:

You have to use the two part name (include the schema name) for any tables or views you reference within it.
You can not use SELECT * in a schemabound view.
You can make any change to the table that do not affect the structure of the bound columns.
If you reference a view or function in a schemabound view or function then that view or function must also be schemabound.
Objects that are bound (tables/views) can not be dropped while a schemabound object references them

You can not change the collation of a database with schemabound objects.
You can not run sp_refreshview on a schemabound view. You do get a rather unhelpful error though.
You can find out if an object is schemabound by looking at the column is_schema_bound in sys.sql_modules or the system function OBJECTPROPERTY(object_id, ‘is_schema_bound’).

*/



CREATE VIEW [dbo].[FullWfWarehouse]
WITH SCHEMABINDING
AS
    SELECT WareHouseId ,
           ClientId ,
           OrderId ,
           SsoUserId ,
           OrderDate ,
           ItemId ,
           ProductId ,
           Sku ,
           Quantity ,
           Price ,
           ProductName ,
           [Description] ,
           Token ,
           SerialNo ,
           CreatedOn ,
           BillingRequested ,
           PaymentMethod , 
		   PaymentTransactionId
    FROM   dbo.WfWareHouse WITH ( NOLOCK )

    UNION
    
	SELECT WareHouseId ,
           ClientId ,
           OrderId ,
           SsoUserId ,
           OrderDate ,
           ItemId ,
           ProductId ,
           Sku ,
           Quantity ,
           Price ,
           ProductName ,
           [Description] ,
           Token ,
           SerialNo ,
           CreatedOn ,
           BillingRequested ,
           PaymentMethod ,
		   PaymentTransactionId
    FROM   history.WfWareHouse WITH ( NOLOCK );



