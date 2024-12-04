use mbd_final;

create user 'admin_mantan'@'localhost' identified by 'admin123';
grant execute on `mbd_final`.* to 'admin_mantan'@'localhost';
flush privileges;

CREATE TABLE customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE service (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    ServiceName VARCHAR(100),
    Price DECIMAL(10, 2)
);


CREATE TABLE pemesanan (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ServiceID INT,
    Status VARCHAR(50),
    Date DATE,
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID),
    FOREIGN KEY (ServiceID) REFERENCES service(ServiceID)
);

CREATE TABLE shoes (
    ShoesID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Type VARCHAR(100),
    Brand VARCHAR(100),
    Color VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES pemesanan(OrderID) ON DELETE CASCADE
);

CREATE TABLE payment (
 PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    FOREIGN KEY (OrderID) REFERENCES pemesanan(OrderID)
);

CREATE TABLE employee (
    EmployeeID INT PRIMARY key AUTO_INCREMENT,
    Name VARCHAR(100),
    LoginID VARCHAR(50),
    Password VARCHAR(100),
    Role VARCHAR(50)
);

CREATE TABLE order_assignment (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    EmployeeID INT,
    FOREIGN KEY (OrderID) REFERENCES pemesanan(OrderID),
    FOREIGN KEY (EmployeeID) REFERENCES employee(EmployeeID)
);

CREATE TABLE review (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderID INT,
    Rating INT,
    Comment TEXT,
    FOREIGN KEY (CustomerID) REFERENCES customer(CustomerID),
    FOREIGN KEY (OrderID) REFERENCES pemesanan(OrderID)
);

//--------------------------------------------------------------------------//

DELIMITER //
create or replace PROCEDURE tambah_customer (
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(20)
)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    begin	
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan data customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Debugging: Cek nilai input sebelum memasukkan data
    SELECT p_name AS Name, p_email AS Email, p_phone AS Phone;

    -- Masukkan data customer
    INSERT INTO customer (Name, Email, Phone)
    VALUES (p_name, p_email, p_phone);
    
    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data customer berhasil ditambahkan.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_order_by_customer_name(IN p_customer_name VARCHAR(100))
BEGIN
    -- Deklarasi variabel untuk CustomerID
    DECLARE v_customer_id INT;

    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pemesanan berdasarkan nama customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil CustomerID berdasarkan nama customer
    SELECT CustomerID INTO v_customer_id
    FROM customer
    WHERE Name = p_customer_name;

    -- Jika customer tidak ditemukan, beri error
    IF v_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer tidak ditemukan dengan nama tersebut.';
    END IF;

    -- Mengambil pemesanan dan informasi sepatu terkait
    SELECT 
        p.OrderID,
        p.Status,
        CASE
            WHEN EXISTS (SELECT 1 FROM payment pay WHERE pay.OrderID = p.OrderID) THEN 'Lunas'
            ELSE 'Belum Lunas'
        END AS PaymentStatus,
        GROUP_CONCAT(CONCAT(s.Type, ' ', s.Brand, ' ', s.Color) ORDER BY s.ShoesID) AS ShoesNames
    FROM pemesanan p
    LEFT JOIN shoes s ON p.OrderID = s.OrderID
    WHERE p.CustomerID = v_customer_id
    GROUP BY p.OrderID, p.Status;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE update_customer (
    IN p_customer_id INT,
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(20)
)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui data customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Update data customer berdasarkan CustomerID
    UPDATE customer
    SET Name = p_name, Email = p_email, Phone = p_phone
    WHERE CustomerID = p_customer_id;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data customer berhasil diperbarui.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_customer (
    IN p_customer_id INT
)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus data customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Hapus data customer berdasarkan CustomerID
    DELETE FROM customer WHERE CustomerID = p_customer_id;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data customer berhasil dihapus.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_customers()
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pelanggan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil semua data pelanggan
    SELECT CustomerID, Name, Email, Phone FROM customer;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_customer_by_id(IN p_customer_id INT)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pelanggan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil data customer berdasarkan CustomerID
    SELECT CustomerID, Name, Email, Phone
    FROM customer
    WHERE CustomerID = p_customer_id;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_orders_by_employee_id(IN _employee_id INT)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Mengambil daftar orderan yang diambil oleh employee berdasarkan Assignment
    SELECT 
        o.OrderID,
        o.Status AS OrderStatus,
        o.Date AS OrderDate,
        c.Name AS CustomerName,
        s.ServiceName,
        COALESCE(COUNT(sh.ShoesID), 0) AS ShoesCount
    FROM order_assignment oa
    JOIN pemesanan o ON oa.OrderID = o.OrderID
    JOIN customer c ON o.CustomerID = c.CustomerID
    JOIN service s ON o.ServiceID = s.ServiceID
    LEFT JOIN shoes sh ON o.OrderID = sh.OrderID
    WHERE oa.EmployeeID = _employee_id
    GROUP BY o.OrderID, o.Status, o.Date, c.Name, s.ServiceName;

    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_orders_by_employee_name(IN _employee_name VARCHAR(100))
