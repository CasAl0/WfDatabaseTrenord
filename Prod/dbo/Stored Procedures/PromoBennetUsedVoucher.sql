CREATE PROCEDURE [dbo].[PromoBennetUsedVoucher]
	@dateFrom DATE,
	@dateTo DATE
AS

	SELECT Voucher, 'UTILIZZATO' AS Stato, ChangeTracking AS [Data utilizzo], Client.ClientDescription AS [Client], Token AS [Ordine/Turno]
	FROM dbo.PromoBennet
	INNER JOIN Client ON Client.ClientId = PromoBennet.CanaleVendita
	WHERE
		PromoBennet.Stato IN (2, 3)
		AND CouponTypeId = 2
		AND cast(ChangeTracking as date) BETWEEN @dateFrom and @dateTo
	ORDER BY ChangeTracking, Stato
GO
GRANT EXECUTE
	ON OBJECT::[dbo].[PromoBennetUsedVoucher] TO [WonderBox]
	AS [dbo];

