CREATE FUNCTION [dbo].[StringSplitWfData] (@InputString VARCHAR(8000),
                                    @Delimiter VARCHAR(1))
RETURNS @Items TABLE (SssoId INT,
                      X INT,
                      Profilo VARCHAR(10),
                      CF VARCHAR(20),
                      Nome VARCHAR(100),
                      Cognome VARCHAR(100),
                      EMail VARCHAR(300))
AS
BEGIN

    DECLARE @X XML;

    SELECT @X
        = CONVERT(
              XML,
              ' <root> <myvalue>' + REPLACE(@InputString, @Delimiter, '</myvalue> <myvalue>') + '</myvalue>   </root> ');



    INSERT INTO @Items
    SELECT DISTINCT T.c.value('(/root/myvalue)[1]', 'INT'),
                    T.c.value('(/root/myvalue)[2]', 'INT'),
                    T.c.value('(/root/myvalue)[3]', 'VARCHAR(10)'),
                    T.c.value('(/root/myvalue)[4]', 'VARCHAR(20)'),
                    T.c.value('(/root/myvalue)[5]', 'VARCHAR(100)'),
                    T.c.value('(/root/myvalue)[6]', 'VARCHAR(100)'),
                    T.c.value('(/root/myvalue)[7]', 'VARCHAR(300)')
      FROM @X.nodes('/root/myvalue') AS T(c);

    RETURN;

END;