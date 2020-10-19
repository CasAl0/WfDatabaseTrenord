
CREATE PROCEDURE [dbo].[ExtractCouponInfo]
	@couponCode varchar(50),
	@couponTypeId int
AS
begin
	select c.CouponId as Id, c.CouponCode as Code, cd.Amount, cd.SenderName, cd.SenderEmail, cd.SenderMessage, cd.RecipientName, cd.RecipientEmail,
	c.CouponTypeId, c.ValidityFrom as ValidFrom, c.ValidityTo as ValidTo, cuh.UsedNo
	from Coupons c
	cross apply (select count(*) as UsedNo from CouponsUsageHistory where CouponId = c.CouponId) cuh
	inner join CouponsDetails cd on cd.CouponId = c.CouponId
	where c.CouponTypeId = @couponTypeId
	and c.CouponCode = @couponCode;
end