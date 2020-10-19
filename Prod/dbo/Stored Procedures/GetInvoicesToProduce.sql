
CREATE procedure [dbo].[GetInvoicesToProduce]
as
begin
	select w.ClientId, w.OrderId, w.OrderDate, w.Price, w.ProductName, w.Quantity, w.Sku, w.PaymentMethod, w.BillingRequested,
	i.Recipient, i.VatNumber, i.FiscalCode, i.City, i.[Address], i.ZipCode, i.Country, i.EMail, i.InvoiceNumber,
	i.ReceiptNumber, vr.VateRate, vc.VatCodeId, vc.VatCode, vc.VatDescription,
	c.Id as CompanyId, c.Name as CompanyName, c.Website as CompanyWebsite, c.PhoneNumber as CompanyPhoneNumber, c.Email as CompanyEmail,
	c.InvoiceHeaderLogo as CompanyHeaderLogo, c.InvoiceFooterLogo as CompanyFooterLogo,
	c.InvoiceLeftFooter as CompanyLeftFooterText, c.InvoiceRightFooter as CompanyRightFooterText,
	c.ReceiptMailTemplateId as CompanyReceiptMailTemplate, c.InvoiceMailTemplateId as CompanyInvoiceMailTemplate,
    c.ReceiptPath as CompanyReceiptPath, c.InvoicePath	as CompanyInvoicePath,
	c.ReceiptPrefixName	as CompanyReceiptPrefixName, c.InvoicePrefixName as CompanyInvoicePrefixName
	from dbo.WfWareHouse as w
	inner join WfInvoices as i on i.OrderId = w.OrderId and i.ClientId = w.ClientId
	inner join WfVatRates as vr on vr.ProductSku = w.Sku
	inner join WfVatCodes as vc on vc.VatCodeId = vr.VatCodeId
	inner join ProductCodes as p on p.ProductSku = vr.ProductSku
	inner join Companies as c on c.Id = p.CompanyId
	where i.PdfDateInvoice is null and i.InvoiceNumber is null
	and convert(date, w.OrderDate) between vr.ValidFrom and vr.ValidTo
	and w.BillingRequested = 1
	order by w.ClientId asc, w.OrderId asc, c.Id asc;
	
end
