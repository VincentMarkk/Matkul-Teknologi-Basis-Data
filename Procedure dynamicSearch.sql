--Vincent Mark - 6182101013
alter procedure dynamicSearch (
	@judul nvarchar(100),
	@pengarang nvarchar(100),
	@batas_bawah int,
	@batas_atas int
)
as
	declare @query nvarchar(400)
	--set querry awal
	set @query = 'select buku.id, judul, pengarang.nama as Pengarang, harga from BUKU join pengarang on fkPengarang = pengarang.id'
	declare @flag  int = 0 --flag yang menentukan apakah sudah ada 'where'. Jika 0 artinya belum ada 'where', jika 1 artinya sudah ada 'where'

		--cek query judul
		if(@judul is not  null)
		begin
			--cek apakah sudah ada where
			if (@flag = 0) 
			begin
				set @query = concat(@query ,' where ')
			end
			else
			begin -- jika sudah ada, tambahkan 'and'
				set @query = concat(@query ,' and ')
			end

			set @query = concat(@query,'buku.judul = ''', @judul,'''')
			set @flag = 1 --set flag menjadi 1 jika sudah concaat 
		end

		if(@pengarang is not  null)
		begin
		--cek apakah sudah ada where
			if (@flag = 0) 
			begin
				set @query = concat(@query ,' where ')
			end
			else-- jika sudah ada, tambahkan 'and'
			begin
				set @query = concat(@query ,' and ')
			end

			set @query = concat(@query,'pengarang.nama = ''', @pengarang, '''')
			set @flag = 1
		end

		if(@batas_atas is not  null)
		begin
				--cek apakah sudah ada where
			if (@flag = 0) 
			begin
				set @query = concat(@query ,' where ')
			end
			else
			begin-- jika sudah ada, tambahkan 'and'
				set @query = concat(@query ,' and ')
			end

			set @query = concat(@query,'buku.harga <= ',  convert(nvarchar,@batas_atas))
			set @flag = 1
		end

		if(@batas_bawah is not  null)
		begin
				--cek apakah sudah ada where
			if (@flag = 0) 
			begin
				set @query = concat(@query ,' where ')
			end
			else
			begin-- jika sudah ada, tambahkan 'and'
				set @query = concat(@query ,' and ')
			end

			set @query = concat(@query,'buku.harga >= ',  convert(nvarchar,@batas_bawah))
			set @flag = 1
		end



	EXEC sp_executesql @query
go


