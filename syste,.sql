/*
========================================================
 Assignment: Database Design and Normalization
 Question 1: Build a Complete Database Management System
 Use Case: E-commerce Store
========================================================
*/

-- Step 1: Create database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Step 2: Create tables
-- Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(30),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    Category VARCHAR(50)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails table (Many-to-Many between Orders and Products)
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
    -- NOTE: CHECK (Quantity > 0) works only in MySQL 8.0.16+ 
);

-- Payments table (One-to-One with Orders)
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT UNIQUE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert sample data
INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES 
('John', 'Doe', 'john@example.com', '1234567890'),
('Jane', 'Smith', 'jane@example.com', '0987654321');

INSERT INTO Products (ProductName, Price, Stock, Category)
VALUES
('Laptop', 1200.00, 10, 'Electronics'),
('Mouse', 20.00, 100, 'Accessories'),
('Keyboard', 50.00, 50, 'Accessories');

INSERT INTO Orders (CustomerID, Status)
VALUES
(1, 'Pending'),
(2, 'Completed');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES
(1, 1, 1), -- Order 1: Laptop
(1, 2, 2), -- Order 1: 2 Mice
(2, 3, 1); -- Order 2: Keyboard

INSERT INTO Payments (OrderID, Amount, PaymentMethod)
VALUES
(2, 50.00, 'Credit Card');

-- Step 4: Test queries
-- Get all orders with customer names
SELECT o.OrderID, c.FirstName, c.LastName, o.Status, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Get all order details with product names
SELECT od.OrderID, p.ProductName, od.Quantity, p.Price
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID;
