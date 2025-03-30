USE QLBH15
GO
ALTER 
----TUAN 7
-- 1. Danh sách các orders ứng với tổng tiền của từng hóa đơn
SELECT o.OrderID, o.OrderDate, 
       SUM(od.Quantity * od.UnitPrice) AS TotalAccount
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate;

-- 2. Danh sách các orders lập ở thành phố Madrid
SELECT o.OrderID, o.OrderDate,c.City, 
       SUM(od.Quantity * od.UnitPrice) AS TotalAccount
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON c.CustomerID=o.CustomerID
WHERE c.City = 'Madrid'
GROUP BY o.OrderID, o.OrderDate, c.City;

-- 3. Danh sách sản phẩm có tổng số lượng lập hóa đơn lớn nhất
SELECT TOP 1 od.ProductID, p.ProductName, SUM(od.Quantity) AS CountOfOrders
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.ProductName
ORDER BY CountOfOrders DESC;

-- 4. Số hóa đơn của mỗi khách hàng
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS CountOfOrder
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName;

-- 5. Số hóa đơn và tổng tiền của mỗi nhân viên
SELECT e.EmployeeID, e.LastName, e.FirstName, COUNT(o.OrderID) AS CountOfOrders, 
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.LastName, e.FirstName;

-- 6. Bảng lương của mỗi nhân viên theo từng tháng trong năm 1996
SELECT e.EmployeeID, e.LastName + ' ' + e.FirstName AS EmployName, 
       FORMAT(o.OrderDate, 'MM/yyyy') AS Month_Salary, 
       SUM(od.Quantity * od.UnitPrice) * 0.1 AS Salary
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY e.EmployeeID, e.LastName, e.FirstName, FORMAT(o.OrderDate, 'MM/yyyy')
ORDER BY Month_Salary, Salary DESC;

-- 7. Danh sách khách hàng có tổng tiền hóa đơn > 20000 (1997)
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate)
VALUES (7, 7, 3, '1997-07-16')
INSERT INTO Products (ProductID, ProductName, SupplierID, UnitPrice, UnitInStock)
VALUES (7, 'Máy tính MSI', 3, 8000.00, 8)
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (7, 7, 8000.00, 4, 0.00)
---
SELECT c.CustomerID, c.CompanyName, SUM(od.Quantity * od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-12-31' AND '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(od.Quantity * od.UnitPrice) > 20000;

-- 8. Danh sách khách hàng với tổng số hóa đơn & tổng tiền hóa đơn (1997)
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate)
VALUES (8, 3, 5, '1997-07-21')
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (8, 7, 10000.00, 2, 0.00)
---
SELECT c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS CountOfOrders, 
       SUM(od.Quantity * od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-12-31' AND '1998-01-01'
GROUP BY c.CustomerID, c.CompanyName

-- 9. Danh sách Category có tổng số lượng tồn > 300, đơn giá trung bình < 25
CREATE TABLE Categories (
    CategoryID INT,
    CategoryName varchar(100)
    PRIMARY KEY (CategoryID),
	);
ALTER TABLE Products ADD CategoryID INT
ALTER TABLE Products ADD CONSTRAINT FK_PRODUCTS_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
INSERT INTO Categories(CategoryID, CategoryName)
VALUES (1, 'May tinh')
INSERT INTO Categories(CategoryID, CategoryName)
VALUES (2, 'Ban Phim')
INSERT INTO Categories(CategoryID, CategoryName)
VALUES (3, 'Chuot')
INSERT INTO Categories(CategoryID, CategoryName)
VALUES (4, 'Phu Kien')
---
INSERT INTO Products(ProductID, CategoryID)
VALUES (1, 1)
INSERT INTO Products(ProductID, CategoryID)
VALUES (2, 2)
INSERT INTO Products(ProductID, CategoryID)
VALUES (3, 3)
INSERT INTO Products(ProductID, CategoryID)
VALUES (4, 4)
INSERT INTO Products(ProductID, CategoryID)
VALUES (5, 4)
INSERT INTO Products(ProductID, CategoryID)
VALUES (6, 1)
INSERT INTO Products(ProductID, CategoryID)
VALUES (7, 1)
---
INSERT INTO Products (ProductID, ProductName, SupplierID, UnitPrice, UnitInStock,CategoryID)
VALUES (8, 'RTX 5090', 3, 20.00, 400, 4)

---
SELECT c.CategoryID, c.CategoryName, SUM(p.UnitInStock) AS Total_UnitInStock, 
       AVG(p.UnitPrice) AS Average_UnitPrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(p.UnitInStock) > 300 AND AVG(p.UnitPrice) < 25;

-- 10. Danh sách Category có tổng số sản phẩm < 10
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID) AS TotalOfProducts
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING COUNT(p.ProductID) < 10
ORDER BY c.CategoryName, TotalOfProducts DESC;

-- 11. Sản phẩm bán trong quý 1 năm 1998 có tổng số lượng > 200
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate)
VALUES (9, , 3, '1998-03-29')
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (9, 5, 200.00, 230, 10.00)
---
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS SumOfQuantity
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1998 AND MONTH(o.OrderDate) BETWEEN 1 AND 3
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 200;

-- 12. Danh sách Customer ứng với tổng tiền hóa đơn từng tháng
SELECT c.CustomerID, c.CompanyName, o.OrderDate, 
       SUM(od.Quantity * od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, o.OrderDate;

-- 13. Employee bán được nhiều tiền nhất tháng 7/1997
SELECT TOP 1 e.EmployeeID, e.LastName, e.FirstName, SUM(od.Quantity * od.UnitPrice) AS TotalSales,o.OrderDate
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 7
GROUP BY e.EmployeeID, e.LastName, e.FirstName, o.OrderDate
ORDER BY TotalSales DESC;

-- 14. Top 3 khách hàng có nhiều đơn hàng nhất năm 1996
SELECT TOP 3 c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS CountOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY c.CustomerID, c.CompanyName
ORDER BY CountOfOrders DESC;

-- 15. Tổng số hóa đơn và tổng tiền của mỗi nhân viên trong tháng 3/1997 (tổng tiền > 4000)
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate)
VALUES (10, 4, 4, '1997-03-18')
INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (10, 5, 800.00, 1, 0.00)
----
SELECT e.EmployeeID, e.LastName, e.FirstName, COUNT(o.OrderID) AS CountOfOrders, 
       SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 3
GROUP BY e.EmployeeID, e.LastName, e.FirstName
HAVING SUM(od.Quantity * od.UnitPrice) > 4000;