const express = require('express');
const router = express.Router();
const pemesananController = require('../controller/pemesananController');

// Mendapatkan semua pemesanan
router.get('/', pemesananController.getAllPemesanan);

// Mendapatkan pemesanan berdasarkan OrderID
router.get('/:id', pemesananController.getPemesananById);

// Menambahkan pemesanan baru
router.post('/', pemesananController.createPemesanan);

// Memperbarui pemesanan berdasarkan OrderID
router.put('/:id', pemesananController.updatePemesanan);

// Menghapus pemesanan berdasarkan OrderID
router.delete('/:id', pemesananController.deletePemesanan);

module.exports = router;
