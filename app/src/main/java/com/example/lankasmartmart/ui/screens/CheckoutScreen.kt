package com.example.lankasmartmart.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.ArrowForward
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.example.lankasmartmart.model.Address
import com.example.lankasmartmart.ui.theme.GroceryTextDark
import com.example.lankasmartmart.ui.theme.GroceryTextGrey
import com.example.lankasmartmart.viewmodel.AddressViewModel
import com.example.lankasmartmart.viewmodel.ShopViewModel

// Redesign Colors based on screenshot
private val PremiumMint = Color(0xFF8DE8C7)
private val DarkBackground = Color(0xFF121212)
private val SelectedGreen = Color(0xFF003820)
private val CardWhite = Color(0xFFFFFFFF)
private val ForestGreen = Color(0xFF002415)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CheckoutScreen(
    onBackClick: () -> Unit = {},
    onAddAddressClick: () -> Unit = {},
    onProceedToPayment: (Address) -> Unit = {},
    addressViewModel: AddressViewModel = viewModel(),
    shopViewModel: ShopViewModel = viewModel()
) {
    val addresses by addressViewModel.addresses.collectAsState()
    val selectedAddress by addressViewModel.selectedAddress.collectAsState()
    val cartItems by shopViewModel.cartItems.collectAsState()
    val isLoading by addressViewModel.isLoading.collectAsState()
    
    // Calculate total
    val subtotal = remember(cartItems) {
        cartItems.sumOf { it.totalPrice }
    }
    val deliveryFee = 0.0
    val totalAmount = subtotal + deliveryFee
    
    LaunchedEffect(Unit) {
        addressViewModel.loadAddresses()
    }
    
    Scaffold(
        containerColor = DarkBackground,
        topBar = {
            TopAppBar(
                title = { 
                    Text(
                        text = "Checkout",
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    ) 
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, "Back", tint = Color.White)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = PremiumMint,
                    titleContentColor = Color.White,
                    navigationIconContentColor = Color.White
                )
            )
        }
    ) { paddingValues ->
        Box(modifier = Modifier.fillMaxSize().padding(paddingValues)) {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 16.dp),
                contentPadding = PaddingValues(top = 16.dp, bottom = 100.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // Address Section Header
                item {
                    Spacer(modifier = Modifier.height(4.dp))
                }
                
                if (isLoading) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(150.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CircularProgressIndicator(color = PremiumMint)
                        }
                    }
                } else if (addresses.isEmpty()) {
                    item {
                        Card(
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(20.dp),
                            colors = CardDefaults.cardColors(containerColor = ForestGreen)
                        ) {
                            Column(
                                modifier = Modifier.padding(24.dp),
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Default.LocationOn,
                                    contentDescription = null,
                                    tint = PremiumMint,
                                    modifier = Modifier.size(48.dp)
                                )
                                Spacer(modifier = Modifier.height(12.dp))
                                Text(
                                    "No delivery address found", 
                                    fontWeight = FontWeight.Bold,
                                    color = Color.White
                                )
                                Text(
                                    "Please add a delivery address to proceed", 
                                    fontSize = 14.sp, 
                                    color = Color.LightGray,
                                    textAlign = TextAlign.Center
                                )
                                Spacer(modifier = Modifier.height(20.dp))
                                Button(
                                    onClick = onAddAddressClick,
                                    colors = ButtonDefaults.buttonColors(containerColor = PremiumMint),
                                    shape = RoundedCornerShape(12.dp)
                                ) {
                                    Icon(Icons.Default.Add, contentDescription = null, tint = Color.Black)
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text("Add Address", color = Color.Black, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }
                } else {
                    items(addresses) { address ->
                        AddressSelectionCard(
                            address = address,
                            isSelected = address.id == selectedAddress?.id,
                            onSelect = {
                                addressViewModel.selectAddress(address)
                            }
                        )
                    }
                    
                    item {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable { onAddAddressClick() }
                                .padding(vertical = 8.dp),
                            horizontalArrangement = Arrangement.Center,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(Icons.Default.Add, contentDescription = null, tint = PremiumMint, modifier = Modifier.size(20.dp))
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(
                                "Add New Address", 
                                color = PremiumMint,
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 16.sp
                            )
                        }
                    }
                }
                
                // Order Summary Header
                item {
                    Text(
                        text = "Order Summary",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF424242) // Dark grey for header text
                    )
                }
                
                items(cartItems) { cartItem ->
                    OrderItemCard(cartItem)
                }
                
                // Price Details Card
                item {
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(20.dp),
                        colors = CardDefaults.cardColors(containerColor = CardWhite),
                        elevation = CardDefaults.cardElevation(2.dp)
                    ) {
                        Column(
                            modifier = Modifier.padding(20.dp),
                            verticalArrangement = Arrangement.spacedBy(12.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Subtotal", color = Color.LightGray, fontSize = 16.sp)
                                Text("Rs. %.2f".format(subtotal), color = Color.LightGray, fontSize = 16.sp)
                            }
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Delivery Fee", color = Color.LightGray, fontSize = 16.sp)
                                Text("Rs. %.2f".format(deliveryFee), color = PremiumMint, fontSize = 16.sp)
                            }
                            
                            HorizontalDivider(modifier = Modifier.padding(vertical = 4.dp), color = Color.Black)
                            
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    "Total",
                                    fontSize = 18.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color.Black
                                )
                                Text(
                                    "Rs. %.2f".format(totalAmount),
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = PremiumMint
                                )
                            }
                        }
                    }
                }
                
                item { Spacer(modifier = Modifier.height(16.dp)) }
            }
            
            // Bottom Sticky Button
            Box(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .background(DarkBackground)
                    .padding(16.dp)
            ) {
                Button(
                    onClick = {
                        addressViewModel.selectedAddress.value?.let { onProceedToPayment(it) }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = PremiumMint,
                        disabledContainerColor = PremiumMint.copy(alpha = 0.5f)
                    ),
                    shape = RoundedCornerShape(30.dp),
                    enabled = selectedAddress != null && cartItems.isNotEmpty()
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.Center
                    ) {
                        Text(
                            "Proceed to Payment",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                        Spacer(modifier = Modifier.width(12.dp))
                        Icon(Icons.AutoMirrored.Filled.ArrowForward, contentDescription = null, tint = Color.Black)
                    }
                }
            }
        }
    }
}