BEGIN
    -- Variabel lokal
    DECLARE v_employee_id INT;

    -- Penanganan error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Ambil EmployeeID berdasarkan nama
    SELECT EmployeeID INTO v_employee_id
    FROM employee
    WHERE Name = _employee_name
    LIMIT 1;

    -- Jika karyawan tidak ditemukan
    IF v_employee_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Employee tidak ditemukan';
    END IF;

    -- Ambil daftar order
    SELECT 
        o.OrderID,
        o.Status AS OrderStatus,
        o.Date AS OrderDate,
        c.Name AS CustomerName,
        s.ServiceName,
        COUNT(sh.ShoesID) AS ShoesCount
    FROM order_assignment oa
    JOIN pemesanan o ON oa.OrderID = o.OrderID
    JOIN customer c ON o.CustomerID = c.CustomerID
    JOIN service s ON o.ServiceID = s.ServiceID
    LEFT JOIN shoes sh ON o.OrderID = sh.OrderID
    WHERE oa.EmployeeID = v_employee_id
    GROUP BY o.OrderID, o.Status, o.Date, c.Name, s.ServiceName;

    -- Commit transaksi
    COMMIT;
END //
DELIMITER ;




contoh 
INSERT INTO customer (Name, Email, Phone)
VALUES ('asddAteng', 'asdateng@example.com', '08224455667');

//-----------------------------------------------------------------------------///

DELIMITER //
CREATE PROCEDURE get_all_services()
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data layanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil semua data layanan
    SELECT ServiceID, ServiceName, Price FROM service;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_service_by_id(IN p_service_id INT)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data layanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil data layanan berdasarkan ServiceID
    SELECT ServiceID, ServiceName, Price FROM service WHERE ServiceID = p_service_id;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insert_service(IN p_service_name VARCHAR(100), IN p_price DECIMAL(10, 2))
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan data layanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Menambahkan data layanan
    INSERT INTO service (ServiceName, Price) VALUES (p_service_name, p_price);

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data layanan berhasil ditambahkan.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_service(IN p_service_id INT, IN p_service_name VARCHAR(100), IN p_price DECIMAL(10, 2))
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui data layanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Memperbarui data layanan berdasarkan ServiceID
    UPDATE service SET ServiceName = p_service_name, Price = p_price WHERE ServiceID = p_service_id;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data layanan berhasil diperbarui.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_service(IN p_service_id INT)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus data layanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Menghapus data layanan berdasarkan ServiceID
    DELETE FROM service WHERE ServiceID = p_service_id;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data layanan berhasil dihapus.' AS Message;
END //
DELIMITER ;


-- Tambahkan data service
INSERT INTO service (ServiceName, Price) VALUES
('Cuci Sepatu', 50000.00),
('Perawatan Khusus', 75000.00);

//------------------------------------------------------------------------------//

