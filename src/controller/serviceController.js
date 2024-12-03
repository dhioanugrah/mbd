const Service = require('../models/service'); // Pastikan model service sudah sesuai

// Mendapatkan semua layanan
exports.getAllServices = (req, res) => {
    Service.getAllServices((err, results) => {
        if (err) {
            res.status(500).send(err);  // Jika terjadi error, kirimkan error
        } else {
            res.status(200).json(results);  // Mengirimkan data layanan dalam format JSON
        }
    });
};

// Mendapatkan layanan berdasarkan ID
exports.getServiceById = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    Service.getById(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json(result);  // Mengirimkan data layanan dalam format JSON
        } else {
            res.status(404).send('Service not found');  // Jika tidak ada data, kirimkan pesan tidak ditemukan
        }
    });
};

// Membuat layanan baru
exports.createService = (req, res) => {
    const { serviceName, price } = req.body;

    // Memanggil model untuk menambah layanan melalui procedure
    Service.create({ serviceName, price }, (err, results) => {
        if (err) {
            res.status(500).send(err);  // Menangani error yang terjadi
        } else {
            res.status(201).json({ message: 'Service created', results });  // Mengirimkan pesan sukses
        }
    });
};

// Memperbarui data layanan berdasarkan ID
exports.updateService = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    const data = req.body;  // Mendapatkan data yang ingin diperbarui dari body request

    // Memanggil model update dengan ID dan data
    Service.update(id, data, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else {
            res.status(200).json({ message: 'Service updated', data: result });  // Mengirimkan pesan sukses atau hasil query ke client
        }
    });
};

// Menghapus layanan berdasarkan ID
exports.deleteService = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    Service.delete(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json({ message: 'Service deleted' });  // Mengirimkan pesan sukses
        } else {
            res.status(404).send('Service not found');  // Jika tidak ada data yang dihapus, kirimkan pesan tidak ditemukan
        }
    });
};
