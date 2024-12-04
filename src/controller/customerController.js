const Customer = require('../models/customer'); // Pastikan customer model sudah sesuai

// Mendapatkan semua pelanggan
exports.getAllCustomers = (req, res) => {
    Customer.getAllCustomers((err, results) => {
        if (err) res.status(500).send(err);
        else res.status(200).json(results); // Mengirimkan data pelanggan
    });
};


// Controller untuk mendapatkan data pelanggan berdasarkan ID
exports.getCustomerById = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    Customer.getById(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json(result);  // Mengirimkan data pelanggan dalam format JSON
        } else {
            res.status(404).send('Customer not found');  // Jika tidak ada data, kirimkan pesan tidak ditemukan
        }
    });
};


exports.createCustomer = (req, res) => {
    const { name, email, phone } = req.body;

    // Memanggil model untuk menambah customer melalui procedure
    Customer.create({ name, email, phone }, (err, results) => {
        if (err) {
            // Menangani error yang terjadi
            res.status(500).send(err);
        } else {
            // Jika berhasil, kembalikan pesan sukses
            res.status(201).json({ message: 'Customer created', results });
        }
    });
};


// Controller untuk memperbarui data customer berdasarkan ID
exports.updateCustomer = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    const data = req.body;  // Mendapatkan data yang ingin diperbarui dari body request

    // Memanggil model update dengan ID dan data
    Customer.update(id, data, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else {
            res.status(200).json(result);  // Mengirimkan pesan sukses atau hasil query ke client
        }
    });
};

// Controller untuk menghapus data pelanggan berdasarkan ID
exports.deleteCustomer = (req, res) => {
    const { id } = req.params;  // Mendapatkan ID dari parameter URL
    Customer.delete(id, (err, result) => {
        if (err) {
            res.status(500).send(err);  // Jika ada error, kirimkan error ke client
        } else if (result) {
            res.status(200).json({ message: 'Customer deleted' });  // Mengirimkan pesan sukses
        } else {
            res.status(404).send('Customer not found');  // Jika tidak ada data yang dihapus, kirimkan pesan tidak ditemukan
        }
    });
};


// Membuat pesanan baru menggunakan prosedur tersimpan di database
exports.createOrder = (req, res) => {
    const { customer_id, service_id, status, date, items } = req.body;
    const query = 'CALL buat_pesanan(?, ?, ?, ?, ?)';
    db.query(query, [customer_id, service_id, status, date, JSON.stringify(items)], (err, results) => {
        if (err) res.status(500).send(err);
        else res.status(201).json({ message: 'Order created', results });
    });
};

// Fungsi untuk mendapatkan pemesanan berdasarkan nama customer
exports.getCustomerByName = (req, res) => {
    const { customerName } = req.body;  // Mengambil nama customer dari body request

    // Memanggil fungsi di model untuk mengambil pemesanan berdasarkan nama customer
    Customer.getCustomerByName(customerName, (err, results) => {
        if (err) {
            console.error('Error executing query', err);
            return res.status(500).send('Server error');
        }

        if (results && results[0].length > 0) {
            // Jika ada hasil, kirimkan data pemesanan
            res.status(200).json(results[0]);
        } else {
            // Jika tidak ada hasil, beri respon bahwa customer tidak ditemukan atau tidak ada pemesanan
            res.status(404).json({ message: 'Customer not found or no orders found' });
        }
    });
};
