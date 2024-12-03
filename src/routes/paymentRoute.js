const express = require('express');
const router = express.Router();
const PaymentController = require('../controller/paymentController.js'); // Sesuaikan dengan lokasi controller

router.get('/', PaymentController.getAllPayments); // Mendapatkan semua pembayaran
router.get('/:id', PaymentController.getPaymentById); // Mendapatkan pembayaran berdasarkan PaymentID
router.post('/', PaymentController.createPayment); // Menambahkan pembayaran baru
router.put('/:id', PaymentController.updatePayment); // Memperbarui pembayaran
router.delete('/:id', PaymentController.deletePayment); // Menghapus pembayaran

module.exports = router;
