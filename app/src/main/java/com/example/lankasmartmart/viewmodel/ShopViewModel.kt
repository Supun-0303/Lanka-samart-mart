package com.example.lankasmartmart.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.lankasmartmart.data.local.DatabaseProvider
import com.example.lankasmartmart.data.local.entity.CartItemEntity
import com.example.lankasmartmart.data.local.entity.SearchHistoryEntity
import com.example.lankasmartmart.model.Category
import com.example.lankasmartmart.model.Product
import com.example.lankasmartmart.repository.ProductRepository
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

class ShopViewModel(application: Application) : AndroidViewModel(application) {
    private val productRepository = ProductRepository()
    private val firestore = FirebaseFirestore.getInstance()
    
    // Room DAOs
    private val db = DatabaseProvider.getDatabase(application)
    private val cartDao = db.cartDao()
    private val searchHistoryDao = db.searchHistoryDao()
    
    private val _categories = MutableStateFlow<List<Category>>(emptyList())
    val categories: StateFlow<List<Category>> = _categories
    
    private val _products = MutableStateFlow<List<Product>>(emptyList())
    val products: StateFlow<List<Product>> = _products
    
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading
    
    // Cart State
    private val _cartItems = MutableStateFlow<List<com.example.lankasmartmart.model.CartItem>>(emptyList())
    val cartItems: StateFlow<List<com.example.lankasmartmart.model.CartItem>> = _cartItems
    
    val cartItemCount: StateFlow<Int> = MutableStateFlow(0)
    val cartSubtotal: StateFlow<Double> = MutableStateFlow(0.0)
    val deliveryFee: StateFlow<Double> = MutableStateFlow(150.0)
    val cartTotal: StateFlow<Double> = MutableStateFlow(0.0)
    
    // Search State
    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery
    
    private val _searchResults = MutableStateFlow<List<Product>>(emptyList())
    val searchResults: StateFlow<List<Product>> = _searchResults
    
    // Search History from Room
    val searchHistory = searchHistoryDao.getRecentSearches()
        .stateIn(viewModelScope, SharingStarted.Lazily, emptyList())
    
    // Promotion State
    private val _promotions = MutableStateFlow<List<com.example.lankasmartmart.model.Promotion>>(emptyList())
    val promotions: StateFlow<List<com.example.lankasmartmart.model.Promotion>> = _promotions
    
    init {
        loadCategories()
        loadProducts()
        loadPromotions()
        loadCartFromDatabase()
    }
    
