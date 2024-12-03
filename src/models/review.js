const db = require('../config/database'); // Menghubungkan ke konfigurasi database

// Mendapatkan semua review
exports.getAllReviews = (callback) => {
    const query = 'CALL get_all_reviews()'; // Memanggil prosedur get_all_reviews
    
    db.query(query, (err, results) => {
        if (err) {
            callback(err, null); // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // MySQL akan membungkus hasil dalam array
        }
    });
};

// Mendapatkan review berdasarkan ID
exports.getReviewById = (reviewId, callback) => {
    const query = 'CALL get_review_by_id(?)';  // Memanggil prosedur get_review_by_id dengan parameter ReviewID
    
    db.query(query, [reviewId], (err, results) => {
        if (err) {
            callback(err, null);  // Jika ada error, kirimkan error ke callback
        } else {
            callback(null, results[0][0]);  // Mengambil hasil pertama dari query
        }
    });
};

// Mendapatkan review berdasarkan CustomerID
exports.getReviewByCustomerId = (CustomerID, callback) => {
    const query = 'CALL get_review_by_customer_id(?)'; // Memanggil prosedur get_review_by_customer_id dengan parameter CustomerID
    
    db.query(query, [CustomerID], (err, results) => {
        if (err) {
            callback(err, null);  // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // Mengirimkan hasil review ke callback
        }
    });
};

// Menambahkan review baru
exports.insertReview = (data, callback) => {
    const { customer_id, order_id, rating, comment } = data;
    const query = 'CALL insert_review(?, ?, ?, ?)';
    
    db.query(query, [customer_id, order_id, rating, comment], (err, results) => {
        if (err) {
            callback(err, null);  // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // Mengirimkan hasil sukses
        }
    });
};

// Memperbarui review berdasarkan ReviewID
exports.updateReview = (reviewId, data, callback) => {
    const { rating, comment } = data;
    const query = 'CALL update_review(?, ?, ?)';
    
    db.query(query, [reviewId, rating, comment], (err, results) => {
        if (err) {
            callback(err, null);  // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // Mengirimkan hasil sukses
        }
    });
};

// Menghapus review berdasarkan ReviewID
exports.deleteReview = (reviewId, callback) => {
    const query = 'CALL delete_review(?)';  // Memanggil prosedur delete_review dengan parameter ReviewID
    
    db.query(query, [reviewId], (err, results) => {
        if (err) {
            callback(err, null);  // Mengirimkan error ke callback
        } else {
            callback(null, results[0]); // Mengirimkan hasil sukses
        }
    });
};


// Fungsi untuk mendapatkan review berdasarkan nama customer
exports.getReviewsByCustomerName = function(customerName) {
    return new Promise((resolve, reject) => {
        const query = 'CALL get_reviews_by_customer_name(?)';
        db.query(query, [customerName], (err, results) => {
            if (err) {
                return reject(err);
            }
            resolve(results[0]); // Karena hasil prosedur ada dalam array [0]
        });
    });
};