DELIMITER //
CREATE PROCEDURE get_all_pemesanan()
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pemesanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil semua data pemesanan dan status pembayaran
    SELECT 
        p.OrderID, 
        p.CustomerID, 
        p.ServiceID, 
        p.Status, 
        p.Date, 
        CASE
            WHEN EXISTS (
                SELECT 1 FROM payment pay WHERE pay.OrderID = p.OrderID
            ) THEN 'Lunas'
            ELSE 'Belum Lunas'
        END AS PaymentStatus
    FROM pemesanan p;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_pemesanan_by_id(IN p_order_id INT)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pemesanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil data pemesanan dan status pembayaran berdasarkan OrderID
    SELECT 
        p.OrderID, 
        p.CustomerID, 
        p.ServiceID, 
        p.Status, 
        p.Date, 
        CASE
            WHEN EXISTS (
                SELECT 1 FROM payment pay WHERE pay.OrderID = p.OrderID
            ) THEN 'Lunas'
            ELSE 'Belum Lunas'
        END AS PaymentStatus
    FROM pemesanan p
    WHERE p.OrderID = p_order_id;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE check_order_assignment_by_customer(
    IN customerName VARCHAR(100)
)
BEGIN
    -- Deklarasi handler untuk menangani kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terjadi kesalahan saat memeriksa penugasan order.';
    END;

    -- Memulai transaksi
    START TRANSACTION;

    -- Query untuk mengecek apakah order dari customer telah ditugaskan
    SELECT 
        c.Name AS CustomerName,
        p.OrderID,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM order_assignment oa 
                WHERE oa.OrderID = p.OrderID
            ) THEN 'Sudah Ditugaskan'
            ELSE 'Belum Ditugaskan'
        END AS AssignmentStatus
    FROM 
        customer c
    JOIN 
        pemesanan p ON c.CustomerID = p.CustomerID
    WHERE 
        c.Name = customerName;

    -- Menyelesaikan transaksi
    COMMIT;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_pemesanan_by_name(IN p_customer_name VARCHAR(100))
BEGIN
    -- Deklarasi variabel terlebih dahulu
    DECLARE v_customer_id INT;

    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data pemesanan berdasarkan nama customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil CustomerID berdasarkan nama customer
    SELECT CustomerID INTO v_customer_id
    FROM customer
    WHERE Name = p_customer_name;

    -- Jika customer tidak ditemukan, beri error
    IF v_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer tidak ditemukan dengan nama tersebut.';
    END IF;

    -- Mengambil data pemesanan dan status pembayaran berdasarkan CustomerID yang ditemukan
    SELECT 
        p.OrderID, 
        p.CustomerID, 
        p.ServiceID, 
        p.Status, 
        p.Date, 
        CASE
            WHEN EXISTS (
                SELECT 1 FROM payment pay WHERE pay.OrderID = p.OrderID
            ) THEN 'Lunas'
            ELSE 'Belum Lunas'
        END AS PaymentStatus
    FROM pemesanan p
    WHERE p.CustomerID = v_customer_id;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE insert_pemesanan(IN p_customer_id INT, IN p_service_id INT, IN p_status VARCHAR(50), IN p_date DATE)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan data pemesanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Menambahkan data pemesanan
    INSERT INTO pemesanan (CustomerID, ServiceID, Status, Date) VALUES (p_customer_id, p_service_id, p_status, p_date);

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data pemesanan berhasil ditambahkan.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_pemesanan(IN p_order_id INT, IN p_status VARCHAR(50), IN p_date DATE)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui data pemesanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Memperbarui data pemesanan berdasarkan OrderID
    IF p_status IS NOT NULL THEN
        UPDATE pemesanan SET Status = p_status WHERE OrderID = p_order_id;
    END IF;

    IF p_date IS NOT NULL THEN
        UPDATE pemesanan SET Date = p_date WHERE OrderID = p_order_id;
    END IF;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data pemesanan berhasil diperbarui.' AS Message;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE delete_pemesanan(IN p_order_id INT)
BEGIN
    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus data pemesanan.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Menghapus data pemesanan berdasarkan OrderID
    DELETE FROM pemesanan WHERE OrderID = p_order_id;

    -- Selesaikan transaksi
    COMMIT;

    -- Mengirimkan pesan sukses
    SELECT 'Data pemesanan berhasil dihapus.' AS Message;
