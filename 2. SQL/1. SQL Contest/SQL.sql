use sales_Db;

select * from sales;

select SaleID,SaleDate,CustomerName,State from sales where State = 'Tamil Nadu';

select SaleID,SaleDate,Product,Quantity,SalesAmount from sales where SalesAmount > 10000 ;

select DISTINCT(Product),Category from sales where Category = 'Electronics' ;

select SaleID,CustomerName,Product,Quantity from sales where Quantity BETWEEN 5 AND 20 ORDER BY QUANTITY;

select City,SUM(SalesAmount) from sales where City IN ('Chennai', 'Bengaluru','Hyderabad') GROUP BY City ORDER BY City ;

select * from sales where CustomerName like 'A%' ;

select DISTINCT City,State from sales;

select * from sales order by SalesAmount desc;

select SUM(Quantity) as 'Total Quantity',Product,Category from sales group by Product,Category order by 'Total Quantity';

select SUM(SalesAmount) AS 'Total Sales',avg(SALESAMOUNT) 'Average Sales',MAX(SALESAMOUNT) AS 'Maximum Sale', MIN(SALESAMOUNT) AS 'Minimum Sale' from sales;

SELECT COUNT(*)  as 'Total Sales Transactions' from sales;

select sum(salesamount) as 'Sales Amount', Category from sales where category = 'Electronics' group by Category;

select avg(quantity) as 'Average Quantity Sold' from sales;

select sum(salesamount) as 'Total Sales Amount',State from sales where State = 'Tamil Nadu' group by state order by 'Total Sales Amount';

select count(distinct CustomerName) as 'Unique Customer' from sales ;

select sum(salesamount) as 'Total Sales Amount',category from sales group by category order by sum(salesamount) desc;

select sum(salesamount) as 'Total Sales Amount',city from sales group by city order by sum(salesamount) desc;

select sum(salesamount) as 'Total Sales Amount',state from sales group by state order by sum(salesamount) desc;

select sum(quantity) as 'Quantity Ordered',Product from sales group by Product order by sum(quantity) desc;

select round(avg(salesamount),2) as 'Average Sales Amount',category from sales group by category order by avg(salesamount) desc;

select count(*) as 'Total Transaction',city from sales group by city order by count(*) desc;

select sum(salesamount) as 'Total Sales Amount' ,category from sales group by category having sum(salesamount) > 100000;

select avg(salesamount) as 'Average Sales Amount',city from sales  group by city having avg(salesamount) > 15000;

select sum(salesamount) as 'Sales Amount' ,Product from sales GROUP BY PRODUCT order by sum(salesamount) desc LIMIT 1;

select sum(salesamount) as 'Sales Amount' ,state from sales GROUP BY state order by sum(salesamount) desc LIMIT 1;

select sum(salesamount) as 'Total Sales Amount',monthname(saledate)  from sales where monthname(saledate) = 'January' GROUP BY monthname(saledate) order by sum(salesamount) desc;

select sum(salesamount) as 'Total Sales Amount',monthname(saledate)  from sales where monthname(saledate) = 'August' and year(saledate) = 2026 GROUP BY monthname(saledate) order by sum(salesamount) desc;

select * from sales where saledate >= current_date - INTERVAL 30 DAY and saledate < current_date order by saledate desc  ;

select sum(salesamount) as 'Sales Amount', monthname(saledate) from sales group by month(saledate)	,monthname(saledate) order by month(saledate)	;

select count(*) as 'Sales Transaction', monthname(saledate) as 'Month' from sales group by month(saledate)	,monthname(saledate) order by month(saledate)	;

select sum(salesamount),monthname(saledate) from sales group by month(saledate), monthname(saledate) order by sum(salesamount) limit 1;
select sum(salesamount),monthname(saledate) from sales group by month(saledate), monthname(saledate) order by sum(salesamount) desc limit 1;

select sum(salesamount) as 'Sales Amount' ,year(saledate) as 'year' from sales group by year(saledate) order by sum(salesamount) desc ;

select *,dayname(saledate) from sales where weekday(saledate) >= 5;

