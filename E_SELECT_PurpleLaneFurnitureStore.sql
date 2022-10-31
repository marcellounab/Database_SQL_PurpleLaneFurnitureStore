use PurpleLaneFurnitureStore

/* No1 */

SELECT 
	Furniture.FurnitureName AS ProductName,
	CAST(SUM(DetailSalesTransaction.QuantityPerFurniture) AS VARCHAR(64)) + ' product(s)' AS 'Total Product Sold'
FROM Furniture INNER JOIN DetailSalesTransaction ON Furniture.FurnitureID = DetailSalesTransaction.FurnitureSoldID
INNER JOIN Category ON Furniture.CategoryID = Category.CategoryID
WHERE Furniture.FurnitureSellingPrice > '150000' AND Category.CategoryName = 'Chair' OR Category.CategoryName = 'Stool'
GROUP BY Furniture.FurnitureName; 

/* No2 */

SELECT 
	Staff.StaffName,
	SUM(DetailSalesTransaction.QuantityPerFurniture) as 'Total Product Sold Before November'
FROM Staff INNER JOIN SalesTransaction ON Staff.StaffID = SalesTransaction.StaffID 
INNER JOIN DetailSalesTransaction ON SalesTransaction.SalesTransactionID = DetailSalesTransaction.SalesTransactionID
WHERE MONTH(SalesTransaction.SalesTransactionDate) < '11'
GROUP BY Staff.StaffName
HAVING SUM(DetailSalesTransaction.QuantityPerFurniture) > '10';

/* No3 */

SELECT 
	Customer.CustomerName,
	COUNT(SalesTransaction.CustomerID) AS 'Total Sales Transactions',
	SUM(DetailSalesTransaction.QuantityPerFurniture*Furniture.FurnitureSellingPrice) AS 'Total Price of Product Sold'
FROM Customer INNER JOIN SalesTransaction ON Customer.CustomerID = SalesTransaction.CustomerID
INNER JOIN DetailSalesTransaction ON SalesTransaction.SalesTransactionID = DetailSalesTransaction.SalesTransactionID
INNER JOIN Furniture ON Furniture.FurnitureID = DetailSalesTransaction.FurnitureSoldID
WHERE LEN(Customer.CustomerName)-LEN(REPLACE(Customer.CustomerName, ' ', '')) < 3
GROUP BY Customer.CustomerName
HAVING COUNT(SalesTransaction.CustomerID) > 1;

/* No4 */

SELECT 
	Supplier.SupplierName AS SupplierName,
	COUNT(PurchaseTransaction.SupplierID) AS 'Total Purchase Transactions',
	SUM(DetailPurchaseTransaction.QuantityPerFurniture*Furniture.FurniturePurchasePrice) AS 'Total Price of Product Purchased'
FROM Supplier INNER JOIN PurchaseTransaction ON Supplier.SupplierID = PurchaseTransaction.SupplierID
INNER JOIN DetailPurchaseTransaction ON DetailPurchaseTransaction.PurchaseTransactionID = PurchaseTransaction.PurchaseTransactionID
INNER JOIN Furniture ON Furniture.FurnitureID = DetailPurchaseTransaction.FurniturePurchaseID
WHERE LEN(Supplier.SupplierName) > '10'
GROUP BY Supplier.SupplierName
HAVING SUM(DetailPurchaseTransaction.QuantityPerFurniture*Furniture.FurniturePurchasePrice) > '5000000';

/* No5 */

SELECT 
	Category.CategoryName AS ProductCategoryName,
	CAST(b.Total AS VARCHAR(64)) + ' product(s)' AS 'Total Product Sold'
FROM Category INNER JOIN
(SELECT Category.CategoryID, SUM(DetailSalesTransaction.QuantityPerFurniture) AS 'Total' 
FROM Category INNER JOIN Furniture ON Category.CategoryID = Furniture.CategoryID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.FurnitureSoldID = Furniture.FurnitureID 
GROUP BY Category.CategoryID) b ON b.CategoryID = Category.CategoryID
INNER JOIN Furniture ON Furniture.CategoryID = Category.CategoryID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.FurnitureSoldID = Furniture.FurnitureID
WHERE Furniture.FurnitureName NOT LIKE '%g%'
GROUP BY Category.CategoryName, b.Total
HAVING b.Total > MAX(DetailSalesTransaction.QuantityPerFurniture);

/* No6 */

SELECT 
	Customer.CustomerName
