const express = require('express');
const router = express.Router();
const ShoesController = require('../controller/shoesController.js'); // Sesuaikan dengan lokasi controller

router.get('/', ShoesController.getAllShoes); // Mendapatkan semua data sepatu
router.get('/:id', ShoesController.getShoesById); // Mendapatkan data sepatu berdasarkan ShoesID
router.post('/', ShoesController.createShoes); // Menambahkan data sepatu baru
router.put('/:id', ShoesController.updateShoes); // Memperbarui data sepatu
router.delete('/:id', ShoesController.deleteShoes); // Menghapus data sepatu

module.exports = router;
