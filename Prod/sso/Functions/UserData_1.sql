CREATE function [sso].[UserData](@SsoUserId int)
returns table
as
return
SELECT alog.[IDROW] as SsoUserId, alog.[USR] as Email,
alig.[NOME] as FirstName, alig.[COGNOME] as LastName, coalesce(alig.[MOBILE], '') as PhoneNumber,
coalesce(aful.[CF], '') as FiscalCode, upper(coalesce(aful.[CITTADINANZA],'')) as Nationality,
upper(coalesce(aful.[RESIDENZA_INDIRIZZO] + ' ' + aful.[RESIDENZA_CIVICO] + ', ' + aful.[RESIDENZA_CAP] + ' ' + acom1.[DESCRIZIONE] + ' (' + apro1.[SINGLA_AUTOMOBILISTICA] + ') - ' + asta1.[STATO], '')) as HomeAddress,
coalesce(convert(varchar, aful.[NASCITA_DATA], 103), '') as Birthday, upper(coalesce(acom2.[DESCRIZIONE] + ' (' + apro2.[SINGLA_AUTOMOBILISTICA] + ') - ' + asta2.[STATO], '')) as BirthPlace
FROM [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_LOGIN] alog
inner join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_LIGHT] alig on alig.[ID_ANA_LOGIN] = alog.[IDROW]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_FULL] aful on aful.[ID_ANA_LIGHT] = alig.[IDROW]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_COMUNE] acom1 on acom1.[IDROW] = aful.[RESIDENZA_ID_COMUNE]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_COMUNE] acom2 on acom2.[IDROW] = aful.[NASCITA_ID_COMUNE]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_REGIONE_PROVINCIA] apro1 on apro1.[IDROW] = aful.[RESIDENZA_ID_PROVINCIA]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_REGIONE_PROVINCIA] apro2 on apro2.[IDROW] = aful.[NASCITA_ID_PROVINCIA]
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_STATO] asta1 on asta1.[IDROW] = aful.[RESIDENZA_ID_STATO]  
left join [SRVSQL-PROD.DMZ-NC.LOCAL].[TN_CUSTOMER].[dbo].[ANA_STATO] asta2 on asta2.[IDROW] = aful.[NASCITA_ID_STATO]
where  alog.[IDROW] = @SsoUserId;