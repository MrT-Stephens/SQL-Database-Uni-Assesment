
<h1 align="center">
  <br>
  SQL Database
  <br>
</h1>

<h4 align="center">A SQL script which creates various tables, inserts test data, and completes queries!</h4>

<p align="center">
  <a href="#infomation">Infomation</a> •
  <a href="#tables-created">Tables Created</a> •
  <a href="#queries">Queries</a>
</p>

## Infomation

This SQL script was created for a university assessment, which required me to create various tables, insert test data into the tables, and complete multiple queries on the tables.

This SQL script was created using [Oracle Apex](https://apex.oracle.com/en/).

The SQL script will:
  1. Drop all the tables/sequence.
  2. Create all the required tables.
  3. Insert test data into the tables.
  4. Complete various queries on the database.

## Tables Created

For the database, ten tables were created, and they can be viewed in the SQL script code.

The table names are:
  1. Customer
  2. BillingInfomation
  3. CustomerOrder
  4. MenuItem
  5. OrderedMenuItem
  6. Supplier
  7. Ingredient
  8. MenuItemIngredient
  9. Review
  10. MenuItemReview

## Queries

  A. List the customer's id and full name with there order IDs, dates of orders, and total cost of orders.
  ```SQL
CREATE TABLE    Question_D_A_Query AS
SELECT          Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                Ord.TotalCost AS "Total Cost"
FROM            Customer Cust
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId;
  ```
