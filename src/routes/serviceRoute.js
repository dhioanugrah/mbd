const express = require('express');
const router = express.Router();
const ServiceController = require('../controller/serviceController.js'); // Sesuaikan dengan controller yang ada

// Contoh route GET dan POST untuk service
router.get('/', ServiceController.getAllServices);  // Mendapatkan semua layanan
router.get('/:id', ServiceController.getServiceById);  // Mendapatkan layanan berdasarkan ID
router.post('/', ServiceController.createService);  // Menambahkan layanan baru
router.put('/:id', ServiceController.updateService);  // Memperbarui layanan
router.delete('/:id', ServiceController.deleteService);  // Menghapus layanan

module.exports = router;