FROM Customer INNER JOIN SalesTransaction ON SalesTransaction.CustomerID = Customer.CustomerID
INNER JOIN Staff ON SalesTransaction.StaffID = Staff.StaffID, 
(SELECT AVG(Staff.StaffSalary) AS 'avg' FROM Staff) x
WHERE SalesTransaction.SalesTransactionDate < DATEADD(MONTH, -15, GETDATE()) AND Staff.StaffSalary > x.avg
GROUP BY Customer.CustomerName, Staff.StaffSalary;

/* No7 */

SELECT 
	Staff.StaffName,
	LEFT(Staff.StaffGender,1) AS 'Staff Gender',
	SUM(DetailSalesTransaction.QuantityPerFurniture) AS 'Total Product Purchased'
FROM Staff INNER JOIN SalesTransaction ON Staff.StaffID = SalesTransaction.StaffID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.SalesTransactionID = SalesTransaction.SalesTransactionID, 
(SELECT AVG(QuantityPerFurniture) AS 'avg' FROM DetailSalesTransaction) x
WHERE DATENAME(YEAR, SalesTransactionDate) = '2020'
GROUP BY STAFF.StaffName, Staff.StaffGender, avg
HAVING SUM(DetailSalesTransaction.QuantityPerFurniture) > x.avg;

/* No8 */

SELECT 
	Customer.CustomerName,
	Customer.CustomerEmail,
	STUFF(Customer.CustomerPhone, 1, 1,'+62') AS 'Phone Number',
	CAST(b.Total AS VARCHAR(64)) + ' product(s)' AS 'TotalProductSold'
FROM Customer INNER JOIN
(SELECT Customer.CustomerID, SUM(DetailSalesTransaction.QuantityPerFurniture) AS 'Total' FROM Customer 
INNER JOIN SalesTransaction ON Customer.CustomerID = SalesTransaction.CustomerID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.SalesTransactionID = SalesTransaction.SalesTransactionID
GROUP BY Customer.CustomerID) b ON b.CustomerID = Customer.CustomerID, 
(SELECT AVG(QuantityPerFurniture) AS avg FROM DetailSalesTransaction) x
WHERE Customer.CustomerName LIKE '%j%'
GROUP BY Customer.CustomerName, Customer.CustomerEmail, Customer.CustomerPhone, B.Total, avg
HAVING SUM(b.Total) > x.avg;

/* No9 */
GO
CREATE VIEW Q4LargeSupplierTransactionsData AS
SELECT 
	Supplier.SupplierName,
	Supplier.SupplierAddress,
	SUM(DetailPurchaseTransaction.QuantityPerFurniture*Furniture.FurniturePurchasePrice) AS 'Total Price of Product Purchased',
	MAX(DetailPurchaseTransaction.QuantityPerFurniture) AS 'Maximum Product Purchased'
FROM Supplier INNER JOIN PurchaseTransaction ON Supplier.SupplierID = PurchaseTransaction.SupplierID
INNER JOIN DetailPurchaseTransaction ON DetailPurchaseTransaction.PurchaseTransactionID = PurchaseTransaction.PurchaseTransactionID
INNER JOIN Furniture ON Furniture.FurnitureID = DetailPurchaseTransaction.FurniturePurchaseID
WHERE MONTH(PurchaseTransaction.PurchaseTransactionDate) > 9
GROUP BY Supplier.SupplierName, Supplier.SupplierAddress
HAVING MAX(DetailPurchaseTransaction.QuantityPerFurniture) > 15;

SELECT * FROM Q4LargeSupplierTransactionsData;

/* No10 */
GO
CREATE VIEW CustomerTransactionData AS
SELECT 
	Customer.CustomerName,
	b.Total AS 'Total Product Sold',
	MAX(DetailSalesTransaction.QuantityPerFurniture) AS 'Max Product Sold In a Transaction'
FROM Customer INNER JOIN
(SELECT Customer.CustomerID, SUM(DetailSalesTransaction.QuantityPerFurniture) AS 'Total' FROM Customer INNER JOIN SalesTransaction
ON Customer.CustomerID = SalesTransaction.CustomerID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.SalesTransactionID = SalesTransaction.SalesTransactionID
GROUP BY Customer.CustomerID) b
ON b.CustomerID = Customer.CustomerID
INNER JOIN SalesTransaction ON Customer.CustomerID = SalesTransaction.CustomerID
INNER JOIN DetailSalesTransaction ON DetailSalesTransaction.SalesTransactionID = SalesTransaction.SalesTransactionID
WHERE LEN(Customer.CustomerName)-LEN(REPLACE(Customer.CustomerName, ' ', '')) = 1
GROUP BY Customer.CustomerName, B.Total
HAVING MAX(DetailSalesTransaction.QuantityPerFurniture) > 1;

SELECT * FROM CustomerTransactionData;