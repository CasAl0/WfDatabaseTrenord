CREATE FUNCTION StringSplit (@InputString VARCHAR(8000),
                       @Delimiter VARCHAR(50))
RETURNS @Items TABLE (Item VARCHAR(8000))
AS
BEGIN

    DECLARE @X XML;

    SELECT @X
        = CONVERT(
              XML,
              ' <root> <myvalue>' + REPLACE(@InputString, @Delimiter, '</myvalue> <myvalue>') + '</myvalue>   </root> ');

    INSERT INTO @Items
    SELECT DISTINCT T.c.value('(/root/myvalue)[7]', 'VARCHAR(8000)')
      FROM @X.nodes('/root/myvalue') AS T(c);

    RETURN;

END;