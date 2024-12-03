const db = require('../config/database');

// Mendapatkan semua pembayaran
exports.getAllPayments = (callback) => {
    const query = 'CALL get_all_payments()';
    db.query(query, callback);
};

// Mendapatkan pembayaran berdasarkan PaymentID
exports.getById = (id, callback) => {
    const query = 'CALL get_payment_by_id(?)';
    db.query(query, [id], callback);
};

// Menambahkan pembayaran baru
exports.create = (data, callback) => {
    const { OrderID, Amount, PaymentDate } = data;
    const query = 'CALL insert_payment(?, ?, ?)';
    db.query(query, [OrderID, Amount, PaymentDate], callback);
};

// Memperbarui pembayaran
exports.update = (id, data, callback) => {
    const { Amount, PaymentDate } = data;
    const query = 'CALL update_payment(?, ?, ?)';
    db.query(query, [id, Amount, PaymentDate], callback);
};

// Menghapus pembayaran
exports.delete = (id, callback) => {
    const query = 'CALL delete_payment(?)';
    db.query(query, [id], callback);
};

// Memanggil procedure untuk mendapatkan laporan
exports.generateReport = (month, year, callback) => {
    const query = 'CALL generate_report_procedure(?, ?)';
    db.query(query, [month, year], callback);
};