    // Load categories from Firestore (or use mock data)
    private fun loadCategories() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                // For now, using mock data. Later we'll fetch from Firestore
                _categories.value = getMockCategories()
            } catch (e: Exception) {
                // Handle error
                _categories.value = getMockCategories() // Fallback to mock
            } finally {
                _isLoading.value = false
            }
        }
    }
    
    // Load products from Firestore
    private fun loadProducts() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val result = productRepository.getAllProducts()
                val fetchedProducts = result.getOrElse { emptyList() }
                
                if (fetchedProducts.isNotEmpty()) {
                    _products.value = fetchedProducts
                } else {
                    // Fallback to mock data if Firestore returns empty
                    _products.value = getMockProducts()
                }
                _searchResults.value = _products.value
            } catch (e: Exception) {
                // Handle error - fallback to mock
                _products.value = getMockProducts()
            } finally {
                _isLoading.value = false
            }
        }
    }
    
    // Load promotions
    private fun loadPromotions() {
        _promotions.value = getMockPromotions()
    }
    
    // Get products by category
    fun getProductsByCategory(categoryId: String): List<Product> {
        return _products.value.filter { it.category == categoryId }
    }
    
    // Mock data for categories (Sri Lankan context)
    private fun getMockCategories(): List<Category> {
        return listOf(
            Category(
                id = "groceries",
                name = "Groceries",
                icon = "🛒",
                description = "Rice, Dal, Flour & more"
            ),
            Category(
                id = "vegetables",
                name = "Vegetables",
                icon = "🥬",
                description = "Fresh vegetables"
            ),
            Category(
                id = "fruits",
                name = "Fruits",
                icon = "🍎",
                description = "Fresh fruits"
            ),
            Category(
                id = "dairy",
                name = "Dairy",
                icon = "🥛",
                description = "Milk, Curd, Cheese"
            ),
            Category(
                id = "beverages",
                name = "Beverages",
                icon = "☕",
                description = "Tea, Coffee, Juice"
            ),
            Category(
                id = "snacks",
                name = "Snacks",
                icon = "🍿",
                description = "Chips, Biscuits & more"
            ),
            Category(
                id = "personal_care",
                name = "Personal Care",
                icon = "🧴",
                description = "Soap, Shampoo, Toiletries"
            ),
            Category(
                id = "household",
                name = "Household",
                icon = "🧹",
                description = "Cleaning supplies"
            ),
            Category(
                id = "stationery",
                name = "Stationery",
                icon = "✏️",
                description = "Books, Pens, Paper"
            )
        )
    }
    
    // Mock data for promotions
    private fun getMockPromotions(): List<com.example.lankasmartmart.model.Promotion> {
        return listOf(
            com.example.lankasmartmart.model.Promotion(
                id = "promo1",
                title = "Avurudu Special",
                subtitle = "Up to 40% OFF on Groceries",
                backgroundColor = "#53B175",
                actionType = "category",
                actionId = "groceries"
            ),
            com.example.lankasmartmart.model.Promotion(
                id = "promo2",
                title = "Fresh Beverages",
                subtitle = "20% OFF on all Juices",
                backgroundColor = "#F8A44C",
                actionType = "category",
                actionId = "beverages"
            ),
            com.example.lankasmartmart.model.Promotion(
                id = "promo3",
                title = "Snack Time!",
                subtitle = "Buy 2 Get 1 FREE on Biscuits",
                backgroundColor = "#D3B0E0",
                actionType = "category",
                actionId = "snacks"
            )
        )
    }
    
    // Mock data for products (Sri Lankan products)
    private fun getMockProducts(): List<Product> {
        return listOf(
            // Groceries
            Product(id = "1", name = "Premium Basmati Rice", description = "Aromatic basmati rice for perfect biryani.", price = 450.0, originalPrice = 500.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/rice_basmati", stock = 50, unit = "1 kg", brand = "Araliya", isOnSale = true, discount = 10, rating = 4.8f, reviewCount = 125),
            Product(id = "2", name = "Wheat Flour", description = "Fine multipurpose wheat flour.", price = 220.0, originalPrice = 0.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/flour_wheat", stock = 150, unit = "1 kg", brand = "Prima", rating = 4.5f, reviewCount = 85),
            Product(id = "3", name = "Red Lentils (Dhal)", description = "High-protein split red lentils.", price = 380.0, originalPrice = 0.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/dhal_red", stock = 80, unit = "1 kg", brand = "Fortune", rating = 4.6f, reviewCount = 92),
            Product(id = "20", name = "White Sugar", description = "Pure refined white sugar.", price = 260.0, originalPrice = 0.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/sugar_white", stock = 150, unit = "1 kg", brand = "Pelican", rating = 4.4f, reviewCount = 110),
            Product(id = "22", name = "Virgin Coconut Oil", description = "100% pure cold-pressed coconut oil.", price = 560.0, originalPrice = 0.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/coconut_oil", stock = 45, unit = "1 L", brand = "Marina", rating = 4.7f, reviewCount = 130),
            Product(id = "53", name = "Penne Pasta", description = "Durum wheat semolina penne pasta.", price = 350.0, originalPrice = 0.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/pasta_penne", stock = 50, unit = "500g", brand = "Bari", rating = 4.7f, reviewCount = 45),
            
            // Vegetables
            Product(id = "4", name = "Organic Carrots", description = "Freshly harvested organic carrots.", price = 150.0, originalPrice = 0.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/vegetable_carrot", stock = 45, unit = "500g", brand = "EcoFarm", rating = 4.7f, reviewCount = 64),
            Product(id = "5", name = "Fresh Tomatoes", description = "Juicy red tomatoes.", price = 180.0, originalPrice = 0.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/vegetable_tomato", stock = 30, unit = "500g", brand = "Local", rating = 4.4f, reviewCount = 56),
            Product(id = "23", name = "Potatoes", description = "Quality local potatoes.", price = 320.0, originalPrice = 0.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/vegetable_potato", stock = 80, unit = "1 kg", brand = "Local", rating = 4.5f, reviewCount = 65),
            Product(id = "24", name = "Red Onions", description = "Freshly harvested red onions.", price = 380.0, originalPrice = 0.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/vegetable_onion", stock = 60, unit = "1 kg", brand = "Local", rating = 4.3f, reviewCount = 80),
            Product(id = "48", name = "Bell Peppers", description = "Crisp bell peppers.", price = 180.0, originalPrice = 0.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/vegetable_pepper", stock = 60, unit = "250g", brand = "Local", rating = 4.5f, reviewCount = 32),
            
            // Fruits
            Product(id = "6", name = "Organic Bananas", description = "Sweet Cavendish bananas.", price = 120.0, originalPrice = 0.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_banana", stock = 60, unit = "1 kg", brand = "Local", rating = 4.9f, reviewCount = 110),
            Product(id = "26", name = "Sweet Mango", description = "Deliciously sweet mangoes.", price = 450.0, originalPrice = 0.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_mango", stock = 30, unit = "1 kg", brand = "Local", rating = 4.8f, reviewCount = 55),
            Product(id = "27", name = "Pineapple", description = "Rich natural juice pineapple.", price = 280.0, originalPrice = 0.0, category = "fruits", imageUrl = "https://images.unsplash.com/photo-1550258987-190a2d41a8ba?q=80&w=400&auto=format&fit=crop", stock = 20, unit = "per piece", brand = "Local", rating = 4.5f, reviewCount = 38),
            Product(id = "28", name = "Avocado", description = "Ripe and buttery avocados.", price = 350.0, originalPrice = 0.0, category = "fruits", imageUrl = "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=400&auto=format&fit=crop", stock = 15, unit = "500g", brand = "Local", rating = 4.7f, reviewCount = 29),
            Product(id = "108", name = "Fresh Lemon", description = "Zesty fresh lemons.", price = 80.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_lemon", stock = 100, unit = "per piece", brand = "Local", rating = 4.6f, reviewCount = 42),
            Product(id = "109", name = "Fresh Oranges", description = "Sweet and juicy oranges.", price = 120.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_orange", stock = 80, unit = "500g", brand = "Local", rating = 4.7f, reviewCount = 56),
            Product(id = "54", name = "Watermelon", description = "Sweet hydrating watermelon.", price = 160.0, originalPrice = 0.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_watermelon", stock = 25, unit = "1 kg", brand = "Local", rating = 4.8f, reviewCount = 76),
            Product(id = "62", name = "Strawberries", description = "Fresh red strawberries.", price = 500.0, originalPrice = 0.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_strawberry", stock = 15, unit = "250g", brand = "Local", rating = 4.9f, reviewCount = 20),
            Product(id = "63", name = "Purple Grapes", description = "Seedless purple grapes.", price = 290.0, originalPrice = 0.0, category = "fruits", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_grapes", stock = 40, unit = "500g", brand = "Local", rating = 4.7f, reviewCount = 45),

            // Dairy
            Product(id = "8", name = "Full Cream Milk", description = "Premium full cream milk.", price = 1050.0, originalPrice = 0.0, category = "dairy", imageUrl = "https://images.unsplash.com/photo-1550583724-b2692b85b150?q=80&w=400&auto=format&fit=crop", stock = 40, unit = "1 L", brand = "Anchor", rating = 4.8f, reviewCount = 200),
            Product(id = "29", name = "Salted Butter", description = "Pure creamery salted butter.", price = 780.0, originalPrice = 0.0, category = "dairy", imageUrl = "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?q=80&w=400&auto=format&fit=crop", stock = 25, unit = "200g", brand = "Pelwatte", rating = 4.6f, reviewCount = 112),
            Product(id = "49", name = "Farm Fresh Eggs", description = "Large farm-fresh white eggs.", price = 45.0, originalPrice = 0.0, category = "dairy", imageUrl = "android.resource://com.example.lankasmartmart/drawable/dairy_eggs", stock = 200, unit = "per piece", brand = "Local", rating = 4.8f, reviewCount = 120),
            
            // Beverages
            Product(id = "10", name = "Ceylon Black Tea", description = "Pure Ceylon black tea.", price = 450.0, originalPrice = 0.0, category = "beverages", imageUrl = "https://images.unsplash.com/photo-1594631252845-29fc4dd8c1ed?q=80&w=400&auto=format&fit=crop", stock = 80, unit = "250g", brand = "Dilmah", rating = 4.9f, reviewCount = 250),
            Product(id = "11", name = "Mango Nectar", description = "Rich and thick mango juice.", price = 280.0, originalPrice = 320.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/fruit_mango", stock = 50, unit = "1 L", brand = "Kist", isOnSale = true, discount = 12, rating = 4.6f, reviewCount = 95),
            Product(id = "100", name = "Apple & Grape Juice", description = "Freshly squeezed juice blend.", price = 350.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bev_apple_grape", stock = 40, unit = "1 L", brand = "Kist", rating = 4.7f, reviewCount = 38),
            Product(id = "101", name = "Coca-Cola", description = "Classic refreshing cola.", price = 180.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bev_coke", stock = 120, unit = "330ml can", brand = "Coca-Cola", rating = 4.5f, reviewCount = 150),
            Product(id = "102", name = "Diet Coke", description = "Refreshing sugar-free cola.", price = 180.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bev_diet_coke", stock = 100, unit = "330ml can", brand = "Coca-Cola", rating = 4.4f, reviewCount = 85),
            Product(id = "103", name = "Pepsi", description = "Smooth refreshing cola.", price = 175.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bev_pepsi", stock = 100, unit = "330ml can", brand = "Pepsi", rating = 4.5f, reviewCount = 140),
            Product(id = "104", name = "Sprite", description = "Lemon-lime refreshing drink.", price = 170.0, category = "beverages", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bev_sprite", stock = 100, unit = "330ml can", brand = "Sprite", rating = 4.6f, reviewCount = 110),
            Product(id = "32", name = "Instant Coffee", description = "Morning boost instant coffee.", price = 650.0, originalPrice = 0.0, category = "beverages", imageUrl = "https://images.unsplash.com/photo-1559525839-b184a4d698c7?q=80&w=400&auto=format&fit=crop", stock = 40, unit = "50g", brand = "Nescafe", rating = 4.6f, reviewCount = 125),
            Product(id = "34", name = "Mineral Water", description = "Pure natural mineral water.", price = 120.0, originalPrice = 0.0, category = "beverages", imageUrl = "https://images.unsplash.com/photo-1548839140-29a749e1bc4e?q=80&w=400&auto=format&fit=crop", stock = 100, unit = "1.5 L", brand = "Springs", rating = 4.8f, reviewCount = 180),

            // Snacks
            Product(id = "12", name = "Crackers", description = "Classic crispy crackers.", price = 230.0, originalPrice = 0.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_crackers", stock = 120, unit = "190g", brand = "Munchee", rating = 4.5f, reviewCount = 180),
            Product(id = "37", name = "Milk Chocolate", description = "Creamy milk chocolate bar.", price = 280.0, originalPrice = 0.0, category = "snacks", imageUrl = "https://images.unsplash.com/photo-1548907040-4baa42d10919?q=80&w=400&auto=format&fit=crop", stock = 40, unit = "100g", brand = "Kandos", rating = 4.6f, reviewCount = 145),
            Product(id = "55", name = "Choco Biscuits", description = "Crunchy chocolate biscuits.", price = 130.0, originalPrice = 0.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_biscuits", stock = 80, unit = "100g", brand = "Munchee", rating = 4.7f, reviewCount = 112),
            Product(id = "110", name = "Chocolate Puff", description = "Light and airy chocolate snacks.", price = 150.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_choco_puff", stock = 60, unit = "80g", brand = "Munchee", rating = 4.8f, reviewCount = 45),
            Product(id = "111", name = "Choco Shock", description = "Explosion of chocolate flavor.", price = 180.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_choco_shock", stock = 50, unit = "100g", brand = "Kandos", rating = 4.7f, reviewCount = 32),
            Product(id = "112", name = "Milk Cream Biscuits", description = "Creamy sandwich biscuits.", price = 140.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_milk_biscuits", stock = 70, unit = "100g", brand = "Munchee", rating = 4.6f, reviewCount = 58),
            Product(id = "114", name = "Tiffin Biscuits", description = "Classic tea-time biscuits.", price = 120.0, category = "snacks", imageUrl = "android.resource://com.example.lankasmartmart/drawable/snack_tiffin", stock = 90, unit = "100g", brand = "Munchee", rating = 4.5f, reviewCount = 64),

            // Groceries (More)
            Product(id = "105", name = "Egg Noodles", description = "Fresh high-quality egg noodles.", price = 280.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/gro_egg_noodles", stock = 60, unit = "400g", brand = "Harischandra", rating = 4.7f, reviewCount = 85),
            Product(id = "106", name = "Instant Noodles", description = "Quick and tasty instant noodles.", price = 220.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/gro_noodles", stock = 100, unit = "350g", brand = "Maggi", rating = 4.6f, reviewCount = 120),
            Product(id = "113", name = "Mayonnaise", description = "Rich and creamy mayonnaise.", price = 550.0, category = "groceries", imageUrl = "android.resource://com.example.lankasmartmart/drawable/gro_mayo", stock = 40, unit = "250g", brand = "Heinz", rating = 4.8f, reviewCount = 45),
            Product(id = "107", name = "Fresh Ginger", description = "Strong aromatic fresh ginger.", price = 250.0, category = "vegetables", imageUrl = "android.resource://com.example.lankasmartmart/drawable/veg_ginger", stock = 50, unit = "250g", brand = "Local", rating = 4.7f, reviewCount = 34),

            // Personal Care
            Product(id = "14", name = "Beauty Soap", description = "Gentle soap for glowing skin.", price = 145.0, originalPrice = 0.0, category = "personal_care", imageUrl = "https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?q=80&w=400&auto=format&fit=crop", stock = 150, unit = "100g", brand = "Care", rating = 4.6f, reviewCount = 88),
            Product(id = "39", name = "Shampoo", description = "Smooth shampoo for silky hair.", price = 480.0, originalPrice = 0.0, category = "personal_care", imageUrl = "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=400&auto=format&fit=crop", stock = 50, unit = "180ml", brand = "Sunsilk", rating = 4.5f, reviewCount = 75),

            // Household
            Product(id = "16", name = "Dish Wash Liquid", description = "Lime fresh dish wash.", price = 280.0, originalPrice = 0.0, category = "household", imageUrl = "https://images.unsplash.com/photo-1584824388147-3be992cdeacc?q=80&w=400&auto=format&fit=crop", stock = 80, unit = "500ml", brand = "Sunlight", rating = 4.7f, reviewCount = 134),
            Product(id = "41", name = "Floor Cleaner", description = "Citrus fresh liquid cleaner.", price = 680.0, originalPrice = 0.0, category = "household", imageUrl = "https://images.unsplash.com/photo-1585834017772-df759d57a414?q=80&w=400&auto=format&fit=crop", stock = 30, unit = "500ml", brand = "Lysol", rating = 4.7f, reviewCount = 55),

            // Stationery
            Product(id = "18", name = "Notebook", description = "Standard 80-page exercise book.", price = 120.0, originalPrice = 0.0, category = "stationery", imageUrl = "https://images.unsplash.com/photo-1531346878377-38e946a6f3b0?q=80&w=400&auto=format&fit=crop", stock = 200, unit = "80 pgs", brand = "Atlas", rating = 4.8f, reviewCount = 45),
            Product(id = "19", name = "Pens Pack", description = "Pack of 5 ballpoint pens.", price = 150.0, originalPrice = 0.0, category = "stationery", imageUrl = "https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?q=80&w=400&auto=format&fit=crop", stock = 100, unit = "5 pack", brand = "Atlas", rating = 4.6f, reviewCount = 30),

            // Bakery & Meat
            Product(id = "64", name = "Sandwich Bread", description = "Freshly baked soft white bread.", price = 180.0, originalPrice = 0.0, category = "bakery", imageUrl = "android.resource://com.example.lankasmartmart/drawable/bakery_bread", stock = 30, unit = "450g", brand = "Local", rating = 4.8f, reviewCount = 95),
            Product(id = "65", name = "Fresh Chicken", description = "Cleaned whole chicken.", price = 1200.0, originalPrice = 0.0, category = "meat", imageUrl = "android.resource://com.example.lankasmartmart/drawable/meat_chicken", stock = 25, unit = "1 kg", brand = "Farm", rating = 4.7f, reviewCount = 68)
        )
    }
    
// =============================================
    // Cart Management Functions (Room-backed)
    // =============================================
    
    /**
     * Load cart items from Room database on startup.
     * Falls back to mock data if cart is empty (first launch).
     */
    private fun loadCartFromDatabase() {
        viewModelScope.launch {
            cartDao.getAllCartItems().collect { cartEntities ->
                if (cartEntities.isEmpty() && _cartItems.value.isEmpty()) {
                    // First launch — seed with mock data
                    loadMockCartData()
                } else {
                    // Rebuild CartItem objects from Room entities + loaded products
                    val products = _products.value
                    val cartItemList = cartEntities.mapNotNull { entity ->
                        val product = products.find { it.id == entity.productId }
                            ?: Product(
                                id = entity.productId,
                                name = entity.productName,
                                description = "", // Added missing required-ish or for consistency
                                price = entity.productPrice,
                                originalPrice = entity.originalPrice,
                                category = entity.category,
                                imageUrl = entity.productImageUrl,
                                stock = 0,
                                unit = entity.unit,
                                brand = entity.brand,
                                isOnSale = entity.isOnSale,
                                discount = entity.discount
                            )
                        com.example.lankasmartmart.model.CartItem(
                            product = product,
                            quantity = entity.quantity
                        )
                    }
                    _cartItems.value = cartItemList
                    updateCartCalculations()
                }
            }
        }
    }
    
    fun addToCart(product: Product, quantity: Int = 1) {
        val currentCart = _cartItems.value.toMutableList()
        val existingItem = currentCart.find { it.product.id == product.id }
        
        if (existingItem != null) {
            val index = currentCart.indexOf(existingItem)
            val newQty = existingItem.quantity + quantity
            currentCart[index] = existingItem.copy(quantity = newQty)
            // Update in Room
            viewModelScope.launch { cartDao.updateQuantity(product.id, newQty) }
        } else {
            currentCart.add(com.example.lankasmartmart.model.CartItem(product = product, quantity = quantity))
            // Insert into Room
            viewModelScope.launch {
                cartDao.insertCartItem(
                    CartItemEntity(
                        productId = product.id,
                        productName = product.name,
                        productPrice = product.price,
                        productImageUrl = product.imageUrl,
                        quantity = quantity,
                        category = product.category,
                        unit = product.unit,
                        brand = product.brand,
                        discount = product.discount,
                        isOnSale = product.isOnSale,
                        originalPrice = product.originalPrice
                    )
                )
            }
        }
        
        _cartItems.value = currentCart
        updateCartCalculations()
    }
    
    fun removeFromCart(productId: String) {
        _cartItems.value = _cartItems.value.filter { it.product.id != productId }
        viewModelScope.launch { cartDao.deleteCartItem(productId) }
        updateCartCalculations()
    }
    
    fun updateQuantity(productId: String, newQuantity: Int) {
        if (newQuantity < 1) {
            removeFromCart(productId)
            return
        }
        
        val currentCart = _cartItems.value.toMutableList()
        val itemIndex = currentCart.indexOfFirst { it.product.id == productId }
        
        if (itemIndex != -1) {
            currentCart[itemIndex] = currentCart[itemIndex].copy(quantity = newQuantity)
            _cartItems.value = currentCart
            viewModelScope.launch { cartDao.updateQuantity(productId, newQuantity) }
            updateCartCalculations()
        }
    }
    
    fun clearCart() {
        _cartItems.value = emptyList()
        viewModelScope.launch { cartDao.clearCart() }
        updateCartCalculations()
    }
    
    private fun updateCartCalculations() {
        val subtotal = _cartItems.value.sumOf { it.product.discountedPrice * it.quantity }
        val delivery = if (subtotal >= 2000.0 || _cartItems.value.isEmpty()) 0.0 else 150.0
        val total = subtotal + delivery
        
        (cartItemCount as MutableStateFlow).value = _cartItems.value.sumOf { it.quantity }
        (cartSubtotal as MutableStateFlow).value = subtotal
        (deliveryFee as MutableStateFlow).value = delivery
        (cartTotal as MutableStateFlow).value = total
    }
    
    // Load mock cart data for testing (first launch only)
    private fun loadMockCartData() {
        val mockProducts = getMockProducts()
        val mockCartItems = listOf(
            com.example.lankasmartmart.model.CartItem(
                product = mockProducts.first { it.id == "1" },
                quantity = 2
            ),
            com.example.lankasmartmart.model.CartItem(
                product = mockProducts.first { it.id == "8" },
                quantity = 1
            ),
            com.example.lankasmartmart.model.CartItem(
                product = mockProducts.first { it.id == "12" },
                quantity = 3
            )
        )
        _cartItems.value = mockCartItems
        updateCartCalculations()
        
        // Persist mock items to Room
        viewModelScope.launch {
            mockCartItems.forEach { item ->
                cartDao.insertCartItem(
                    CartItemEntity(
                        productId = item.product.id,
                        productName = item.product.name,
                        productPrice = item.product.price,
                        productImageUrl = item.product.imageUrl,
                        quantity = item.quantity,
                        category = item.product.category,
                        unit = item.product.unit,
                        brand = item.product.brand,
                        discount = item.product.discount,
                        isOnSale = item.product.isOnSale,
                        originalPrice = item.product.originalPrice
                    )
                )
            }
        }
    }
    
    // =============================================
    // Search Functions (with Room history)
    // =============================================
    
    fun updateSearchQuery(query: String) {
        _searchQuery.value = query
        performSearch(query)
    }
    
    /**
     * Save a search query to Room history (call when user submits a search)
     */
    fun saveSearchQuery(query: String) {
        if (query.isBlank()) return
        viewModelScope.launch {
            searchHistoryDao.insertQuery(SearchHistoryEntity(query = query.trim()))
        }
    }
    
    fun clearSearchHistory() {
        viewModelScope.launch {
            searchHistoryDao.clearHistory()
        }
    }
    
    private fun performSearch(query: String) {
        if (query.isBlank()) {
            _searchResults.value = _products.value
        } else {
            _searchResults.value = _products.value.filter { product ->
                product.name.contains(query, ignoreCase = true) ||
                product.brand.contains(query, ignoreCase = true) ||
                product.description.contains(query, ignoreCase = true)
            }
        }
    }
    
    fun clearSearch() {
        _searchQuery.value = ""
        _searchResults.value = _products.value
    }
    
    // Product Review Functions
    fun addProductReview(productId: String, rating: Int, comment: String) {
        val currentProducts = _products.value.toMutableList()
        val productIndex = currentProducts.indexOfFirst { it.id == productId }
        
        if (productIndex != -1) {
            val product = currentProducts[productIndex]
            val newReview = com.example.lankasmartmart.model.Review(
                id = java.util.UUID.randomUUID().toString(),
                userId = "user_123",
                userName = "Kaveesha", // For demo purposes
                rating = rating,
                comment = comment
            )
            val updatedReviews = product.reviews + newReview
            val newTotalReviews = product.reviewCount + 1
            // Simple new average calculation
            val newRating = (product.rating * product.reviewCount + rating) / newTotalReviews
            
            currentProducts[productIndex] = product.copy(
                reviews = updatedReviews,
                reviewCount = newTotalReviews,
                rating = String.format("%.1f", newRating).toFloat()
            )
            _products.value = currentProducts
            
            // Refresh search results to reflect updated product data
            performSearch(_searchQuery.value)
        }
    }
}
