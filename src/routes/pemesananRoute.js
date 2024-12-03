const express = require('express');
const router = express.Router();
const pemesananController = require('../controller/pemesananController');


router.get('/', pemesananController.getAllPemesanan);
router.get('/:id', pemesananController.getPemesananById);
router.post('/', pemesananController.createPemesanan);
router.put('/:id', pemesananController.updatePemesanan);
router.delete('/:id', pemesananController.deletePemesanan);

router.post('/by-name', pemesananController.getPemesananByName);// Route POST untuk mendapatkan status pembayaran berdasarkan nama customer
router.post('/status-pembayaran-byname', pemesananController.getStatusPembayaranByCustomerName);


module.exports = router;
