-- Create Database
CREATE DATABASE OnlineBookstore
USE OnlineBookStore

-- Create Table and Drop tables if they exist
IF OBJECT_ID('Orders', 'U') IS NOT NULL
    DROP TABLE Orders
IF OBJECT_ID('Customers', 'U') IS NOT NULL
    DROP TABLE Customers
IF OBJECT_ID('Books', 'U') IS NOT NULL
    DROP TABLE Books

-- Create Books table
CREATE TABLE Books1 (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10, 2),
    Stock INT
)

-- Create Customers table
CREATE TABLE Customers1 (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
)

-- Create Orders table
CREATE TABLE Orders1 (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2)
)

-- Import Data into Books Table
BULK INSERT Books1
FROM 'C:\Users\anjal\power bi\online bookstore project\Books1.csv'
WITH (
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2            -- Skip the header row (if your CSV has headers)
)

-- Import Data into Customers Table
BULK INSERT Customers1
FROM 'C:\Users\anjal\power bi\online bookstore project\Customers.csv'
WITH (
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2            -- Skip the header row (if your CSV has headers)
)


-- Import Data into Orders Table
BULK INSERT Orders1
FROM 'C:\Users\anjal\power bi\online bookstore project\Orders1.csv'
WITH (
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2            -- Skip the header row (if your CSV has headers)
)


select * from Orders1
select * from Customers1
select * from Orders1


---Basic Queries

---1) Retrieve all books in the "Fiction" genre.
select * from Books1
where Genre = 'fiction';

---2) Find books published after the year 1950.
select * from Books1
where Published_Year > 1950;

---3) List all customers from the Canada.
select * from Customers1
where Country = 'canada';

---4) Show orders placed in November 2023.
select * from Orders1
where MONTH(Order_Date) = 11 and YEAR(Order_Date) = 2023;

---5) Retrieve the total stock of books available.
select sum(stock) as total_stock
from Books1;

---6) Find the details of the most expensive book.
select top 1 * from Books1
order by Price desc;

---7) Show all customers who ordered more than 1 quantity of a book.
select distinct customer_id
from Orders1
where Quantity >1;

---8) Retrieve all orders where the total amount exceeds $20.
select * from Orders1
where Total_Amount >20;

---9) List all genres available in the Books table.
select distinct genre
from Books1;

---10) Find the book with the lowest stock.
select top 1 * from Books1
order by stock asc;

---11) Calculate the total revenue generated from all orders.
select sum(total_amount) as total_revenue
from Orders1;


---Advance Queries

---1) Retrieve the total number of books sold for each genre.
select b.genre, sum(o.Quantity) as total_sold
from Orders1 o
join Books1 b on o.Book_ID = b.Book_ID
group by b.Genre;

---2) Find the average price of books in the "Fantasy" genre.
select AVG(price) as average_price
from Books1
where Genre = 'fantasy';

---3) List customers who have placed at least 2 orders.
select customer_id
from Orders1
group by Customer_ID
having COUNT(Order_ID) >= 2;

---4) Find the most frequently ordered book.
select top 1 book_id, COUNT(*) as times_ordered
from Orders1
group by Book_ID
order by times_ordered desc;

---5) Show the top 3 most expensive books of 'Fantasy' Genre.
select top 3 * from Books1
where Genre = 'fantasy'
order by Price desc;

---6) Retrieve the total quantity of books sold by each author.
select b.author,SUM(o.quantity) as total_sold
from Orders1 o
join books b on o.Book_ID = b.book_id
group by b.author;

---7) List the cities where customers who spent over $30 are located.
select distinct c.city
from Customers1 c
join Orders1 o on c.Customer_ID =o.Customer_ID
where o.Total_Amount > 30;

---8) Find the customer who spent the most on orders.
select top 1 o.customer_id, sum(o.total_amount) as total_spent
from Orders1 o
group by o.Customer_ID
order by total_spent desc;

---9) Calculate the stock remaining after fulfilling all orders.
select b.book_id, b.title,b.stock - ISNULL(sum(o.quantity),0) as remaining_stock
from Books1 b
left join Orders1 o on b.Book_ID = o.Book_ID
group by b.Book_ID, b.Title,b.Stock;


