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


// Fungsi untuk mendapatkan sepatu berdasarkan nama customer
exports.getSepatuByCustomerName = (req, res) => {
    const { customerName } = req.body;  // Mengambil nama customer dari body request

    // Memanggil fungsi di model untuk mengambil sepatu berdasarkan nama customer
    Shoes.getSepatuByCustomerName(customerName, (err, results) => {
        if (err) {
            console.error('Error executing query', err);
            return res.status(500).send('Server error');
        }

        if (results && results[0].length > 0) {
            // Jika ada hasil, kirimkan data sepatu
            res.status(200).json(results[0]);
        } else {
            // Jika tidak ada hasil, beri respon bahwa customer tidak ditemukan atau tidak ada sepatu
            res.status(404).json({ message: 'Customer not found or no shoes found' });
        }
    });
};
