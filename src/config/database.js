const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'admin_mantan',
    password: 'admin123',
    database: 'mbd_final'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Database connected successfully.');
});

module.exports = db;
