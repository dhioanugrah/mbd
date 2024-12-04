const express = require('express');
const router = express.Router();
const employeeController = require('../controller/employeeController');


router.get('/', employeeController.getAllEmployees);
router.get('/:id', employeeController.getEmployeeById);
router.post('/register', employeeController.registerEmployee);
router.post('/login', employeeController.loginEmployee);
router.put('/edit', employeeController.editEmployee);
router.delete('/delete/:EmployeeID', employeeController.deleteEmployee);

router.post('/orders', employeeController.getOrdersByEmployeeName);
module.exports = router;
