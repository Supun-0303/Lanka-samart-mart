package com.example.lankasmartmart.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.ColorPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.example.lankasmartmart.R
import com.example.lankasmartmart.model.Order
import com.example.lankasmartmart.model.OrderItem
import com.example.lankasmartmart.viewmodel.OrderViewModel
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.*

// Redesign Colors based on previous screen
private val PremiumMint = Color(0xFF8DE8C7)
private val DarkBackground = Color(0xFF121212)
private val ForestGreen = Color(0xFF002415)
private val CardWhite = Color(0xFFFFFFFF)

@Composable
fun OrderConfirmationScreen(
    orderId: String,
    onGoToHome: () -> Unit = {},
    onTrackOrder: () -> Unit = {},
    orderViewModel: OrderViewModel = viewModel()
) {
    val currentOrder by orderViewModel.currentOrder.collectAsState()
    val isLoading by orderViewModel.isLoading.collectAsState()
    val scrollState = rememberScrollState()

    LaunchedEffect(orderId) {
        orderViewModel.loadOrder(orderId)
    }

    Scaffold(
        containerColor = DarkBackground
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(scrollState)
                    .padding(horizontal = 24.dp, vertical = 16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(30.dp))

                // Premium Success Header with Mint Glow
                Box(
                    modifier = Modifier
                        .size(140.dp)
                        .background(
                            color = PremiumMint.copy(alpha = 0.15f),
                            shape = CircleShape
                        )
                        .border(1.dp, PremiumMint.copy(alpha = 0.3f), CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Box(
                        modifier = Modifier
                            .size(100.dp)
                            .background(PremiumMint, CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Check,
                            contentDescription = null,
                            tint = DarkBackground,
                            modifier = Modifier.size(56.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(32.dp))

                // Title
                Text(
                    text = "Order Accepted!",
                    fontSize = 28.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Color.White,
                    textAlign = TextAlign.Center
                )

                Spacer(modifier = Modifier.height(12.dp))

                // Subtitle with Order ID
                Text(
                    text = "Your order #$orderId has been placed successfully and is being processed.",
                    fontSize = 15.sp,
                    color = Color.LightGray,
                    textAlign = TextAlign.Center,
                    lineHeight = 22.sp
                )

                Spacer(modifier = Modifier.height(40.dp))

                // Ordered Items Section
                if (currentOrder != null && currentOrder!!.items.isNotEmpty()) {
                    Text(
                        text = "Your Items",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = PremiumMint,
                        modifier = Modifier.fillMaxWidth(),
                        textAlign = TextAlign.Start
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    LazyRow(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        items(currentOrder!!.items) { item ->
                            ConfirmedItemCard(item)
                        }
                    }
                    Spacer(modifier = Modifier.height(32.dp))
                }

                // Map Section (Delivery Location)
                Text(
                    text = "Delivery Location",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = PremiumMint,
                    modifier = Modifier.fillMaxWidth(),
                    textAlign = TextAlign.Start
                )

                Spacer(modifier = Modifier.height(16.dp))

                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(180.dp)
                        .clip(RoundedCornerShape(20.dp))
                        .border(1.dp, PremiumMint.copy(alpha = 0.5f), RoundedCornerShape(20.dp)),
                    shape = RoundedCornerShape(20.dp),
                    elevation = CardDefaults.cardElevation(8.dp)
                ) {
                    Box(modifier = Modifier.fillMaxSize()) {
                        if (currentOrder != null && currentOrder?.deliveryAddress != null) {
                            val deliveryLatLng = LatLng(
                                currentOrder?.deliveryAddress?.latitude ?: 6.9271,
                                currentOrder?.deliveryAddress?.longitude ?: 79.8612
                            )
                            val cameraPositionState = rememberCameraPositionState {
                                position = CameraPosition.fromLatLngZoom(deliveryLatLng, 15f)
                            }

                            GoogleMap(
                                modifier = Modifier.fillMaxSize(),
                                cameraPositionState = cameraPositionState,
                                uiSettings = MapUiSettings(
                                    zoomControlsEnabled = false,
                                    myLocationButtonEnabled = false
                                )
                            ) {
                                Marker(
                                    state = MarkerState(position = deliveryLatLng),
                                    title = "Delivery Point"
                                )
                            }
                        } else if (isLoading) {
                            Box(
                                modifier = Modifier.fillMaxSize().background(ForestGreen),
                                contentAlignment = Alignment.Center
                            ) {
                                CircularProgressIndicator(color = PremiumMint)
                            }
                        } else {
                            Box(
                                modifier = Modifier.fillMaxSize().background(ForestGreen),
                                contentAlignment = Alignment.Center
                            ) {
                                Text("Location data unavailable", color = PremiumMint)
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                // Order Summary Card
                currentOrder?.let { order ->
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(24.dp),
                        colors = CardDefaults.cardColors(containerColor = CardWhite),
                        elevation = CardDefaults.cardElevation(4.dp)
                    ) {
                        Column(
                            modifier = Modifier.padding(20.dp),
                            verticalArrangement = Arrangement.spacedBy(16.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text("Total Amount", color = Color.Gray, fontSize = 16.sp)
                                Text(
                                    "LKR ${String.format("%.2f", order.totalAmount)}",
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.ExtraBold,
                                    color = PremiumMint
                                )
                            }
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Payment Status", color = Color.Gray, fontSize = 16.sp)
                                Text(
                                    "Confirmed",
                                    fontWeight = FontWeight.Bold,
                                    color = Color(0xFF4CAF50)
                                )
                            }
                            
                            HorizontalDivider(color = Color.LightGray.copy(alpha = 0.3f))
                            
                            Row(
                                verticalAlignment = Alignment.Top
                            ) {
                                Icon(
                                    imageVector = Icons.Default.LocationOn,
                                    contentDescription = null,
                                    tint = PremiumMint,
                                    modifier = Modifier.size(24.dp).padding(top = 2.dp)
                                )
                                Spacer(modifier = Modifier.width(12.dp))
                                Column {
                                    Text(
                                        text = order.deliveryAddress?.name ?: "Delivery Address",
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 16.sp,
                                        color = Color.Black
                                    )
                                    Text(
                                        text = order.deliveryAddress?.addressLine1 ?: "Address not found",
                                        fontSize = 14.sp,
                                        color = Color.Gray
                                    )
                                }
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(140.dp)) // Extra space for buttons
            }

            // Fixed Bottom Action Area
            Box(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .background(DarkBackground)
                    .padding(24.dp)
            ) {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Button(
                        onClick = onTrackOrder,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp),
                        shape = RoundedCornerShape(30.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = PremiumMint
                        )
                    ) {
                        Text(
                            text = "Track Order",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.ExtraBold,
                            color = DarkBackground
                        )
                    }

                    OutlinedButton(
                        onClick = onGoToHome,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp),
                        shape = RoundedCornerShape(30.dp),
                        border = BorderStroke(2.dp, PremiumMint)
                    ) {
                        Text(
                            text = "Back to home",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = PremiumMint
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun ConfirmedItemCard(item: OrderItem) {
    Card(
        modifier = Modifier
            .width(140.dp)
            .height(180.dp),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = ForestGreen),
        elevation = CardDefaults.cardElevation(2.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Surface(
                modifier = Modifier
                    .size(70.dp)
                    .clip(RoundedCornerShape(15.dp)),
                color = PremiumMint.copy(alpha = 0.1f)
            ) {
                AsyncImage(
                    model = item.imageUrl,
                    contentDescription = item.productName,
                    modifier = Modifier.fillMaxSize(),
                    contentScale = ContentScale.Crop,
                    error = ColorPainter(PremiumMint.copy(alpha = 0.2f))
                )
            }
            
            Spacer(modifier = Modifier.height(12.dp))
            
            Text(
                text = item.productName,
                fontSize = 13.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White,
                textAlign = TextAlign.Center,
                maxLines = 1,
                overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
            )
            
            Text(
                text = "Qty: ${item.quantity}",
                fontSize = 12.sp,
                color = PremiumMint,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}

