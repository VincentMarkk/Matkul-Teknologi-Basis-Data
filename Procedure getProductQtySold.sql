--Vincent Mark - 6182101013
--1
create procedure getProductQtySold
as
declare @productQtySold table
	(productId int, productName varchar(100), qtySold int)
--get qty sold for every product
insert into @productQtySold
	select 
		product.productId,
		 product.Name,
		 count(salesorderdetail.salesorderid) as qtySold
	from 
		salesorderdetail
	join
		product
	on salesorderdetail.productid = product.productid
	group by
		product.productid, product.name

	select * from @productQtySold
go

--2
create procedure getMinProductQtySold
as
--get qtySold for every product
declare @productQtySold table
	(productId int, productName varchar(100), qtySold int)
insert into @productQtySold
	select 
		product.productId,
		 product.Name,
		 count(salesorderdetail.salesorderid) as qtySold
	from 
		salesorderdetail
	join
		product
	on salesorderdetail.productid = product.productid
	group by
		product.productid, product.name
--select product with leas qtysold
select
	* 
from 
	@productQtySold
where 
	qtySold = (select min(qtySold) from @productQtySold)
go

--3
create procedure getCustomerWithMaxProductQtySold
as
--get qtysold for every product
declare @productQtySold table
	(productId int, productName varchar(100), qtySold int)
insert into @productQtySold
	select 
		product.productId,
		 product.Name,
		 count(salesorderdetail.salesorderid) as qtySold
	from 
		salesorderdetail
	join
		product
	on salesorderdetail.productid = product.productid
	group by
		product.productid, product.name

--get max qtySold
declare @maxProductQtySold table
	(productId int,
	 productname varchar(100),
	 qtySold int)
insert into @maxProductQtySold
	select
		* 
	from 
		@productQtySold
	where 
		qtySold = (select max(qtySold) from @productQtySold)

--get ordersdetailid with max qtysSold
declare @ordersMax table
	(salesorderdetailid int,
	 salesorderid int,
	 productid int)
insert into @ordersMax
	select
		salesorderdetailid, 
		salesorderid,
		salesorderdetail.productId
	from
		salesOrderDetail join @maxProductQtySold as t1
	on
		salesorderdetail.productid = t1.productId

--get ordersdetailheader with max qtysSold
declare @salesOrderheader table
	(salesorderid int,
	 customerId int)
insert into @salesOrderheader
	select
		salesorderHeader.salesorderid,
		salesorderHeader.customerid
	from 
		salesorderHeader join @ordersMax as t1
	on 
		salesorderheader.salesorderid = t1.salesorderid

--display customer title and name	
select
	title, 
	(lastName + ', ' + firstName) as 'Name'
from 
	customer join @salesOrderheader as t1
on 
	customer.customerid = t1.customerId

go


