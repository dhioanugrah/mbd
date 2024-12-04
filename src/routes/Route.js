const express = require('express');
const customerController = require('../controller/customerController');
const router = express.Router();

//route customer
router.get('/', customerController.getAllCustomers);
router.get('/:id', customerController.getCustomerById);
router.post('/', customerController.createCustomer);
router.put('/:id', customerController.updateCustomer);
router.delete('/:id', customerController.deleteCustomer);

router.post('/by-name', customerController.getCustomerByName);
module.exports = router;
