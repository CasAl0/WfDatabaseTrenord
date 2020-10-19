
CREATE PROCEDURE [dbo].[MailInvoiceReceiptInsert] (
@clientid INT,
@orderid VARCHAR(50),
@templateid VARCHAR(50),
@attachment VARCHAR(255) = NULL,
@alternativeToAddress VARCHAR(255) = NULL)
AS
BEGIN
    DECLARE @defaultFromMailAddress VARCHAR(255);
    DECLARE @billingTemplateId VARCHAR(50);
    DECLARE @userProfile VARCHAR(10);
    DECLARE @useremail VARCHAR(255);
    DECLARE @subj VARCHAR(255);
    DECLARE @body VARCHAR(MAX);
    DECLARE @ishtml BIT;
    DECLARE @toaddress VARCHAR(255);

    SELECT @defaultFromMailAddress = DefaultFromMailAddress,
           @billingTemplateId = BillingTemplateId
      FROM dbo.WfConfiguration
     WHERE [Current] = 1;

    SELECT @subj = [Subject],
           @body = Body,
           @ishtml = COALESCE(IsHtml, 1),
           @toaddress = ToAddress
      FROM dbo.MailTemplate
     WHERE MailTemplateId = @templateid;

    IF (UPPER(LTRIM(RTRIM(@templateid))) = UPPER(LTRIM(RTRIM(@billingTemplateId))))
    BEGIN
        SET @subj = REPLACE(@subj, '{#orderid}', COALESCE(@orderid, 'n.d.'));
        SET @body = REPLACE(@body, '{#orderid}', COALESCE(@orderid, 'n.d.'));
    END;
    ELSE
    BEGIN
        SET @subj = REPLACE(@subj, '{#orderid}', COALESCE(@orderid, 'n.d.'));
        SET @body = REPLACE(@body, '{#orderid}', COALESCE(@orderid, 'n.d.'));
    END;

    SELECT      @userProfile = fq.UserProfile,
                @useremail = CASE
                                  WHEN w.EMail LIKE 'guest[_]%@trenord.it' THEN LOWER(fq.UserEmail)
                                  ELSE LOWER(w.EMail) END
      FROM      dbo.WfInvoices AS w
     INNER JOIN dbo.WfFinalQueue AS fq
        ON fq.StoreOrderId = w.OrderId
       AND fq.ClientId     = w.ClientId
     WHERE      w.OrderId = @orderid
       AND      w.ClientId     = @clientid;

    IF @alternativeToAddress IS NULL
    BEGIN
        SET @toaddress = REPLACE(@toaddress, '#useremail', @useremail);
    END;
    ELSE
    BEGIN
        SET @toaddress = @alternativeToAddress;
    END;

    INSERT INTO dbo.Mail (IsHtml,
                          FromAddress,
                          ToAddress,
                          [Subject],
                          Body,
                          CreationDate,
                          [Status],
                          Attachment,
                          UserProfile)
    VALUES (@ishtml, @defaultFromMailAddress, @toaddress, @subj, @body, GETDATE(), '0', @attachment, @userProfile);
END;