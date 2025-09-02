import React, { useState, useEffect } from 'react';
import { Container, Typography, Card, CardContent, Button, TextField, Grid, Chip } from '@mui/material';
import { Restaurant, People } from '@mui/icons-material';

function App() {
    const [foodListings, setFoodListings] = useState([]);
    const [newFood, setNewFood] = useState({
        restaurant: '',
        food_type: '',
        quantity: '',
        expiry_date: '',
        location: '',
        allergies: ''
    });

    useEffect(() => {
        fetchFoodListings();
    }, []);

    const fetchFoodListings = async () => {
        try {
            const response = await fetch('/api/food');
            const data = await response.json();
            setFoodListings(data);
        } catch (error) {
            console.error('Error fetching food listings:', error);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const response = await fetch('/api/food', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(newFood),
            });
            if (response.ok) {
                setNewFood({
                    restaurant: '',
                    food_type: '',
                    quantity: '',
                    expiry_date: '',
                    location: '',
                    allergies: ''
                });
                fetchFoodListings();
            }
        } catch (error) {
            console.error('Error adding food listing:', error);
        }
    };

    return (
        <Container maxWidth="lg" sx={{ py: 4 }}>
            <Typography variant="h3" component="h1" gutterBottom align="center" color="primary">
                🍽️ FoodShare - Reducing Food Waste
            </Typography>
            <Typography variant="h6" align="center" color="text.secondary" sx={{ mb: 4 }}>
                Connecting restaurants with leftover food to communities in need
            </Typography>

            <Grid container spacing={4}>
                <Grid item xs={12} md={6}>
                    <Card sx={{ mb: 4 }}>
                        <CardContent>
                            <Typography variant="h5" component="h2" gutterBottom>
                                <Restaurant sx={{ mr: 1 }} />
                                Add Food Listing
                            </Typography>
                            <form onSubmit={handleSubmit}>
                                <TextField
                                    fullWidth
                                    label="Restaurant Name"
                                    value={newFood.restaurant}
                                    onChange={(e) => setNewFood({ ...newFood, restaurant: e.target.value })}
                                    margin="normal"
                                    required
                                />
                                <TextField
                                    fullWidth
                                    label="Food Type"
                                    value={newFood.food_type}
                                    onChange={(e) => setNewFood({ ...newFood, food_type: e.target.value })}
                                    margin="normal"
                                    required
                                />
                                <TextField
                                    fullWidth
                                    label="Quantity"
                                    value={newFood.quantity}
                                    onChange={(e) => setNewFood({ ...newFood, quantity: e.target.value })}
                                    margin="normal"
                                    required
                                />
                                <TextField
                                    fullWidth
                                    label="Expiry Date"
                                    type="date"
                                    value={newFood.expiry_date}
                                    onChange={(e) => setNewFood({ ...newFood, expiry_date: e.target.value })}
                                    margin="normal"
                                    InputLabelProps={{ shrink: true }}
                                    required
                                />
                                <TextField
                                    fullWidth
                                    label="Location"
                                    value={newFood.location}
                                    onChange={(e) => setNewFood({ ...newFood, location: e.target.value })}
                                    margin="normal"
                                    required
                                />
                                <TextField
                                    fullWidth
                                    label="Allergies (comma-separated)"
                                    value={newFood.allergies}
                                    onChange={(e) => setNewFood({ ...newFood, allergies: e.target.value })}
                                    margin="normal"
                                />
                                <Button type="submit" variant="contained" color="primary" sx={{ mt: 2 }}>
                                    Add Food Listing
                                </Button>
                            </form>
                        </CardContent>
                    </Card>
                </Grid>

                <Grid item xs={12} md={6}>
                    <Card>
                        <CardContent>
                            <Typography variant="h5" component="h2" gutterBottom>
                                <People sx={{ mr: 1 }} />
                                Available Food
                            </Typography>
                            {foodListings.length === 0 ? (
                                <Typography color="text.secondary">No food listings available yet.</Typography>
                            ) : (
                                foodListings.map((food, index) => (
                                    <Card key={index} sx={{ mb: 2, p: 2 }}>
                                        <Typography variant="h6">{food.restaurant}</Typography>
                                        <Typography>{food.food_type} - {food.quantity}</Typography>
                                        <Typography color="text.secondary">Location: {food.location}</Typography>
                                        <Typography color="text.secondary">Expires: {new Date(food.expiry_date).toLocaleDateString()}</Typography>
                                        {food.allergies && (
                                            <div>
                                                {food.allergies.split(',').map((allergy, i) => (
                                                    <Chip key={i} label={allergy.trim()} size="small" sx={{ mr: 1, mt: 1 }} />
                                                ))}
                                            </div>
                                        )}
                                    </Card>
                                ))
                            )}
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
        </Container>
    );
}

export default App;
