CREATE DATABASE PurpleLaneFurnitureStore
USE PurpleLaneFurnitureStore

CREATE TABLE Staff(
	StaffID CHAR(5) PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) NOT NULL CHECK(LEN(StaffName) >= 5),
	StaffGender VARCHAR(10) NOT NULL CHECK(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female'),
	StaffEmail VARCHAR(50) NOT NULL CHECK(StaffEmail LIKE '%@purplelane.com'),
	StaffPhone VARCHAR(14) NOT NULL,
	StaffAddress VARCHAR(100) NOT NULL,
	StaffSalary INT NOT NULL CHECK(StaffSalary BETWEEN '1000000' AND '25000000'),
);

CREATE TABLE Customer(
	CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) NOT NULL CHECK(LEN(CustomerName) >= 5),
	CustomerGender VARCHAR(10) NOT NULL CHECK(CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female'),
	CustomerPhone VARCHAR(14) NOT NULL,
	CustomerAddress VARCHAR(100) NOT NULL,
	CustomerEmail VARCHAR(50) NOT NULL CHECK(CustomerEmail LIKE '%@%')
);

CREATE TABLE Supplier(
	SupplierID CHAR(5) PRIMARY KEY CHECK(SupplierID LIKE 'SU[0-9][0-9][0-9]'),
	SupplierName VARCHAR(50) NOT NULL,
	SupplierAddress VARCHAR(100) NOT NULL
);

CREATE TABLE Category(
	CategoryID CHAR(5) PRIMARY KEY CHECK(CategoryID LIKE 'PC[0-9][0-9][0-9]'),
	CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Furniture(
	FurnitureID CHAR(5) PRIMARY KEY CHECK(FurnitureID LIKE 'PR[0-9][0-9][0-9]'),
	CategoryID CHAR(5) FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FurnitureName VARCHAR(50) NOT NULL,
	FurnitureStock INT NOT NULL,
	FurniturePurchasePrice INT NOT NULL,
	FurnitureSellingPrice INT NOT NULL
);

CREATE TABLE SalesTransaction(
	SalesTransactionID CHAR(5) PRIMARY KEY CHECK(SalesTransactionID LIKE 'SA[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CustomerID CHAR(5) FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	SalesTransactionDate DATE NOT NULL
);

CREATE TABLE DetailSalesTransaction(
	SalesTransactionID CHAR(5) FOREIGN KEY (SalesTransactionID) REFERENCES SalesTransaction(SalesTransactionID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FurnitureSoldID CHAR(5) FOREIGN KEY (FurnitureSoldID) REFERENCES Furniture(FurnitureID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	QuantityPerFurniture INT NOT NULL
	PRIMARY KEY(SalesTransactionID, FurnitureSoldID)
);

CREATE TABLE PurchaseTransaction(
	PurchaseTransactionID CHAR(5) PRIMARY KEY CHECK(PurchaseTransactionID LIKE 'PA[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	SupplierID CHAR(5) FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	PurchaseTransactionDate DATE NOT NULL
);

CREATE TABLE DetailPurchaseTransaction(
	PurchaseTransactionID CHAR(5) FOREIGN KEY (PurchaseTransactionID) REFERENCES PurchaseTransaction(PurchaseTransactionID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	FurniturePurchaseID CHAR(5) FOREIGN KEY (FurniturePurchaseID) REFERENCES Furniture(FurnitureID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	QuantityPerFurniture INT NOT NULL
	PRIMARY KEY(PurchaseTransactionID, FurniturePurchaseID)
);
