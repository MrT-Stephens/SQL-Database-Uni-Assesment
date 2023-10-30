
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

The various queries completed on the database are listed below.

  A. List the customer's ID and full name with their order IDs, dates of orders, and total cost of orders.
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

  B. Does the same as question D part A, but will sort by customer name and date of order.
  ```SQL
CREATE TABLE    Question_D_B_Query AS
SELECT          Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                Ord.TotalCost AS "Total Cost"
FROM            Customer Cust
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
ORDER BY        Cust.FirstName ASC, 
                Ord.DateOfOrder ASC;
  ```

  C. Lists the customer's orders and menu items containing the ingredient 'ING4307'.
  ```SQL
CREATE TABLE    Question_D_C_Query AS
SELECT DISTINCT Cust.CustomerId AS "Customer ID", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "Order No", 
                Menu.MenuItemId AS "Menu Item Id", 
                MI.ItemName AS "Item Name", 
                Ing.IngredientId AS "Ingredient Id"
FROM            CustomerOrder Ord
INNER JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
INNER JOIN      OrderedMenuItem Menu ON Ord.OrderNo = Menu.OrderNo
INNER JOIN      MenuItem MI ON Menu.MenuItemId = MI.MenuItemId
RIGHT JOIN      MenuItemIngredient Ing ON Menu.MenuItemId = Ing.MenuItemId
WHERE           Ing.IngredientId = 'ING4307' --<--Change this to change the ingredient that it will look for.
ORDER BY        Ord.OrderNo ASC;
  ```

  D. Returns the number of customers with orders.
  ```SQL
CREATE TABLE    Question_D_D_Query AS 
SELECT          COUNT(DISTINCT Ord.CustomerId) AS "No Of Customers With Orders" --<--Counts the number of 'CustomerOrder' primary keys.
FROM            CustomerOrder Ord;
  ```

  E. Lists the menu items that customer '39460927' has ordered between dates '01/01/2023' and '30/01/2023'.
  ```SQL
CREATE TABLE    Question_D_E_Query AS
SELECT          Ord.OrderNo AS "Order No", 
                OMI.MenuItemId AS "Menu Item Id", 
                Menu.ItemName AS "Ordered Menu Items"
FROM            CustomerOrder Ord 
LEFT JOIN       OrderedMenuItem OMI ON Ord.OrderNo = OMI.OrderNo
RIGHT JOIN      MenuItem Menu ON OMI.MenuItemId = Menu.MenuItemId
INNER JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
WHERE           Ord.CustomerId = '1'                --<----
AND             Ord.DateOfOrder                     -----^^
BETWEEN         TO_DATE('05/01/2022', 'DD/MM/YYYY') --<--^^
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY') --<--Change this to change the customer it looks for or the date range.
ORDER BY        Ord.OrderNo ASC;
  ```

  F. Returns the number of orders taken for each menu item.
  ```SQL
CREATE TABLE    Question_D_F_Query AS
SELECT          Menu.MenuItemId AS "Menu Item Id", 
                Menu.ItemName AS "Menu Item Name", 
                COUNT(OMI.MenuItemId) AS "Num Of Orders"
FROM            OrderedMenuItem OMI
INNER JOIN      CustomerOrder Ord ON Ord.OrderNo = OMI.OrderNo
RIGHT JOIN      MenuItem Menu ON OMI.MenuItemId = Menu.MenuItemId
WHERE           Ord.DateOfOrder 
BETWEEN         TO_DATE('02/01/2023', 'DD/MM/YYYY') 
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY')
GROUP BY        Menu.MenuItemId, Menu.ItemName 
ORDER BY        COUNT(OMI.MenuItemId) ASC;
  ```

  G. Lists the customer's orders, including if they are collection orders between '02/01/2023' and '30/01/2023'.
  ```SQL
CREATE TABLE    Question_D_G_Query AS 
SELECT          (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                Ord.OrderNo AS "OrderNo", 
                Ord.CollectionOrDelivery AS "Type Of Order", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken between 02/01/2023 and 30/01/2023"
FROM            CustomerOrder Ord
RIGHT JOIN      Customer Cust ON Ord.CustomerId = Cust.CustomerId
WHERE           Ord.DateOfOrder 
BETWEEN         TO_DATE('02/01/2023', 'DD/MM/YYYY') --<----
AND             TO_DATE('30/01/2023', 'DD/MM/YYYY') --<--Change this to change the dates it will get data between.
ORDER BY        Ord.CollectionOrDelivery ASC;
  ```

  H. Lists the total orders for each customer, including the average spend and their total spend for a year.
  ```SQL
CREATE TABLE    Question_D_H_Query AS
SELECT          Cust.CustomerId AS "Customer Id", 
                (Cust.FirstName || ' ' || Cust.LastName) AS "Customer Name", 
                TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS') AS "Date Order Taken", 
                ROUND(AVG(Ord.TotalCost), 2) AS "AverageCost", 
                ROUND(SUM(Ord.TotalCost), 2) AS "Annual Cost"
FROM            Customer Cust 
RIGHT JOIN      CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
WHERE           EXTRACT(YEAR FROM Ord.DateOfOrder) = '2023' --<--Change this to change the year that it will calculate for.
GROUP BY        Cust.CustomerId, (Cust.FirstName || ' ' || Cust.LastName), TO_CHAR(Ord.DateOfOrder, 'DD-MM-YYYY HH24:MI:SS')
ORDER BY        SUM(Ord.TotalCost) DESC;
  ```

  I. Returns the order cost and billing information of a certain order and a particular customer.
  ```SQL
SELECT      Ord.OrderNo AS "Order No", 
            Ord.TotalCost AS "Total Cost Of Order", 
            Bil.NameOnCard AS "Name On Card", 
            Bil.AddressLineOne AS "Address Line One", 
            Bil.City, 
            Bil.Postcode, 
            Bil.CardNumber AS "Card Number", 
            Bil.ExpiryDate AS "Expiry Date", 
            Bil.ThreeDigitSecurityNo AS "Three Digit Security No"
FROM        Customer Cust
INNER JOIN  CustomerOrder Ord ON Cust.CustomerId = Ord.CustomerId
RIGHT JOIN  BillingInfomation Bil ON Cust.CustomerId = Bil.CustomerId
WHERE       Cust.CustomerId = '2' 
AND         Ord.OrderNo = '2';
  ```

  J. Returns the different ingredients, including price, quantity per pack, ID, and suppliers, with the supplier name and ID.
  ```SQL
SELECT      Ing.IngredientId AS "Ingredient Id", 
            Ing.IngredientName AS "Ingredient Name", 
            Ing.PurchaseCostPerPack AS "Purchase Cost Per Pack", 
            Ing.QuantityPerPack AS "Quantity Per Pack", 
            Sup.SupplierId AS "Supplier Id", 
            Sup.SupplierName AS "Supplier Name"
FROM        Ingredient Ing
LEFT JOIN   Supplier Sup ON Ing.SupplierId = Sup.SupplierId
ORDER BY    Ing.PurchaseCostPerPack ASC;
  ```

  K. Returns the amount of orders taken by each staff member.
  ```SQL
SELECT      Staff.StaffMemberId AS "Staff Member Id", 
            (Staff.FirstName || ' ' || Staff.LastName) AS "Staff Name", 
            Staff.StaffRank AS "Staff Rank", 
            COUNT(Ord.StaffMemberId) AS "Ammount Of Orders Taken"
FROM        StaffMember Staff
RIGHT JOIN  CustomerOrder Ord ON Staff.StaffMemberId = Ord.StaffMemberId
GROUP BY    Staff.StaffMemberId, 
            (Staff.FirstName || ' ' || Staff.LastName), 
            Staff.StaffRank;
  ```
