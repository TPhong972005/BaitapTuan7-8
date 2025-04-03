---- Câu 1
SELECT CAST(CustomerID AS NVARCHAR) AS CodeID, 
    CompanyName AS Name, Address, Phone AS HomePhone
FROM Customers
UNION ALL
SELECT CAST(EmployeeID AS NVARCHAR) AS CodeID, 
    CONCAT(LastName, ' ', FirstName) AS Name, NULL AS Address, HomePhone
FROM Employees;

--- Câu 2
SELECT c.CustomerID, c.CompanyName, c.Address, 
    SUM(od.Quantity * od.UnitPrice) AS Total
INTO HDKH_9196
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1996-09-01' AND o.OrderDate < '1996-10-01'
GROUP BY c.CustomerID, c.CompanyName, c.Address;

--- Câu 3
SELECT e.EmployeeID, CONCAT(e.LastName, ' ', e.FirstName) AS Name, 
    e.Address, SUM(od.Quantity * od.UnitPrice) AS Total
INTO LuongNV
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Order_Details od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1996-09-01' AND o.OrderDate < '1997-01-01'
GROUP BY e.EmployeeID, e.LastName, e.FirstName, e.Address;

--- Câu 4
SELECT 
    c.CustomerID, 
    c.CompanyName, 
    SUM(od.Quantity * od.UnitPrice) AS Total
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Order_Details od ON o.OrderID = od.OrderID
WHERE 
    o.ShipCountry IN ('Germany', 'USA') 
    AND o.OrderDate >= '1996-07-01' 
    AND o.OrderDate < '1996-09-01'
GROUP BY 
    c.CustomerID, 
    c.CompanyName;
--- câu 5
CREATE TABLE dbo.HoaDonBanHang
(
    orderid INT NOT NULL,
    orderdate DATE NOT NULL,
    empid INT NOT NULL,
    custid VARCHAR(5) NOT NULL,
    qty INT NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

INSERT INTO dbo.HoaDonBanHang (orderid, orderdate, empid, custid, qty) VALUES
(30001, '2007-08-02', 3, 'A', 10),
(10001, '2007-12-24', 2, 'A', 12),
(10005, '2007-12-24', 1, 'B', 20),
(40001, '2008-01-09', 2, 'A', 40),
(10006, '2008-01-18', 1, 'C', 14),
(20001, '2008-02-12', 2, 'B', 12),
(40005, '2009-02-12', 3, 'A', 10),
(20002, '2009-02-16', 1, 'C', 20),
(30003, '2009-04-18', 2, 'B', 15),
(30004, '2007-04-18', 3, 'C', 22),
(30007, '2009-09-07', 3, 'D', 30);

--- tính tổng Qty cho mỗi nhân viên
SELECT empid, SUM(qty) AS TotalQty
FROM dbo.HoaDonBanHang
GROUP BY empid;
---- tạo bảng Pivot
SELECT empid, A, B, C, D
FROM 
(
    SELECT empid, custid, qty
    FROM dbo.HoaDonBanHang
) 
AS D
PIVOT (
    SUM(qty) FOR custid IN (A, B, C, D)
	) 
AS P;

---- lấy dữ liệu từ bảng dbo.HoaDonBanHang trả về số hóa đơn đã lập của nhân viên employee trong mỗi năm.
SELECT empid, YEAR(orderdate) AS OrderYear, COUNT(orderid) AS OrderCount
FROM dbo.HoaDonBanHang
GROUP BY empid, YEAR(orderdate);

---- tạo bảng hiển thị số đơn đtawj hàng
SELECT empid, [164], [198], [223], [231], [233]
FROM (
    SELECT empid, orderid
    FROM dbo.HoaDonBanHang
    WHERE empid IN (164, 198, 223, 231, 233)
) AS SourceTable
PIVOT (
    COUNT(orderid) FOR empid IN ([164], [198], [223], [231], [233])
) AS PivotTable;