const Assignment = require('../models/assignmentModel');

// Controller untuk memberi assignment kepada employee
exports.assignOrderToEmployee = (req, res) => {
    const { orderId, employeeId } = req.body;

    Assignment.assignOrderToEmployee(orderId, employeeId, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat memberikan assignment',
                error: err
            });
        }
        res.status(201).json({
            message: 'Assignment berhasil diberikan',
            data: results
        });
    });
};

// Controller untuk mengubah assignment employee
exports.editEmployeeAssignment = (req, res) => {
    const assignmentId = req.params.id;
    const { newEmployeeId } = req.body;

    Assignment.editEmployeeAssignment(assignmentId, newEmployeeId, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat mengubah assignment',
                error: err
            });
        }
        res.status(200).json({
            message: 'Assignment berhasil diubah',
            data: results
        });
    });
};

// Controller untuk melihat assignment berdasarkan employee
exports.getAssignmentsByEmployee = (req, res) => {
    const employeeId = req.params.id;

    Assignment.getAssignmentsByEmployee(employeeId, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat mengambil data assignment',
                error: err
            });
        }
        res.status(200).json({
            message: 'Data assignment berhasil diambil',
            data: results
        });
    });
};

// Controller untuk menghapus assignment
exports.deleteAssignment = (req, res) => {
    const assignmentId = req.params.id;

    Assignment.deleteAssignment(assignmentId, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat menghapus assignment',
                error: err
            });
        }
        res.status(200).json({
            message: 'Assignment berhasil dihapus',
            data: results
        });
    });
};

// Controller untuk melihat semua assignment
exports.getAllAssignments = (req, res) => {
    Assignment.getAllAssignments((err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Terjadi kesalahan saat mengambil semua assignment',
                error: err
            });
        }
        res.status(200).json({
            message: 'Data assignment berhasil diambil',
            data: results
        });
    });
};
