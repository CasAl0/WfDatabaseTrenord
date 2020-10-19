CREATE procedure [dbo].[p_WfStart]
(
	@token varchar(32), 
	@clientKey varchar(20), 
	@productServiceKey char(8),
	@flgProduct bit, 
	@userprofile varchar(4), 
	@ip varchar(150),
	@remoteInfo varchar(300) = ''
)
as
begin
	
	if len(ltrim(rtrim(@token))) > 0
	begin
		if exists(select 1 from WfToken with (nolock) where token = @token)
		begin
			return -3;
		end
	end
	
	begin try
		insert into WfStartTraces (Token, TraceDate, ServerName, RemoteInfo) values (@token, getdate(), @ip, @remoteInfo)
	end try
	begin catch
	end catch

	declare @dt datetime = getdate()
	declare @clientid int
	declare @wfid char(8)
	declare @wfend char(8)
	declare @sku char(8)
	declare @profiles varchar(50)

	select @clientid = ClientId from Client where ClientKey = @clientKey
	-- ERR: se il client non esiste, ritorno -1 (non autorizzato)
	if @clientid is null 
	begin
		insert into WfStartErrors(LogDate, Token, ClientKey, ProductServiceKey, FlgProduct, Userprofile, IP, Reason)
		values (@dt, @token, @clientKey, @productServiceKey, @flgProduct, @userprofile, @ip, 'ClientKey inesistente')
		return -1
	end
	-- /ERR

	if @flgProduct = 1
	begin
		set @sku = @productServiceKey
		select @wfid = WorkflowId, @profiles = UserProfiles, @wfend=EndWorkflowId 
			from Client_Product_Map where ClientId = @clientid and ProductSku = @sku and @dt between BeginDate and EndDate
	end
	else
	begin
		set @sku = null
		select @wfid = WorkflowId from Client_Service_Map 
			where ClientId = @clientid and WorkflowId = @productServiceKey and @dt between BeginDate and EndDate
	end 

	-- ERR: 1)se sul client non trovo il workflow associato al product, ritorno -1 (non autorizzato)
	--		2)se il profilo utente non è adeguato, ritorno -2
	if @wfid is null 
	begin
		insert into WfStartErrors(LogDate, Token, ClientKey, ProductServiceKey, FlgProduct, Userprofile, IP, Reason)
		values (@dt, @token, @clientKey, @productServiceKey, @flgProduct, @userprofile, @ip, 'Prodotto non associato al Client chiamante')
		return -1
	end
	else if @profiles is not null and CHARINDEX(coalesce(@userprofile,'none'), @profiles) = 0
	begin
		insert into WfStartErrors(LogDate, Token, ClientKey, ProductServiceKey, FlgProduct, Userprofile, IP, Reason)
		values (@dt, @token, @clientKey, @productServiceKey, @flgProduct, @userprofile, @ip, 'Profilo utente non adeguato')
		return -2
	end
	-- /ERR

	-- SE WORKFLOW DI CHIUSURA devo ripulire l'eventuale "sporcizia" rimasta e recupero lo sku
	if @clientid = 0 
	begin
		delete from WfSession where Token = @token
		delete from WfToken where Token = @token
		set @sku = (select ProductSku from WfFinalQueue where Token = @token) 
	end
	--/SE WORKFLOW DI CHIUSURA

	insert into WfToken(Token, CreationDate, WorkflowId, ProductSku, ClientId, EndWorkflowId) 
		values (@token, @dt, @wfid, @sku, @clientid, @wfend)
	insert into WfSession(Token, ObjectName, ObjectBase64) values (@token, '_currentWorkflow', @wfid)

	-- SE ESISTONO FINALQUEUEPARAMS e sto chiamando un EndWorkflow (clientid=0) devo inserirli
	if @clientid = 0 
		insert into WfSession(Token, ObjectName, ObjectBase64) 
		select Token, ObjectName, ObjectValue from WfFinalQueueParams where Token = @token
	--/SE ESISTONO FINALQUEUEPARAMS 

	return 0
end