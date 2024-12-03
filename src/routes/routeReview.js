const express = require('express');
const router = express.Router();
const reviewController = require('../controller/reviewController');  // Pastikan sudah diimpor dengan benar

// Get all reviews
router.get('/reviews', reviewController.getAllReviews);

// Get review by ID  
router.get('/reviews/:id', reviewController.getReviewById);

// Create a new review
router.post('/reviews', reviewController.createReview);  // Perbaiki penggunaan createReview

// Update review
router.put('/reviews/:id', reviewController.updateReview);

// Delete review
router.delete('/reviews/:id', reviewController.deleteReview);

// Mendapatkan review berdasarkan CustomerID
router.get('/reviews/customer/:CustomerID', reviewController.getReviewByCustomerId);  // Perbaiki rute

router.post('/reviews/byname', reviewController.getReviewByCustomername);

module.exports = router;
