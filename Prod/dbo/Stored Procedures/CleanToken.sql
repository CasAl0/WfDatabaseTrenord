
CREATE PROCEDURE dbo.CleanToken
	@token varchar(32)
AS
BEGIN

    delete from WfSession where Token = @token;
	delete from WfToken where Token = @token;
END
