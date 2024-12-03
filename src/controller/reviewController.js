const Review = require('../models/review'); // Pastikan model sudah sesuai

// Controller untuk mendapatkan semua review
exports.getAllReviews = (req, res) => {
    Review.getAllReviews((err, results) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else {
            res.status(200).json(results); // Mengirimkan data review
        }
    });
};

// Controller untuk mendapatkan review berdasarkan ID
exports.getReviewById = (req, res) => {
    const { id } = req.params; // Mendapatkan ID dari parameter URL
    
    Review.getReviewById(id, (err, result) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else if (result) {
            res.status(200).json(result); // Mengirimkan data review
        } else {
            res.status(404).send('Review not found'); // Jika tidak ada review dengan ID tersebut
        }
    });
};

// Controller untuk mendapatkan review berdasarkan CustomerID
exports.getReviewByCustomerId = (req, res) => {
    const { CustomerID } = req.params; // Mendapatkan CustomerID dari parameter URL
    
    Review.getReviewByCustomerId(CustomerID, (err, results) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else if (results.length > 0) {
            res.status(200).json(results); // Mengirimkan data review berdasarkan CustomerID
        } else {
            res.status(404).send('No reviews found for this customer');
        }
    });
};

// Controller untuk menambahkan review baru
exports.createReview = (req, res) => {
    const { customer_id, order_id, rating, comment } = req.body; // Mendapatkan data dari body request
    
    Review.insertReview({ customer_id, order_id, rating, comment }, (err, results) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else {
            res.status(201).json({ message: 'Review added successfully', results });
        }
    });
};

// Controller untuk memperbarui review berdasarkan ReviewID
exports.updateReview = (req, res) => {
    const { id } = req.params; // Mendapatkan ID dari parameter URL
    const { rating, comment } = req.body; // Mendapatkan data yang ingin diperbarui dari body request
    
    Review.updateReview(id, { rating, comment }, (err, results) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else {
            res.status(200).json({ message: 'Review updated successfully', results });
        }
    });
};

// Controller untuk menghapus review berdasarkan ReviewID
exports.deleteReview = (req, res) => {
    const { id } = req.params; // Mendapatkan ID dari parameter URL
    
    Review.deleteReview(id, (err, results) => {
        if (err) {
            res.status(500).send(err); // Mengirimkan error ke client
        } else {
            res.status(200).json({ message: 'Review deleted successfully', results });
        }
    });
};
