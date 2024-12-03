const Shoes = require('../models/shoes');

// Mendapatkan semua sepatu
exports.getAllShoes = (req, res) => {
    Shoes.getAllShoes((err, results) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).json(results);
        }
    });
};

// Mendapatkan sepatu berdasarkan ShoesID
exports.getShoesById = (req, res) => {
    const { id } = req.params;
    Shoes.getById(id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else if (result) {
            res.status(200).json(result);
        } else {
            res.status(404).send('Data sepatu tidak ditemukan.');
        }
    });
};

// Menambahkan sepatu baru
exports.createShoes = (req, res) => {
    const { OrderID, Type, Brand, Color } = req.body;
    Shoes.create({ OrderID, Type, Brand, Color }, (err, results) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(201).json({ message: 'Data sepatu berhasil ditambahkan.', results });
        }
    });
};

// Memperbarui data sepatu berdasarkan ShoesID
exports.updateShoes = (req, res) => {
    const { id } = req.params;
    const data = req.body;
    Shoes.update(id, data, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).json({ message: 'Data sepatu berhasil diperbarui.', result });
        }
    });
};

// Menghapus sepatu berdasarkan ShoesID
exports.deleteShoes = (req, res) => {
    const { id } = req.params;
    Shoes.delete(id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else if (result) {
            res.status(200).json({ message: 'Data sepatu berhasil dihapus.' });
        } else {
            res.status(404).send('Data sepatu tidak ditemukan.');
        }
    });
};