select count(*) as 'Total Transaction' ,dayname(saledate) as 'Day of Week' from sales  group by DAYOFWEEK(SaleDate),dayname(saledate) order by dayofweek(saledate) ;

select * from sales; 



select saleid,salesamount,
case 
	when salesamount >= 50000 then 'High'
	when salesamount >= 20000 then 'Medium'
	else 'Low'
end as 'Sales_Level'
from sales order by salesamount desc;

select saleid,quantity,
case 
	when quantity >= 20 then 'Bulk'
	when quantity >= 10 then 'Medium'
	else 'Regular'
end as 'Quantity Level'
from sales order by quantity desc;


SELECT     Product, COUNT(*) AS 'Total Transactions', SUM(SalesAmount) AS 'Total Sales Amount',
    CASE
        WHEN SUM(SalesAmount) >= 50000 THEN 'High'
        WHEN SUM(SalesAmount) >= 20000 THEN 'Medium'
        ELSE 'Low'
    END AS `Sales_Level`
FROM sales
GROUP BY product
ORDER BY `Total Sales Amount` DESC;

select * from sales;	

select product,category,discount,
case 
	when Discount >= 20 then 'High Discount'
    when Discount >= 10 then 'Medium Discount'
    else 'Low Discount' 
end as 'Discount Category'
from sales group by product,category,discount,`Discount Category`  order by discount desc;


select 
case 
	when salesamount >= 50000 then 'High'
	when salesamount >= 20000 then 'Medium'
	else 'Low'
end as 'Sales Level',
count(*) as 'Transaction'
from sales group by `Sales Level` order by `Sales Level`  desc;


SELECT CustomerName, SUM(SalesAmount) AS TotalSales
FROM sales
GROUP BY CustomerName
HAVING SUM(SalesAmount) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(SalesAmount) AS CustomerTotal
        FROM sales
        GROUP BY CustomerName
    ) t
);


SELECT Product, SUM(SalesAmount) AS TotalSales
FROM sales
GROUP BY Product
HAVING SUM(SalesAmount) > (
    SELECT AVG(ProductSales)
    FROM (
        SELECT SUM(SalesAmount) AS ProductSales
        FROM sales
        GROUP BY Product
    ) t
)
ORDER BY TotalSales DESC;


SELECT Product, SUM(SalesAmount) AS TotalSales
FROM sales
GROUP BY Product
ORDER BY TotalSales DESC
LIMIT 1;

SELECT DISTINCT SalesAmount,Product
FROM sales
ORDER BY SalesAmount DESC
LIMIT 1 OFFSET 1;

WITH customer_totals AS (
    SELECT CustomerName, SUM(SalesAmount) AS TotalSales
    FROM sales
    GROUP BY CustomerName
)
SELECT CustomerName, TotalSales
FROM customer_totals
WHERE TotalSales > (SELECT AVG(TotalSales) FROM customer_totals)
ORDER BY TotalSales DESC;


SELECT City, SUM(SalesAmount) AS TotalSales
FROM sales
GROUP BY City
HAVING SUM(SalesAmount) = (
    SELECT MAX(CitySales)
    FROM (
        SELECT SUM(SalesAmount) AS CitySales
        FROM sales
        GROUP BY City
    ) t
);


SELECT SaleID, SaleDate, CustomerName, City, SalesAmount
FROM sales
WHERE SalesAmount > (
    SELECT MAX(SalesAmount)
    FROM sales
    WHERE City = 'Bengaluru'
);

SELECT Product, Category, Price
FROM sales
WHERE Price > (SELECT AVG(Price) FROM sales)
ORDER BY Price DESC;


SELECT CustomerName, SUM(SalesAmount) AS TotalPurchaseAmount
FROM sales
GROUP BY CustomerName
ORDER BY TotalPurchaseAmount DESC
LIMIT 1;

SELECT Product, SUM(SalesAmount) AS TotalSales
FROM sales
GROUP BY Product
ORDER BY TotalSales DESC
LIMIT 1 OFFSET 1;