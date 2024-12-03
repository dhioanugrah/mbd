const express = require('express');
const router = express.Router();
const assignmentController = require('../controller/assignmentController');

// Endpoint untuk memberikan assignment kepada employee
router.post('/assign-order', assignmentController.assignOrderToEmployee);

// Endpoint untuk mengubah assignment employee
router.put('/assign-order/:id', assignmentController.editEmployeeAssignment);

// Endpoint untuk melihat assignment berdasarkan employee
router.get('/assignments/employee/:id', assignmentController.getAssignmentsByEmployee);

// Endpoint untuk menghapus assignment
router.delete('/assign-order/:id', assignmentController.deleteAssignment);

// Endpoint untuk melihat semua assignment
router.get('/assignments', assignmentController.getAllAssignments);

module.exports = router;
