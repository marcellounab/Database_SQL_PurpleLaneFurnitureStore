USE PurpleLaneFurnitureStore

-- A. SIMULATE SALES TRANSACTION
INSERT INTO Staff VALUES 
('ST016', 'Kevan Rusaha', 'Male', 'KevanRusaha@purplelane.com', '082385945993', 'Jl. Danau Singkarak No. 73', 6500000),
('ST017', 'Raisa Hakiran', 'Female', 'RaisaHakiran@purplelane.com', '081100433521', 'Jl. Lintas Madura No. 20', 8000000)

INSERT INTO Customer VALUES 
('CU016', 'Bagayang Nahma', 'Male', '082348932456', 'Jl. Jendral Asmat No. 3', 'baganah@gmail.com'),
('CU017', 'Sekar Westina', 'Female', '081294953000', 'Jl. Bengawan Solo No. 11', 'Sekarweh@gmail.com')

INSERT INTO SalesTransaction VALUES 
('SA016', 'ST016', 'CU016', '2021-06-22'),
('SA017', 'ST017', 'CU017', '2021-07-26')

INSERT INTO DetailSalesTransaction VALUES 
('SA016', 'PR011', 10),
('SA016', 'PR009', 26),
('SA017', 'PR010', 30),
('SA017', 'PR015', 17)

--setelah itu Update Stock di TABEL "Furniture" sesuai dengan transaksi Penjualan.



-- B. SIMULATE PURCHASE TRANSACTION
INSERT INTO Staff VALUES 
('ST016', 'Kevan Rusaha', 'Male', 'KevanRusaha@purplelane.com', '082385945993', 'Jl. Danau Singkarak No. 73', 6500000),
('ST017', 'Raisa Hakiran', 'Female', 'RaisaHakiran@purplelane.com', '081100433521', 'Jl. Lintas Madura No. 20', 8000000)

INSERT INTO Supplier VALUES 
('SU016', 'Joko Mangun', 'Jl. Industri Mekar No. 11'),
('SU017', 'Sumak Gara', 'Jl. Industri Rasih No. 23')

INSERT INTO PurchaseTransaction VALUES 
('PA016', 'ST016', 'SU016', '2021-06-24'),
('PA017', 'ST017', 'SU017', '2021-09-26')

INSERT INTO DetailPurchaseTransaction VALUES 
('PA016', 'PR016', 10),
('PA016', 'PR017', 23),
('PA017', 'PR016', 45),
('PA017', 'PR017', 67)

--Setelah itu INSERT di Tabel "Furniture" dengan Stock sesuai dengan Transaksi Pembelian.

INSERT INTO Furniture VALUES 
('PR016', 'PC001', 'RanyangKan', 55, 600000, 750000),
('PR017', 'PC002', 'Mayokop', 90, 450000, 630000)