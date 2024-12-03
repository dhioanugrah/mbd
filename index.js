const express = require('express');
const customerRoutes = require('./src/routes/Route');  // Pastikan path benar
const serviceRoutes = require('./src/routes/serviceRoute');  // Pastikan path benar
const pemesananRoute = require('./src/routes/pemesananRoute');  // Pastikan path benar
const shoesRoute = require('./src/routes/shoesRoute');  // Pastikan path benar
const paymentRoute = require('./src/routes/paymentRoute');  // Pastikan path benar
const employeeRoute = require('./src/routes/employeeRoute');  // Pastikan path benar
const assignmentRoute = require('./src/routes/assignmentRoute');  // Pastikan path benar
const routeReview = require('./src/routes/routeReview');  // Pastikan path benar


const app = express();

app.use(express.json()); // Parsing JSON
app.use('/customers', customerRoutes); // Routing ke customerRoutes
app.use('/service', serviceRoutes); // Routing ke serviceRoutes
app.use('/pemesanan', pemesananRoute); // Routing ke pemesananRoutes
app.use('/shoes', shoesRoute); // Routing ke shoesRoutes
app.use('/payments', paymentRoute); // Routing ke paymentRoutes
app.use('/employees', employeeRoute); // Routing ke employeeRoutes
app.use('/api', assignmentRoute); // Routing ke assignmentRoutes
app.use('/api', routeReview); // Routing ke reviewRoutes (perbaiki path)

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
