const db = require('../config/database');

// Model untuk memberi assignment kepada employee
exports.assignOrderToEmployee = (orderId, employeeId, callback) => {
    const query = 'CALL assign_order_to_employee(?, ?)';
    db.query(query, [orderId, employeeId], callback);
};

// Model untuk mengubah assignment employee
exports.editEmployeeAssignment = (assignmentId, newEmployeeId, callback) => {
    const query = 'CALL edit_employee_assignment(?, ?)';
    db.query(query, [assignmentId, newEmployeeId], callback);
};

// Model untuk melihat assignment berdasarkan employee
exports.getAssignmentsByEmployee = (employeeId, callback) => {
    const query = 'CALL get_assignments_by_employee(?)';
    db.query(query, [employeeId], callback);
};

// Model untuk menghapus assignment
exports.deleteAssignment = (assignmentId, callback) => {
    const query = 'CALL delete_assignment(?)';
    db.query(query, [assignmentId], callback);
};

// Model untuk melihat semua assignment
exports.getAllAssignments = (callback) => {
    const query = 'CALL get_all_assignments()';
    db.query(query, callback);
};
