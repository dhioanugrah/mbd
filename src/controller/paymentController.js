const Payment = require('../models/payment');

// Mendapatkan semua pembayaran
exports.getAllPayments = (req, res) => {
    Payment.getAllPayments((err, results) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).json(results);
        }
    });
};

// Mendapatkan pembayaran berdasarkan PaymentID
exports.getPaymentById = (req, res) => {
    const { id } = req.params;
    Payment.getById(id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else if (result.length > 0) {
            res.status(200).json(result);
        } else {
            res.status(404).send('Data pembayaran tidak ditemukan.');
        }
    });
};

// Menambahkan pembayaran baru
exports.createPayment = (req, res) => {
    const { OrderID, Amount, PaymentDate } = req.body;
    Payment.create({ OrderID, Amount, PaymentDate }, (err, results) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(201).json({ message: 'Data pembayaran berhasil ditambahkan.', results });
        }
    });
};

// Memperbarui pembayaran berdasarkan PaymentID
exports.updatePayment = (req, res) => {
    const { id } = req.params;
    const { Amount, PaymentDate } = req.body;
    Payment.update(id, { Amount, PaymentDate }, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).json({ message: 'Data pembayaran berhasil diperbarui.', result });
        }
    });
};

// Menghapus pembayaran berdasarkan PaymentID
exports.deletePayment = (req, res) => {
    const { id } = req.params;
    Payment.delete(id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).json({ message: 'Data pembayaran berhasil dihapus.' });
        }
    });
};
