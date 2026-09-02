use banking_db;

show tables;

select * from customers;
select * from accounts;
accounts
branches
customers
employees
loans
transactions

select c.customer_id as "Customer ID", CONCAT(C.first_name, ' ', c.last_name) as "Customer Name",a.status as "Account Status"  from customers  as c
join accounts as a
on c.customer_id = a.customer_id
where a.status = "Active";

select * from accounts where balance > 100000 order by balance desc;

select b.branch_id as "Branch ID" ,b.branch_name as "Branch Name",count(*) as "Total Accounts"
from branches as b
join accounts as a
on b.branch_id = a.branch_id group by b.branch_id,b.branch_name;

select b.branch_id as "Branch ID" ,b.branch_name as "Branch Name",SUM(A.BALANCE) as "Total Balance"
from branches as b
join accounts as a
on b.branch_id = a.branch_id group by b.branch_id,b.branch_name;

select * from accounts;

select account_type as "Account Type",round(avg(balance),2)  as "Average Balance"  from accounts group by account_type;

select * from customers;

select a.customer_id as "Customer ID" ,CONCAT(c.first_name, ' ',c.last_name) AS "Customer Name" , count(a.account_id) as " No of Accounts" from accounts as a
join customers as c
on a.customer_id = c.customer_id
group by 1,2 having count(account_id) > 1;

select a.account_id as "Account ID" ,concat(c.first_name, ' ',c.last_name) AS "Customer Name" , c.customer_id as "Customer ID" , sum(a.balance) as "Total Balance" from accounts as a
join customers as c
on a.customer_id = c.customer_id group by 1,2,3 order by `Total Balance`  limit 1;


SELECT * FROM transactions ;

SELECT concat(c.first_name, ' ',c.last_name)as "Customer Name",t.transaction_type as "Transaction Type" ,sum(t.amount) as "Total Amount" FROM transactions as t 
join accounts as a 
on a.account_id=t.account_id 
join customers as c
on a.customer_id = c.customer_id 
where t.transaction_type = "Deposit" group by 1,2 order by 3 desc;


SELECT concat(c.first_name, ' ',c.last_name)as "Customer Name",t.transaction_type as "Transaction Type" ,sum(t.amount) as "Total Amount Withdrawn" FROM transactions as t 
join accounts as a 
on a.account_id=t.account_id 
join customers as c
on a.customer_id = c.customer_id 
where t.transaction_type = "Withdrawal" group by 1,2 order by 3 desc;

select * from accounts;

select a.account_id as "Account ID",
concat(c.first_name,' ',c.last_name) AS "Customer Name", 
 sum(case
		when t.transaction_type = 'Deposit' THEN t.amount
        else 0
        end )as "Deposit Amount" ,
sum(case
		when t.transaction_type = 'Withdrawal' then t.amount
        else 0
        end ) as "Withdrawal Amount",
sum(case 
    when t.transaction_type = 'Deposit' THEN t.amount
	when t.transaction_type = 'Withdrawal' then -t.amount
        else 0
        end) as "Net Transaction Amount"
 from transactions as t
join accounts as a
on t.account_id = a.account_id
join customers as c
on c.customer_id = a.customer_id group by 1,2 order by 5 desc;




select a.account_id as "Account ID",
concat(c.first_name,' ',c.last_name) AS "Customer Name", 
sum(case
		when t.transaction_type = 'Withdrawal' then t.amount
        else 0
        end ) as "Withdrawal Amount",
 sum(case
		when t.transaction_type = 'Deposit' THEN t.amount
        else 0
        end )as "Deposit Amount" 

 from transactions as t
join accounts as a
on t.account_id = a.account_id
join customers as c
on c.customer_id = a.customer_id group by 1,2 having `Withdrawal Amount` >  `Deposit Amount`  order by 4 desc  
;


select a.customer_id as "Customer ID",
concat(c.first_name,' ',c.last_name) AS "Customer Name",
sum(t.amount) as "Total Transaction Value",
count(t.transaction_id) as "No of Transaction"
from transactions AS t
JOIN accounts AS a
    ON t.account_id = a.account_id
JOIN customers AS c
    ON a.customer_id = c.customer_id
GROUP BY
    a.customer_id,
    c.first_name,
    c.last_name
ORDER BY `Total Transaction Value` DESC
LIMIT 10;


select * from transactions;


select YEAR(transaction_date) AS "Transaction Year", MONTH(transaction_date) AS "Month Number",monthname(transaction_date) as "Month" , sum(amount) from transactions
group by YEAR(transaction_date), MONTH(transaction_date), monthname(transaction_date) ORDER BY `Transaction Year`,`Month Number`;

SELECT     a.customer_id AS `Customer ID`,    CONCAT(c.first_name, ' ', c.last_name) AS `Customer Name`,    MAX(t.amount) AS `Highest Transaction Amount` 
FROM transactions AS t
JOIN accounts AS a
    ON t.account_id = a.account_id
JOIN customers AS c
    ON a.customer_id = c.customer_id
GROUP BY a.customer_id, c.first_name, c.last_name
ORDER BY `Highest Transaction Amount` DESC;

SELECT c.customer_id,c.first_name, c.last_name, c.phone, c.email, c.city FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions t
    ON a.account_id = t.account_id
   AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
WHERE t.transaction_id IS NULL;


SELECT t.account_id as "Account ID",t.transaction_id as "Transaction ID" ,t.transaction_date " Transaction Date", t.transaction_type "Transaction Date",t.amount "Transaction Amount",
    SUM(
        CASE 
            WHEN t.transaction_type IN ('CREDIT', 'DEPOSIT') THEN t.amount
            WHEN t.transaction_type IN ('DEBIT', 'WITHDRAWAL') THEN -t.amount
            ELSE 0
        END
    ) OVER (
        PARTITION BY t.account_id
        ORDER BY t.transaction_date, t.transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS "Running Balance"
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
ORDER BY t.account_id,t.transaction_date,t.transaction_id;

SELECT c.customer_id "Customer ID", c.first_name "First Name", c.last_name "Last Name",t.transaction_id "Transaction Date",t.transaction_date "Transaction Date", T.transaction_type AS "Transaction Type", t.amount AS "Current Amount",    
LAG(t.amount) OVER (
        PARTITION BY c.customer_id
        ORDER BY t.transaction_date, t.transaction_id
    ) AS "Previous Amount"
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
JOIN customers c
    ON a.customer_id = c.customer_id
ORDER BY c.customer_id,t.transaction_date,t.transaction_id;


SELECT c.customer_id as "Customer ID", c.first_name as "First Name", c.last_name AS "Last Name", SUM(t.amount) AS "Total Deposits",
    RANK() OVER (
        ORDER BY SUM(t.amount) DESC
    ) AS "Deposite Rank"
FROM transactions t
JOIN accounts a
    ON t.account_id = a.account_id
JOIN customers c
    ON a.customer_id = c.customer_id
WHERE t.transaction_type = 'DEPOSIT' 
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY `Deposite Rank`;



SELECT c.customer_id, c.first_name, c.last_name, c.phone, c.email,
    MAX(a.balance) AS max_account_balance,
    COUNT(t.transaction_id) AS txn_count_6m,
    SUM(t.amount) AS txn_volume_6m
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions t
    ON a.account_id = t.account_id
   AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY  c.customer_id,c.first_name,c.last_name,c.phone,c.email
HAVING 
    MAX(a.balance) >= 500000
    AND COUNT(t.transaction_id) >= 5;  