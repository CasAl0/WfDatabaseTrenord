
CREATE PROCEDURE [trains].[UpdateTiloPrices]
as
BEGIN
			
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=155 AND Price=19.50; 
		UPDATE trains.TariffPrices SET Price=25.00 WHERE TariffPricesId=155;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=151 AND Price=18.50; 
		UPDATE trains.TariffPrices SET Price=21.00 WHERE TariffPricesId=151;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=156 AND Price=10.50; 
		UPDATE trains.TariffPrices SET Price=13.00 WHERE TariffPricesId=156;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=152 AND Price=10.00; 
		UPDATE trains.TariffPrices SET Price=11.00 WHERE TariffPricesId=152;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=153 AND Price=16.00; 
		UPDATE trains.TariffPrices SET Price=21.00 WHERE TariffPricesId=153;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=154 AND Price=8.50;  
		UPDATE trains.TariffPrices SET Price=11.00 WHERE TariffPricesId=154;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=157 AND Price=9.00;  
		UPDATE trains.TariffPrices SET Price=7.30  WHERE TariffPricesId=157;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=149 AND Price=14.50; 
		UPDATE trains.TariffPrices SET Price=13.00 WHERE TariffPricesId=149;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=158 AND Price=11.00; 
		UPDATE trains.TariffPrices SET Price=9.30  WHERE TariffPricesId=158;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=150 AND Price=7.50;  
		UPDATE trains.TariffPrices SET Price=6.50  WHERE TariffPricesId=150;
		
		--SELECT * FROM trains.TariffPrices WHERE TariffPricesId=159 AND Price=5.50;  
		UPDATE trains.TariffPrices SET Price=4.60  WHERE TariffPricesId=159;

--TariffId	TariffKey	Descr				Price (fino al 09.12.2017)	Price (dal 10.12.2017)
--155		11007		MXP-LOCARNO Adu.			19.50	 				25,00 € 
--151		11008		MXP-BELLINZONA Adu.			18.50	 				21,00 € 
--156		11010		MXP-LOCARNO  Rag.			10.50	 				13,00 € 
--152		11011		MXP-BELLINZONA Rag. 		10.00	 				11,00 € 
--153		12366		MXP-CADENAZZO Adu.			16.00	 				21,00 € 
--154		12369		MXP-CADENAZZO Rag.			8.50	 				11,00 € 
--157		13345		MIlano-Mendrisio S.Mart.	9.00	 				7,30 € 
--149		13353		Milano-Lugano Paradi. ad	14.50	 				13,00 € 
--158		13354		Como-Lugano Paradiso ad		11.00	 				9,30 € 
--150		13355		Milano-Lugano Paradi. rg	7.50	 				6,50 € 
--159		13356		Como-Lugano Paradiso rg		5.50	 				4,60 € 


	/* VECCHIA UPDATE DEL 30.03.2017 */

	--if cast(getdate() as date) = '2017-03-30' and exists(select 1 from trains.TariffPrices where TariffPricesId = 151 and price = 18.0)
	--begin
	--	update trains.TariffPrices set price = price + 0.5
	--	where TariffPricesId in (
	--	select tp.TariffPricesId from tariff t
	--	inner join trains.TariffDetails td on td.TariffId = t.TariffId
	--	inner join trains.TariffPrices tp on tp.TariffDetailsId = td.TariffDetailsId
	--	where t.tariffkey in (11001, 11004, 11007, 16157, 11010, 11002, 11005, 11008, 16158, 11011, 12360, 12363, 12366, 16159, 12369))
	--end
END