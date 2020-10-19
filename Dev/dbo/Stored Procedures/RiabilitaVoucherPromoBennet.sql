-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RiabilitaVoucherPromoBennet]
(
	@hour INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	;
    WITH    PB
              AS ( SELECT   *
                   FROM     [dbo].[PromoBennet]
                   WHERE    CanaleVendita = 1
                            AND Stato = 2
                            AND GETDATE() > DATEADD(HOUR, @hour,
                                                    ChangeTracking)
                 )
        UPDATE  PB
        SET     Stato=1, ChangeTracking=NULL, CanaleVendita=NULL, Token=null;



	  --SELECT DATEDIFF(minute, ChangeTracking, GETDATE()) AS test, * FROM [dbo].[PromoBennet]
	  --WHERE CanaleVendita = 1 and Stato = 2 AND GETDATE() > DATEADD(HOUR, 4, ChangeTracking)
	  --ORDER BY ChangeTracking DESC
    
END
