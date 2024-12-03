const db = require('../config/database');  // Sesuaikan dengan konfigurasi database Anda

// Mendapatkan semua pemesanan
exports.getAllPemesanan = (callback) => {
    const query = 'CALL get_all_pemesanan()';  // Memanggil prosedur yang telah dibuat
    db.query(query, callback);
};

// Mendapatkan pemesanan berdasarkan OrderID
exports.getById = (id, callback) => {
    const query = 'CALL get_pemesanan_by_id(?)';  // Memanggil prosedur dengan parameter OrderID
    db.query(query, [id], callback);
};

// Menambahkan pemesanan baru
exports.create = (data, callback) => {
    const { CustomerID, ServiceID, Status, Date } = data;
    const query = 'CALL insert_pemesanan(?, ?, ?, ?)';  // Memanggil prosedur insert_pemesanan
    db.query(query, [CustomerID, ServiceID, Status, Date], callback);
};

// Memperbarui pemesanan
exports.update = (id, data, callback) => {
    const { Status, Date } = data;
    const query = 'CALL update_pemesanan(?, ?, ?)';  // Memanggil prosedur update_pemesanan
    db.query(query, [id, Status, Date], callback);
};

// Menghapus pemesanan
exports.delete = (id, callback) => {
    const query = 'CALL delete_pemesanan(?)';  // Memanggil prosedur delete_pemesanan
    db.query(query, [id], callback);
};