END //
DELIMITER ;


-- Tambahkan data pemesanan
INSERT INTO pemesanan (CustomerID, ServiceID, Status, Date) VALUES
(3, 1, 'Selesai', '2024-10-01'),
(4, 2, 'Dalam Proses', '2024-10-02');

//-----------------------------------------------------------------------------///

DELIMITER //
CREATE PROCEDURE get_all_shoes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data sepatu.';
    END;
    START TRANSACTION;
    SELECT ShoesID, OrderID, Type, Brand, Color FROM shoes;
    COMMIT;
END //
DELIMITER //

DELIMITER //
CREATE PROCEDURE get_shoes_by_id(IN p_shoes_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data sepatu.';
    END;
    START TRANSACTION;
    SELECT ShoesID, OrderID, Type, Brand, Color FROM shoes WHERE ShoesID = p_shoes_id;
    COMMIT;
END //
DELIMITER //


DELIMITER //
CREATE PROCEDURE get_sepatu_by_customer_name(IN p_customer_name VARCHAR(100))
BEGIN
    -- Deklarasi variabel untuk CustomerID
    DECLARE v_customer_id INT;

    -- Deklarasi handler untuk penanganan kesalahan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback jika terjadi kesalahan
        ROLLBACK;
        -- Mengirimkan pesan kesalahan
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data sepatu berdasarkan nama customer.';
    END;

    -- Mulai transaksi
    START TRANSACTION;

    -- Mengambil CustomerID berdasarkan nama customer
    SELECT CustomerID INTO v_customer_id
    FROM customer
    WHERE Name = p_customer_name;

    -- Jika customer tidak ditemukan, beri error
    IF v_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer tidak ditemukan dengan nama tersebut.';
    END IF;

    -- Menampilkan sepatu yang terkait dengan OrderID customer yang ditemukan
    SELECT 
        s.ShoesID,
        s.OrderID,
        s.Type,
        s.Brand,
        s.Color
    FROM shoes s
    JOIN pemesanan p ON s.OrderID = p.OrderID
    WHERE p.CustomerID = v_customer_id;

    -- Selesaikan transaksi
    COMMIT;

END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE insert_shoes(IN p_order_id INT, IN p_type VARCHAR(100), IN p_brand VARCHAR(100), IN p_color VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan data sepatu.';
    END;
    START TRANSACTION;
    INSERT INTO shoes (OrderID, Type, Brand, Color) VALUES (p_order_id, p_type, p_brand, p_color);
    COMMIT;
    SELECT 'Data sepatu berhasil ditambahkan.' AS Message;
END //
DELIMITER //

DELIMITER //
CREATE PROCEDURE update_shoes(IN p_shoes_id INT, IN p_type VARCHAR(100), IN p_brand VARCHAR(100), IN p_color VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui data sepatu.';
    END;
    START TRANSACTION;

    IF p_type IS NOT NULL THEN
        UPDATE shoes SET Type = p_type WHERE ShoesID = p_shoes_id;
    END IF;

    IF p_brand IS NOT NULL THEN
        UPDATE shoes SET Brand = p_brand WHERE ShoesID = p_shoes_id;
    END IF;

    IF p_color IS NOT NULL THEN
        UPDATE shoes SET Color = p_color WHERE ShoesID = p_shoes_id;
    END IF;

    COMMIT;
    SELECT 'Data sepatu berhasil diperbarui.' AS Message;
END //
DELIMITER //

DELIMITER //
CREATE PROCEDURE delete_shoes(IN p_shoes_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus data sepatu.';
    END;
    START TRANSACTION;
    DELETE FROM shoes WHERE ShoesID = p_shoes_id;
    COMMIT;
    SELECT 'Data sepatu berhasil dihapus.' AS Message;
END //
DELIMITER //



-- Tambahkan data shoes
INSERT INTO shoes (OrderID, Type, Brand, Color) VALUES
(3, 'Sneakers', 'Nike', 'Hitam'),
(4, 'Boots', 'Adidas', 'Coklat');

//------------------------------------------------------------------------------//

DELIMITER //
CREATE PROCEDURE get_all_payments()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil semua pembayaran.';
    END;

    START TRANSACTION;
    SELECT PaymentID, OrderID, Amount, PaymentDate FROM payment;
    COMMIT;
END //
DELIMITER //

CREATE PROCEDURE get_payment_by_id(IN p_payment_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil pembayaran berdasarkan ID.';
    END;

    START TRANSACTION;
    SELECT PaymentID, OrderID, Amount, PaymentDate FROM payment WHERE PaymentID = p_payment_id;
    COMMIT;
END //
DELIMITER //

CREATE PROCEDURE insert_payment(IN p_order_id INT, IN p_amount DECIMAL(10, 2), IN p_payment_date DATE)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan pembayaran.';
    END;

    START TRANSACTION;
    INSERT INTO payment (OrderID, Amount, PaymentDate) 
    VALUES (p_order_id, p_amount, p_payment_date);
    COMMIT;

    SELECT 'Data pembayaran berhasil ditambahkan.' AS Message;
END //
DELIMITER //

CREATE PROCEDURE update_payment(IN p_payment_id INT, IN p_amount DECIMAL(10, 2), IN p_payment_date DATE)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui pembayaran.';
    END;

    START TRANSACTION;
    UPDATE payment 
    SET Amount = p_amount, PaymentDate = p_payment_date 
    WHERE PaymentID = p_payment_id;
    COMMIT;

    SELECT 'Data pembayaran berhasil diperbarui.' AS Message;
END //
DELIMITER //

CREATE PROCEDURE delete_payment(IN p_payment_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus pembayaran.';
    END;

    START TRANSACTION;
    DELETE FROM payment WHERE PaymentID = p_payment_id;
    COMMIT;

    SELECT 'Data pembayaran berhasil dihapus.' AS Message;
END //
DELIMITER ;



-- Tambahkan data payment
INSERT INTO payment (PaymentID, OrderID, Amount, PaymentDate) VALUES
(3, 3, 50000.00, '2024-10-01'),
(4, 4, 75000.00, '2024-10-02');

//-------------------------------------------------------------------------------//

DELIMITER //
CREATE PROCEDURE register_employee(
    IN _name VARCHAR(100),
    IN _login_id VARCHAR(50),
    IN _password VARCHAR(100),
    IN _role VARCHAR(50)
)
BEGIN
    -- menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi input
    IF (_name IS NULL OR LENGTH(_name) < 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama tidak boleh kosong';
    END IF;

    IF (LENGTH(_login_id) < 3) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang LoginID minimal 3 karakter';
    END IF;

    IF (LENGTH(_password) < 8) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang password minimal 8 karakter';
    END IF;

    -- Insert data ke tabel employee
    INSERT INTO employee (Name, LoginID, Password, Role)
    VALUES (_name, _login_id, SHA2(_password, 256), _role);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE login_employee(
    IN _login_id VARCHAR(50),
    IN _password VARCHAR(100)
)
BEGIN
    -- menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validasi input
    IF (LENGTH(COALESCE(_login_id, '')) < 3) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang LoginID minimal 3 karakter';
    END IF;

    IF (LENGTH(_password) < 8) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang password minimal 8 karakter';
    END IF;

    -- Validasi Login
    IF NOT EXISTS (
        SELECT 1 FROM employee 
        WHERE LoginID = _login_id AND Password = SHA2(_password, 256)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LoginID atau password salah';
    END IF;

    -- Menampilkan data karyawan
    SELECT EmployeeID, Name, LoginID, Role
    FROM employee
    WHERE LoginID = _login_id AND Password = SHA2(_password, 256);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_employee(
    IN _employee_id INT,
    IN _name VARCHAR(100),
    IN _login_id VARCHAR(50),
    IN _password VARCHAR(100),
    IN _role VARCHAR(50)
)
BEGIN
    -- menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Update data karyawan
    UPDATE employee
    SET 
        Name = COALESCE(_name, Name),
        LoginID = COALESCE(_login_id, LoginID),
        Password = COALESCE(SHA2(_password, 256), Password),
        Role = COALESCE(_role, Role)
    WHERE EmployeeID = _employee_id;

    -- Menampilkan hasil update
    SELECT EmployeeID, Name, LoginID, Role
    FROM employee
    WHERE EmployeeID = _employee_id;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_employee(
    IN _employee_id INT
)
BEGIN
    -- menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Hapus data karyawan
    DELETE FROM employee
    WHERE EmployeeID = _employee_id;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_employees()
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Mengambil semua data karyawan
    SELECT EmployeeID, Name, LoginID, Role
    FROM employee;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_employee_by_id(IN _employee_id INT)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Mengambil data karyawan berdasarkan EmployeeID
    SELECT EmployeeID, Name, LoginID, Role
    FROM employee
    WHERE EmployeeID = _employee_id;

    COMMIT;
END//
DELIMITER ;



-- Tambahkan data employee
INSERT INTO employee (Name, LoginID, Password, Role) VALUES
('Dani', 'dani123', 'password1', 'Staff'),
('Rina', 'rina456', 'password2', 'Admin');

//-------------------------------------------------------------------------------//

DELIMITER //
CREATE PROCEDURE assign_order_to_employee(
    IN _order_id INT,
    IN _employee_id INT
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Insert assignment
    INSERT INTO order_assignment (OrderID, EmployeeID)
    VALUES (_order_id, _employee_id);

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE edit_employee_assignment(
    IN _assignment_id INT,
    IN _new_employee_id INT
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Update assignment
    UPDATE order_assignment
    SET EmployeeID = _new_employee_id
    WHERE AssignmentID = _assignment_id;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_assignments_by_employee(IN _employee_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil assignment berdasarkan EmployeeID.';
    END;

    START TRANSACTION;

    -- Mengambil data assignment berdasarkan EmployeeID
    SELECT AssignmentID, OrderID, EmployeeID
    FROM order_assignment
    WHERE EmployeeID = _employee_id;

    COMMIT;
END//
DELIMITER ;



DELIMITER //
CREATE PROCEDURE delete_assignment(
    IN _assignment_id INT
)
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Hapus assignment
    DELETE FROM order_assignment
    WHERE AssignmentID = _assignment_id;

    COMMIT;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_all_assignments()
BEGIN
    -- Menangani error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Mengambil semua data assignment
    SELECT AssignmentID, OrderID, EmployeeID
    FROM order_assignment;

    COMMIT;
END//
DELIMITER ;




-- Tambahkan data order_assignment
INSERT INTO order_assignment (OrderID, EmployeeID) VALUES
(3, 1),
(4, 2);

//-------------------------------------------------------------------------------//

DELIMITER //
CREATE PROCEDURE get_all_reviews()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data review.';
    END;

    START TRANSACTION;
    SELECT ReviewID, CustomerID, OrderID, Rating, Comment
    FROM review;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_review_by_id(IN p_review_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data review berdasarkan ID.';
    END;

    START TRANSACTION;
    SELECT ReviewID, CustomerID, OrderID, Rating, Comment
    FROM review
    WHERE ReviewID = p_review_id;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insert_review(
    IN p_customer_id INT, 
    IN p_order_id INT, 
    IN p_rating INT, 
    IN p_comment TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menambahkan data review.';
    END;

    START TRANSACTION;
    INSERT INTO review (CustomerID, OrderID, Rating, Comment)
    VALUES (p_customer_id, p_order_id, p_rating, p_comment);
    COMMIT;
    SELECT 'Data review berhasil ditambahkan.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_review(
    IN p_review_id INT, 
    IN p_rating INT, 
    IN p_comment TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat memperbarui data review.';
    END;

    START TRANSACTION;

    IF p_rating IS NOT NULL THEN
        UPDATE review SET Rating = p_rating WHERE ReviewID = p_review_id;
    END IF;

    IF p_comment IS NOT NULL THEN
        UPDATE review SET Comment = p_comment WHERE ReviewID = p_review_id;
    END IF;

    COMMIT;
    SELECT 'Data review berhasil diperbarui.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_review(IN p_review_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghapus data review.';
    END;

    START TRANSACTION;
    DELETE FROM review WHERE ReviewID = p_review_id;
    COMMIT;
    SELECT 'Data review berhasil dihapus.' AS Message;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_review_by_customer_id(IN p_customer_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data review berdasarkan CustomerID.';
    END;

    START TRANSACTION;
    SELECT ReviewID, CustomerID, OrderID, Rating, Comment
    FROM review
    WHERE CustomerID = p_customer_id;
    COMMIT;
END //
DELIMITER ;


-- Tambahkan data review
INSERT INTO review (CustomerID, OrderID, Rating, Comment) VALUES
(3, 3, 5, 'Layanan cepat dan memuaskan!'),
(4, 4, 4, 'Sedikit lambat, tetapi hasilnya bagus.');
//-------------------------------------------------------------------------------//
DELIMITER $$
CREATE FUNCTION generate_report(
    p_month INT,
    p_year INT
) RETURNS JSON
BEGIN
    DECLARE total_orders INT DEFAULT 0;
    DECLARE total_income DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE report JSON;

    -- Ambil jumlah pesanan dan total pendapatan
    SELECT 
        COUNT(p.OrderID),
        SUM(pay.Amount)
    INTO 
        total_orders,
        total_income
    FROM 
        pemesanan p
    JOIN 
        payment pay 
    ON 
        p.OrderID = pay.OrderID
    WHERE 
        MONTH(pay.PaymentDate) = p_month
        AND YEAR(pay.PaymentDate) = p_year;

    -- Buat laporan dalam format JSON
    SET report = JSON_OBJECT(
        'TotalOrders', total_orders,
        'TotalIncome', total_income
    );

    RETURN report;
END$$
DELIMITER ;


DELIMITER //
CREATE PROCEDURE generate_report_procedure(
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE v_report JSON;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat menghasilkan laporan.';
    END;

    START TRANSACTION;

    -- Memanggil function generate_report
    SET v_report = generate_report(p_month, p_year);

    -- Menampilkan hasil dalam bentuk JSON
    SELECT v_report AS Report;

    COMMIT;
END //
DELIMITER ;





//------------------------------------------------------------------------------//


DELIMITER //

CREATE VIEW review_by_customer_name AS
SELECT r.ReviewID, r.CustomerID, r.OrderID, r.Rating, r.Comment, c.Name AS CustomerName
FROM review r
JOIN customer c ON r.CustomerID = c.CustomerID;

DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_reviews_by_customer_name(IN p_customer_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaksi gagal saat mengambil data review berdasarkan nama customer.';
    END;

    START TRANSACTION;
    SELECT ReviewID, CustomerID, OrderID, Rating, Comment, CustomerName
    FROM review_by_customer_name
    WHERE CustomerName = p_customer_name;
    COMMIT;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER after_payment_insert
AFTER INSERT ON payment
FOR EACH ROW
BEGIN
    UPDATE pemesanan
    SET PaymentStatus = 'Lunas'
    WHERE OrderID = NEW.OrderID;
END //
DELIMITER ;

CREATE VIEW status_pembayaran AS
SELECT 
    p.OrderID,
    p.CustomerID,
    p.ServiceID,
    CASE
        WHEN EXISTS (
            SELECT 1 
            FROM payment pay 
            WHERE pay.OrderID = p.OrderID
        ) THEN 'Lunas'
        ELSE 'Belum Lunas'
    END AS PaymentStatus
FROM pemesanan p;

DELIMITER //
CREATE PROCEDURE get_status_pembayaran_by_customer_name(IN p_customer_name VARCHAR(255))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Gagal mengambil status pembayaran berdasarkan nama customer.';
    END;

    START TRANSACTION;
    SELECT sp.OrderID, sp.CustomerID, sp.ServiceID, sp.PaymentStatus
    FROM status_pembayaran sp
    JOIN customer c ON sp.CustomerID = c.CustomerID
    WHERE c.Name = p_customer_name;
    COMMIT;
END //
DELIMITER ;



ALTER TABLE pemesanan 
ADD COLUMN PaymentStatus VARCHAR(50) DEFAULT 'Belum Lunas';

