CREATE Procedure [dbo].[Validation_B2B_InitEndWorkflow]
(
	@ClientKey varchar(10),
	@Token     varchar(32)
)
as
begin
	
	DECLARE @clientid INT = 0;

	SELECT @clientid=ClientId FROM Client WHERE ClientKey = @ClientKey;


	IF NOT EXISTS (SELECT token FROM WfFinalQueue WHERE Token=@Token)
		THROW 50000,'Il token non è più valido',1;

	ELSE

	BEGIN 
		IF NOT EXISTS (SELECT token FROM WfFinalQueue WHERE Token=@Token AND ClientId=@clientid)
			--PRINT 'anomalia nel chiamante';
			THROW 50000,'Anomalia nella chiamata: Token<>ClientId',1;
		ELSE
			IF NOT EXISTS (SELECT token FROM WfFinalQueue WHERE Token=@Token AND StateCode = 0)
				--PRINT 'transazione già processata';
				THROW 50000,'Transazione già elaborata',1;
	END

END