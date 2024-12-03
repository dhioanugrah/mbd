const Pemesanan = require('../models/pemesanan'); // Pastikan model pemesanan sudah sesuai

// Mendapatkan semua pemesanan
exports.getAllPemesanan = (req, res) => {
    Pemesanan.getAllPemesanan((err, results) => {
        if (err) {
            res.status(500).send(err);  // Jika terjadi error, kirimkan error
        } else {
            res.status(200).json(results);  // Mengirimkan data pemesanan dalam format JSON
        }
    });
};

// Mendapatkan pemesanan berdasarkan OrderID
exports.getPemesananById = (req, res) => {
    const { id } = req.params;  // Mendapatkan OrderID dari parameter URL
    Pemesanan.getById(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json(result);  // Mengirimkan data pemesanan dalam format JSON
        } else {
            res.status(404).send('Pemesanan tidak ditemukan');  // Jika tidak ada data, kirimkan pesan tidak ditemukan
        }
    });
};

// Membuat pemesanan baru
exports.createPemesanan = (req, res) => {
    const { CustomerID, ServiceID, Status, Date } = req.body;

    // Memanggil model untuk menambah pemesanan melalui procedure
    Pemesanan.create({ CustomerID, ServiceID, Status, Date }, (err, results) => {
        if (err) {
            res.status(500).send(err);  // Menangani error yang terjadi
        } else {
            res.status(201).json({ message: 'Pemesanan berhasil dibuat', results });  // Mengirimkan pesan sukses
        }
    });
};

// Memperbarui data pemesanan berdasarkan OrderID
exports.updatePemesanan = (req, res) => {
    const { id } = req.params;  // Mendapatkan OrderID dari parameter URL
    const data = req.body;  // Mendapatkan data yang ingin diperbarui dari body request

    // Memanggil model update dengan OrderID dan data
    Pemesanan.update(id, data, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else {
            res.status(200).json({ message: 'Pemesanan berhasil diperbarui', data: result });  // Mengirimkan pesan sukses
        }
    });
};

// Menghapus pemesanan berdasarkan OrderID
exports.deletePemesanan = (req, res) => {
    const { id } = req.params;  // Mendapatkan OrderID dari parameter URL
    Pemesanan.delete(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json({ message: 'Pemesanan berhasil dihapus' });  // Mengirimkan pesan sukses
        } else {
            res.status(404).send('Pemesanan tidak ditemukan');  // Jika tidak ada data yang dihapus, kirimkan pesan tidak ditemukan
        }
    });
};


// Fungsi untuk mendapatkan pemesanan berdasarkan nama customer
exports.getPemesananByName = (req, res) => {
    const { customerName } = req.body;  // Mengambil nama customer dari body request

    // Memanggil fungsi di model untuk mengambil pemesanan berdasarkan nama customer
    Pemesanan.getPemesananByName(customerName, (err, results) => {
        if (err) {
            console.error('Error executing query', err);
            return res.status(500).send('Server error');
        }

        if (results && results[0].length > 0) {
            // Jika ada hasil, kirimkan data pemesanan
            res.status(200).json(results[0]);
        } else {
            // Jika tidak ada hasil, beri respon bahwa customer tidak ditemukan
            res.status(404).json({ message: 'Customer not found or no orders found' });
        }
    });
};


// Controller untuk mendapatkan status pembayaran berdasarkan nama customer
exports.getStatusPembayaranByCustomerName = (req, res) => {
    const { customerName } = req.body; // Ambil nama customer dari body request

    if (!customerName) {
        return res.status(400).json({ message: 'Nama customer diperlukan.' });
    }

    Pemesanan.getStatusPembayaranByCustomerName(customerName, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            return res.status(500).send('Gagal mengambil status pembayaran berdasarkan nama customer.');
        }

        res.status(200).json({
            message: 'Data status pembayaran berdasarkan nama customer berhasil ditemukan.',
            data: results[0], // Hasil query
        });
    });
};