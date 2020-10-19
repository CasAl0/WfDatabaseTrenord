
CREATE VIEW [dbo].[ClientWfTemplate]
--WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS
SELECT      cwt.ClientId,
            cwt.ProductSku,
            cwt.WorkflowId,
            cwt.PdfTemplate,
            cwt.SmsTemplate,
            cwt.ConfirmMailTemplateId,
            cwt.WareHouseTemplateId,
            cwt.IsPdfTicket,
            cwt.AvailableVoucherFolder,
            cwt.ProcessingVoucherFolder,
            cwt.UsedVoucherFolder,
            CAST(cwt.AddVoucherInNewPage AS BIT) AS AddVoucherInNewPage,
            CAST(cwt.CropVoucher AS BIT) AS CropVoucher,
            0 AS TariffDetailsId,
            fq.Token,
            cpt.TariffId,
            cwt.QrCodeQuantity
  FROM      WfFinalQueue AS fq
 INNER JOIN dbo.CP_Tariff AS cpt
    ON cpt.ClientId    = fq.ClientId
   AND cpt.ProductSku  = fq.ProductSku
 INNER JOIN Client_Wf_Template AS cwt
    ON cwt.TariffMapId = cpt.TariffMapId
UNION
SELECT      cwt.ClientId,
            cwt.ProductSku,
            cwt.WorkflowId,
            cwt.PdfTemplate,
            cwt.SmsTemplate,
            cwt.ConfirmMailTemplateId,
            cwt.WareHouseTemplateId,
            cwt.IsPdfTicket,
            cwt.AvailableVoucherFolder,
            cwt.ProcessingVoucherFolder,
            cwt.UsedVoucherFolder,
            CAST(cwt.AddVoucherInNewPage AS BIT) AS AddVoucherInNewPage,
            CAST(cwt.CropVoucher AS BIT) AS CropVoucher,
            0 AS TariffDetailsId,
            wt.Token,
            COALESCE(t.TariffId, 0) AS TariffId,
            cwt.QrCodeQuantity
  FROM      WfToken AS wt
 INNER JOIN Client_Wf_Template AS cwt WITH (NOLOCK)
    ON cwt.ClientId   = wt.ClientId
   AND cwt.WorkflowId = wt.WorkflowId
 INNER JOIN dbo.CP_Tariff AS t
    ON cwt.ClientId   = t.ClientId
   AND cwt.ProductSku = t.ProductSku
UNION
SELECT      cwt.ClientId,
            cwt.ProductSku,
            cwt.WorkflowId,
            cwt.PdfTemplate,
            cwt.SmsTemplate,
            cwt.ConfirmMailTemplateId,
            cwt.WareHouseTemplateId,
            cwt.IsPdfTicket,
            NULL AS AvailableVoucherFolder,
            NULL AS ProcessingVoucherFolder,
            NULL AS UsedVoucherFolder,
            CAST(0 AS BIT) AS AddVoucherInNewPage,
            CAST(0 AS BIT) AS CropVoucher,
            cwt.TariffDetailsId,
            fq.Token,
            0 AS TariffId,
            0 AS QrCodeQuantity
  FROM      WfFinalQueue AS fq
 INNER JOIN trains.Client_Wf_Template AS cwt
    ON cwt.ClientId   = fq.ClientId
   AND cwt.ProductSku = fq.ProductSku
UNION
SELECT      cwt.ClientId,
            cwt.ProductSku,
            cwt.WorkflowId,
            cwt.PdfTemplate,
            cwt.SmsTemplate,
            cwt.ConfirmMailTemplateId,
            cwt.WareHouseTemplateId,
            cwt.IsPdfTicket,
            NULL AS AvailableVoucherFolder,
            NULL AS ProcessingVoucherFolder,
            NULL AS UsedVoucherFolder,
            CAST(0 AS BIT) AS AddVoucherInNewPage,
            CAST(0 AS BIT) AS CropVoucher,
            cwt.TariffDetailsId,
            wt.Token,
            0 AS TariffId,
            0 AS QrCodeQuantity
  FROM      WfToken AS wt
 INNER JOIN trains.Client_Wf_Template AS cwt
    ON cwt.ClientId   = wt.ClientId
   AND cwt.WorkflowId = wt.WorkflowId
UNION
SELECT      cwt.ClientId,
            cwt.ProductSku,
            cwt.WorkflowId,
            cwt.PdfTemplate,
            cwt.SmsTemplate,
            cwt.ConfirmMailTemplateId,
            cwt.WareHouseTemplateId,
            cwt.IsPdfTicket,
            cwt.AvailableVoucherFolder,
            cwt.ProcessingVoucherFolder,
            cwt.UsedVoucherFolder,
            CAST(cwt.AddVoucherInNewPage AS BIT) AS AddVoucherInNewPage,
            CAST(cwt.CropVoucher AS BIT) AS CropVoucher,
            0 AS TariffDetailsId,
            fq.Token,
            0 AS TariffId,
            0 AS QrCodeQuantity
  FROM      WfFinalQueue AS fq
 INNER JOIN Client_Wf_Template AS cwt
    ON cwt.ProductSku = fq.ProductSku
 WHERE      cwt.ProductSku = 'TSCUN001';