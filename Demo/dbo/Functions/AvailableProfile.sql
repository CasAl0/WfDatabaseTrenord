CREATE FUNCTION [dbo].[AvailableProfile] (@token CHAR(32))
RETURNS TABLE
AS
RETURN SELECT      c.ProfileKey,
                   COALESCE(c.ProfileDescription, 'Profilo ' + c.ProfileKey) AS ProfileDescription,
                   c.CRP,
                   c.AgeRange
         FROM      CP_Profile AS c
        INNER JOIN WfToken AS w
           ON w.Token      = @token
          AND w.ProductSku = c.ProductSku
          AND w.ClientId   = c.ClientId
        WHERE      CONVERT(DATE, GETDATE()) BETWEEN c.BeginDate AND c.EndDate;
