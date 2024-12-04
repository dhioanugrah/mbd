const db = require('../config/database');

// Mendapatkan semua sepatu
exports.getAllShoes = (callback) => {
    const query = 'CALL get_all_shoes()';
    db.query(query, callback);
};

// Mendapatkan sepatu berdasarkan ShoesID
exports.getById = (id, callback) => {
    const query = 'CALL get_shoes_by_id(?)';
    db.query(query, [id], callback);
};

// Menambahkan sepatu baru
exports.create = (data, callback) => {
    const { OrderID, Type, Brand, Color } = data;
    const query = 'CALL insert_shoes(?, ?, ?, ?)';
    db.query(query, [OrderID, Type, Brand, Color], callback);
};

// Memperbarui sepatu
exports.update = (id, data, callback) => {
    const { Type, Brand, Color } = data;
    const query = 'CALL update_shoes(?, ?, ?, ?)';
    db.query(query, [id, Type, Brand, Color], callback);
};

// Menghapus sepatu
exports.delete = (id, callback) => {
    const query = 'CALL delete_shoes(?)';
    db.query(query, [id], callback);
};

// Mendapatkan sepatu berdasarkan nama customer
exports.getSepatuByCustomerName = (customerName, callback) => {
    const query = 'CALL get_sepatu_by_customer_name(?)';  // Memanggil prosedur yang baru dibuat
    db.query(query, [customerName], callback);  // Menjalankan query dan mengirimkan callback
};
