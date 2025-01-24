ALTER PROCEDURE dynamicSearch(
   @inputs VARCHAR(500)
)
AS
BEGIN
    DECLARE @inputtable TABLE (
        field NVARCHAR(100)
    )

    INSERT INTO @inputtable 
    SELECT * FROM dbo.pisahKata(@inputs)

	declare @judul nvarchar(500) 
	declare @pengarang nvarchar(500)
	declare @atas nvarchar(500)
	declare @bawah nvarchar(500)

	declare cur cursor for select * from @inputtable
	open cur

	fetch next from cur into @judul  
	fetch next from cur  into @pengarang
	fetch next from cur into @atas 
	fetch next from cur into @bawah
	
	close cur
	deallocate cur
	

    DECLARE @flag INT = 0
    DECLARE @query NVARCHAR(500) =
        'SELECT judul, nama, harga FROM buku JOIN pengarang ON buku.fkPengarang = Pengarang.id '

    IF @judul  != ''  OR
      @pengarang  != ''  OR 
       @atas != ''  OR
       @bawah  != '' 
    BEGIN
        SET @query = @query + 'WHERE '
    END

    IF @judul != '' 
    BEGIN
        IF @flag = 1 
        BEGIN
            SET @query = @query + 'AND '
        END
        SET @query = @query + 'buku.judul = ''' + @judul + ''''
        SET @flag = 1
    END

    IF @pengarang  != '' 
    BEGIN
        IF @flag = 1 
        BEGIN
            SET @query = @query + 'AND '
        END
        SET @query = @query + 'pengarang.nama = ''' + @pengarang + ''''
        SET @flag = 1
    END

   IF @bawah  != '' 
BEGIN
    IF @flag = 1 
    BEGIN
        SET @query = @query + 'AND '
    END
    SET @query = @query + 'buku.harga >= ' + CONVERT(NVARCHAR(100), CAST(@bawah AS INT))
    SET @flag = 1
END

IF @atas  != '' 
BEGIN
    IF @flag = 1 
    BEGIN
        SET @query = @query + 'AND '
    END
    SET @query = @query + 'buku.harga <= ' + CONVERT(NVARCHAR(100), CAST(@atas AS INT))
    SET @flag = 1
END
	print @query
    EXEC sp_executesql @query
END

