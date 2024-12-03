const db = require('../config/database'); // Menghubungkan ke konfigurasi database

// Register employee
exports.registerEmployee = (data, callback) => {
    const { Name, LoginID, Password, Role } = data;
    const query = 'CALL register_employee(?, ?, ?, ?)';
    db.query(query, [Name, LoginID, Password, Role], callback);
};

// Login employee
exports.loginEmployee = (data, callback) => {
    const { LoginID, Password } = data;
    const query = 'CALL login_employee(?, ?)';
    db.query(query, [LoginID, Password], callback);
};

// Edit employee
exports.editEmployee = (data, callback) => {
    const { EmployeeID, Name, LoginID, Password, Role } = data;
    const query = 'CALL edit_employee(?, ?, ?, ?, ?)';
    db.query(query, [EmployeeID, Name, LoginID, Password, Role], callback);
};

// Delete employee
exports.deleteEmployee = (EmployeeID, callback) => {
    const query = 'CALL delete_employee(?)';
    db.query(query, [EmployeeID], callback);
};

// Model untuk mengambil semua data karyawan
exports.getAllEmployees = (callback) => {
    const query = 'CALL get_all_employees()';
    db.query(query, callback);
};

// Model untuk mengambil karyawan berdasarkan ID
exports.getEmployeeById = (employeeId, callback) => {
    const query = 'CALL get_employee_by_id(?)';
    db.query(query, [employeeId], callback);
};