CREATE procedure [dbo].[AlignUserInfoWareHouse]
as
begin
	update WfWareHouse set SsoUserId = a.UserId
	from (select UserId, Token as FqToken from WfFinalQueue with (nolock) where UserId is not null) a
	where Token = a.FqToken and SsoUserId is null;
end