-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AllineaIntegratiMultipliTemp]
    (
        @TariffIdPadre BIGINT ,
        @TariffIdFiglio BIGINT ,
        @IdVettore VARCHAR(50) ,
        @DescPadre VARCHAR(50) ,
        @Boundle VARCHAR(50) = NULL ,
        @DescFiglio VARCHAR(50) = NULL ,
        @Destinazione VARCHAR(50) = NULL ,
        @Km FLOAT = NULL ,
        @Linea FLOAT = NULL ,
        @Tratta FLOAT = NULL ,
        @QuotaVettore FLOAT = NULL ,
        @TipoQuota VARCHAR(50) = NULL ,
        @Totale FLOAT = NULL ,
        @rowcount INT OUT
    )
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        INSERT INTO dbo.IntegratiMultipliTemp ( TariffIdPadre ,
                                                TariffIdFiglio ,
                                                IdVettore ,
                                                DescPadre ,
                                                Boundle ,
                                                DescFiglio ,
                                                Destinazione ,
                                                Km ,
                                                Linea ,
                                                Tratta ,
                                                QuotaVettore ,
                                                TipoQuota ,
                                                Totale )
        VALUES ( @TariffIdPadre, @TariffIdFiglio, @IdVettore, @DescPadre ,
                 @Boundle ,@DescFiglio, @Destinazione, @Km, @Linea, @Tratta ,
                 @QuotaVettore ,@TipoQuota, @Totale );

        SET @rowcount = @@ROWCOUNT;
        RETURN @rowcount;
    END;