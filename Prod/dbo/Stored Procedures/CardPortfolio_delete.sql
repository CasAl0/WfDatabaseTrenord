create procedure [dbo].[CardPortfolio_delete] @SSOUserId int, @Holderid bigint, @Saledeviceid int, @Serialno bigint
as
begin
delete from CardPortfolio where SSOUserId=@SSOUserId and Holderid = @Holderid 
	and Saledeviceid = @Saledeviceid and Serialno = @Serialno;

delete from ContractPortfolio where SSOUserId=@SSOUserId 
	and CardKey = cast(@Saledeviceid as varchar(10)) + '-' + cast(@Serialno as varchar(10));
end
