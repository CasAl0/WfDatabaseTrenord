
create procedure [dbo].p_MoveUndeliverableMail
as
begin
	
	begin try
		INSERT INTO [dbo].[UndeliverableMail]
				   ([IdMail]
				   ,[IsHtml]
				   ,[FromAddress]
				   ,[FromName]
				   ,[ToAddress]
				   ,[ToName]
				   ,[ReplyToAddress]
				   ,[Subject]
				   ,[Body]
				   ,[CreationDate]
				   ,[Status]
				   ,[ErrorMessage]
				   ,[Attachment]
				   ,[SentDate])
		select [IdMail]
				   ,[IsHtml]
				   ,[FromAddress]
				   ,[FromName]
				   ,[ToAddress]
				   ,[ToName]
				   ,[ReplyToAddress]
				   ,[Subject]
				   ,[Body]
				   ,[CreationDate]
				   ,[Status]
				   ,[ErrorMessage]
				   ,[Attachment]
				   ,[SentDate] from Mail with (nolock)
		where status = 'N'
		and CreationDate < GETDATE() - 2;

		delete from Mail where status = 'N' and CreationDate < GETDATE() - 2;
	end try
	begin catch
	end catch
end
