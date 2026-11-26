--Databse already created and i working on--

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID int identity PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID int identity  PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID int identity PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


BULK INSERT Books
FROM 'C:\Users\DELL\Downloads\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Books.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


BULK INSERT Customers
FROM 'C:\Users\DELL\Downloads\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Customers.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


BULK INSERT Orders
FROM 'C:\Users\DELL\Downloads\ST - SQL ALL PRACTICE FILES SD61\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Orders.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

--for table view how many tables in your db and names of tables--
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- 1) Retrieve all books in the "Fiction" genre:
SELECT  *
FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT *
FROM Books
WHERE Published_Year>1950;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--remove the space:
UPDATE Customers
SET Country = REPLACE(Country, CHAR(13), '');

-- 3) List all customers from the Denmark:
SELECT * FROM Customers 
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT Sum(Stock) As Total_Stock_of_Books
FROM  Books;

-- 6) Find the details of the most expensive book:
SELECT  top 1 * FROM Books
ORDER BY price desc;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT Customer_id,Quantity
FROM Orders
WHERE Quantity>1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
Where Quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE Total_Amount>20
ORDER BY Total_Amount ASC;


-- 9) List all genres available in the Books table:
SELECT Distinct(genre) FROM Books;

--Display All Tables:
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 10) Find the book with the lowest stock:
SELECT Title,Stock
FROM Books
WHERE Stock>=0 And NOT Stock>=1;

-- 10) Find the book with the lowest stock: Help From Ai
SELECT Title,Stock
FROM Books
WHERE Stock = (
SELECT MIN(Stock) AS Lowest_stock
FROM Books);
 
 -- 11) Calculate the total revenue generated from all orders:
SELECT  SUM(Total_Amount) As Total_Revenu
FROM Orders;

----Advance Queries---

-- 1) Retrieve the total number of books sold for each genre:
SELECT
Genre,
sum(quantity) as Total_Genre_Wise
from Books
inner join Orders 
on Books.Book_ID=Orders.Book_ID
group by Books.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT  genre, AVG(price) AS Average
From Books
WHERE Genre = 'Fantasy' 
Group by Genre;

--Display All Tables:
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 3) List customers who have placed at least 2 orders:
SELECT Customer_id,Quantity
FROM Orders
WHERE Quantity>1
Order by quantity ASC;

-- 3) List customers who have placed at least 2 orders:with help of Ai
SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) >= 2;

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id,
c.name, 
COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
 inner JOIN customers c 
 ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT o.Book_id,
b.title,
COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b
ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT Top 3
    Title,
    Genre,
    Price 
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT 
A.Author,
sum(Q.quantity) As Total_quantity
FROM Books A
Inner Join Orders Q
ON A.Book_ID = Q.Book_ID
Group by A.Author;

-- 7) List the cities where customers who spent over $30 are located:
 SELECT 
  C.City,
  C.Name, 
 O.Total_Amount As Total_Amount
 From Customers C
 inner join Orders O
 ON C.Customer_id = O.Customer_ID
 WHERE O.Total_Amount >200


 -- 8) Find the customer who spent the most on orders:
 SELECT c.customer_id,
 c.name,
 SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c 
ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock;