@Composable
fun AddressSelectionCard(
    address: Address,
    isSelected: Boolean,
    onSelect: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(20.dp))
            .clickable { onSelect() }
            .then(
                if (isSelected) Modifier.border(2.dp, PremiumMint, RoundedCornerShape(20.dp))
                else Modifier
            ),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) SelectedGreen else ForestGreen
        ),
        elevation = CardDefaults.cardElevation(if (isSelected) 8.dp else 2.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            verticalAlignment = Alignment.Top
        ) {
            // Radio Indicator
            Box(
                modifier = Modifier
                    .size(24.dp)
                    .padding(top = 4.dp)
                    .clip(CircleShape)
                    .background(if (isSelected) PremiumMint else Color.Transparent)
                    .border(2.dp, PremiumMint, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                if (isSelected) {
                    Box(
                        modifier = Modifier
                            .size(10.dp)
                            .clip(CircleShape)
                            .background(SelectedGreen)
                    )
                }
            }
            
            Spacer(modifier = Modifier.width(16.dp))
            
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = address.name.lowercase(),
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = if (isSelected) Color.White else PremiumMint
                    )
                    if (address.isDefault) {
                        Spacer(modifier = Modifier.width(12.dp))
                        Surface(
                            shape = RoundedCornerShape(6.dp),
                            color = PremiumMint.copy(alpha = 0.8f)
                        ) {
                            Text(
                                text = "Default",
                                fontSize = 11.sp,
                                fontWeight = FontWeight.SemiBold,
                                color = SelectedGreen,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                            )
                        }
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "${address.addressLine1}${if (address.addressLine2.isNotEmpty()) ", ${address.addressLine2}" else ""}",
                    fontSize = 14.sp,
                    color = Color.LightGray,
                    lineHeight = 20.sp
                )
                Text(
                    text = address.city,
                    fontSize = 14.sp,
                    color = Color.LightGray
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "Phone: ${address.phone}",
                    fontSize = 14.sp,
                    color = Color.LightGray,
                    fontWeight = FontWeight.Medium
                )
            }
        }
    }
}

@Composable
fun OrderItemCard(cartItem: com.example.lankasmartmart.model.CartItem) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = CardWhite),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Product image
            Surface(
                modifier = Modifier
                    .size(64.dp)
                    .clip(RoundedCornerShape(12.dp)),
                color = Color(0xFFF0F0F0)
            ) {
                AsyncImage(
                    model = cartItem.product.imageUrl,
                    contentDescription = cartItem.product.name,
                    modifier = Modifier.fillMaxSize(),
                    contentScale = androidx.compose.ui.layout.ContentScale.Crop
                )
            }
            
            Spacer(modifier = Modifier.width(16.dp))
            
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = cartItem.product.name,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color.Black
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "Qty: ${cartItem.quantity}",
                    fontSize = 13.sp,
                    color = PremiumMint,
                    fontWeight = FontWeight.Medium
                )
            }
            
            Text(
                text = "Rs. %.2f".format(cartItem.totalPrice),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = PremiumMint
            )
        }
    }
}
