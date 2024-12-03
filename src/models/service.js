const db = require('../config/database');  // Sesuaikan dengan konfigurasi database Anda

// Mendapatkan semua layanan
exports.getAllServices = (callback) => {
    const query = 'CALL get_all_services()';  // Memanggil prosedur yang telah dibuat
    db.query(query, callback);
};

// Mendapatkan layanan berdasarkan ID
exports.getById = (id, callback) => {
    const query = 'CALL get_service_by_id(?)';  // Memanggil prosedur dengan parameter ID
    db.query(query, [id], callback);
};

// Menambahkan layanan baru
exports.create = (data, callback) => {
    const { serviceName, price } = data;
    const query = 'CALL insert_service(?, ?)';  // Memanggil prosedur insert_service
    db.query(query, [serviceName, price], callback);
};

// Memperbarui layanan
exports.update = (id, data, callback) => {
    const { serviceName, price } = data;
    const query = 'CALL update_service(?, ?, ?)';  // Memanggil prosedur update_service
    db.query(query, [id, serviceName, price], callback);
};

// Menghapus layanan
exports.delete = (id, callback) => {
    const query = 'CALL delete_service(?)';  // Memanggil prosedur delete_service
    db.query(query, [id], callback);
};
