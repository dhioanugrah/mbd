const db = require('../config/database'); // Menghubungkan ke konfigurasi database

// Mendapatkan semua pelanggan dengan prosedur menggunakan transaksi
exports.getAllCustomers = (callback) => {
    const query = 'CALL get_all_customers()'; // Memanggil prosedur get_all_customers
    
    db.query(query, (err, results) => {
        if (err) {
            callback(err, null); // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // MySQL akan membungkus hasil dalam array
        }
    });
};

// Model untuk mendapatkan data pelanggan berdasarkan ID menggunakan prosedur
exports.getById = (id, callback) => {
    const query = 'CALL get_customer_by_id(?)';  // Memanggil prosedur get_customer_by_id dengan parameter ID
    
    db.query(query, [id], (err, results) => {
        if (err) {
            callback(err, null);  // Jika ada error, kirimkan error ke callback
        } else {
            callback(null, results[0][0]);  // MySQL akan membungkus hasil dalam array, ambil hasil pertama
        }
    });
};


exports.create = (data, callback) => {
    const { name, email, phone } = data;
    const query = 'CALL tambah_customer(?, ?, ?)';
    
    db.query(query, [name, email, phone], callback);
};


// Model untuk memperbarui data customer menggunakan prosedur
exports.update = (id, data, callback) => {
    const { name, email, phone } = data;
    const query = 'CALL update_customer(?, ?, ?, ?)'; // Memanggil prosedur update_customer
    
    db.query(query, [id, name, email, phone], (err, results) => {
        if (err) {
            callback(err, null); // Mengirimkan error ke callback jika ada kesalahan
        } else {
            callback(null, results[0]); // Mengirimkan hasil dari query (hasil pesan sukses)
        }
    });
};


// Model untuk menghapus data customer berdasarkan ID menggunakan prosedur
exports.delete = (id, callback) => {
    const query = 'CALL delete_customer(?)';  // Memanggil prosedur delete_customer dengan parameter ID
    
    db.query(query, [id], (err, results) => {
        if (err) {
            callback(err, null);  // Jika ada error, kirimkan error ke callback
        } else {
            callback(null, results[0]);  // Mengirimkan hasil sukses ke callback
        }
    });
};



// Mendapatkan pemesanan berdasarkan nama customer
exports.getCustomerByName = (customerName, callback) => {
    const query = 'CALL get_order_by_customer_name(?)';  // Memanggil prosedur yang baru dibuat
    db.query(query, [customerName], callback);  // Menjalankan query dan mengirimkan callback
};
