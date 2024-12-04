const Employee = require('../models/employee');

// Register employee
exports.registerEmployee = (req, res) => {
    const { Name, LoginID, Password, Role } = req.body;

    Employee.registerEmployee({ Name, LoginID, Password, Role }, (err, results) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(201).json({ message: 'Employee registered successfully', results });
    });
};

// Login employee
exports.loginEmployee = (req, res) => {
    const { LoginID, Password } = req.body;

    Employee.loginEmployee({ LoginID, Password }, (err, results) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        if (results.length === 0) {
            return res.status(400).json({ message: 'Invalid LoginID or Password' });
        }
        res.status(200).json({ message: 'Login successful', employee: results[0] });
    });
};

// Edit employee
exports.editEmployee = (req, res) => {
    const { EmployeeID, Name, LoginID, Password, Role } = req.body;

    Employee.editEmployee({ EmployeeID, Name, LoginID, Password, Role }, (err, results) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ message: 'Employee updated successfully', results });
    });
};

// Delete employee
exports.deleteEmployee = (req, res) => {
    const { EmployeeID } = req.params;

    Employee.deleteEmployee(EmployeeID, (err, results) => {
        if (err) {
            return res.status(500).json({ message: err.sqlMessage });
        }
        res.status(200).json({ message: 'Employee deleted successfully', results });
    });
};

// Controller untuk mendapatkan semua data karyawan
exports.getAllEmployees = (req, res) => {
    Employee.getAllEmployees((err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat mengambil data karyawan',
                error: err
            });
        }
        res.status(200).json({
            message: 'Data karyawan berhasil diambil',
            data: results
        });
    });
};

// Controller untuk mendapatkan data karyawan berdasarkan ID
exports.getEmployeeById = (req, res) => {
    const employeeId = req.params.id;

    Employee.getEmployeeById(employeeId, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat mengambil data karyawan',
                error: err
            });
        }
        if (results.length === 0) {
            return res.status(404).json({
                message: 'Karyawan tidak ditemukan'
            });
        }
        res.status(200).json({
            message: 'Data karyawan berhasil diambil',
            data: results
        });
    });
};


exports.getOrdersByEmployeeName = (req, res) => {
    const { employeeName } = req.body; // Ambil employeeName dari request body

    if (!employeeName) {
        return res.status(400).json({ message: 'Employee name is required' });
    }

    // Panggil model
    Employee.getOrdersByEmployeeName(employeeName, (err, results) => {
        if (err) {
            if (err.sqlMessage) {
                return res.status(400).json({ message: err.sqlMessage }); // Error dari prosedur
            }
            console.error('Error fetching orders:', err);
            return res.status(500).json({ message: 'Server error' });
        }

        if (results.length === 0) {
            return res.status(404).json({ message: 'No orders found for this employee' });
        }

        res.status(200).json(results); // Kirim hasil
    });
};
