
CREATE PROCEDURE [dbo].[UpdateMilanoCardTariffs]
AS
BEGIN
		/* MALPENSA EXPRESS + MILANOCARD 24H */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='18107';

		UPDATE dbo.Tariff          SET TariffKey='18149' WHERE TariffKey='18107';
		UPDATE trains.TariffPrices SET Price=19.50       WHERE TariffPricesId=96;
		/* MALPENSA EXPRESS + MILANOCARD 24H */

		/* MALPENSA EXPRESS + MILANOCARD 24H A/R RETURN TICKET */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='18108';

		UPDATE dbo.Tariff          SET TariffKey='18150' WHERE TariffKey='18108';
		UPDATE trains.TariffPrices SET Price=26.00       WHERE TariffPricesId=182;
		/* MALPENSA EXPRESS + MILANOCARD 24H A/R RETURN TICKET */



		/* MALPENSA EXPRESS + MILANOCARD 48H */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='18141';
		
		UPDATE dbo.Tariff          SET TariffKey='18151' WHERE TariffKey='18141';
		UPDATE trains.TariffPrices SET Price=25.50       WHERE TariffPricesId=98;
		/* MALPENSA EXPRESS + MILANOCARD 48H */

		/* MALPENSA EXPRESS + MILANOCARD 48H A/R RETURN TICKET */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='18140';
		
		UPDATE dbo.Tariff          SET TariffKey='18146' WHERE TariffKey='18140';
		UPDATE trains.TariffPrices SET Price=32.00       WHERE TariffPricesId=183;
		/*MALPENSA EXPRESS + MILANOCARD 48H A/R RETURN TICKET */



		/* MALPENSA EXPRESS + MILANOCARD 72H */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='13330';
		
		UPDATE dbo.Tariff          SET TariffKey='18147' WHERE TariffKey='13330';
		UPDATE trains.TariffPrices SET Price=30.50       WHERE TariffPricesId=100;
		/* MALPENSA EXPRESS + MILANOCARD 72H */

		/* MALPENSA EXPRESS + MILANOCARD 72H A/R RETURN TICKET */
		--SELECT t.TariffId, t.TariffKey, t.TariffDescription, td.TariffDetailsId, tp.TariffPricesId, tp.Price 
		--FROM dbo.Tariff AS t
		--	INNER JOIN trains.TariffDetails AS td ON td.TariffId = t.TariffId
		--	INNER JOIN trains.TariffPrices  AS tp ON tp.TariffDetailsId = td.TariffDetailsId
		--WHERE t.TariffKey='16129';
			
		UPDATE dbo.Tariff          SET TariffKey='18148' WHERE TariffKey='16129';
		UPDATE trains.TariffPrices SET Price=37.00       WHERE TariffPricesId=184;
		/* MALPENSA EXPRESS + MILANOCARD 72H A/R RETURN TICKET */

END