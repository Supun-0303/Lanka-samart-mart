package com.example.lankasmartmart.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.SmartToy
import androidx.compose.material.icons.filled.Storefront
import androidx.compose.material.icons.filled.LocalShipping
import androidx.compose.material.icons.filled.Payment
import androidx.compose.material.icons.filled.ReceiptLong
import androidx.compose.material.icons.filled.Restore
import androidx.compose.material3.AssistChip
import androidx.compose.material3.AssistChipDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.lankasmartmart.model.Product
import com.example.lankasmartmart.viewmodel.ShopViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

private data class ChatMessage(
    val id: Int,
    val text: String,
    val isUser: Boolean,
    val suggestions: List<Product> = emptyList()
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatAssistantScreen(
    shopViewModel: ShopViewModel = viewModel(),
    onBackClick: () -> Unit = {},
    onProductClick: (Product) -> Unit = {}
) {
    val products by shopViewModel.products.collectAsState()
    val listState = rememberLazyListState()
    val scope = rememberCoroutineScope()
    var inputText by rememberSaveable { mutableStateOf("") }
    val messages = remember {
        mutableStateListOf(
            ChatMessage(
                id = 1,
                text = "Hi, I’m your Lanka SmartMart AI assistant. Ask me about products, delivery, returns, payment methods, or say something like 'show me rice' or 'track my order'.",
                isUser = false
            )
        )
    }

    LaunchedEffect(messages.size) {
        if (messages.isNotEmpty()) {
            listState.animateScrollToItem(messages.lastIndex)
        }
    }

    Scaffold(
        containerColor = Color(0xFFF8FFFE),
        topBar = {
            TopAppBar(
                title = {
                    Column {
                        Text(
                            text = "AI Assistant",
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                        Text(
                            text = "Shopping help, instantly",
                            fontSize = 12.sp,
                            color = Color.White.copy(alpha = 0.85f)
                        )
                    }
                },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color.White
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    navigationIconContentColor = Color.White,
                    titleContentColor = Color.White,
                    actionIconContentColor = Color.White
                )
            )
        },
        bottomBar = {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color.White)
                    .padding(horizontal = 16.dp, vertical = 12.dp)
            ) {
                QuickPromptRow(
                    onPromptClick = { prompt ->
                        inputText = prompt
                    }
                )
                Spacer(modifier = Modifier.height(10.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.Bottom,
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    OutlinedTextField(
                        value = inputText,
                        onValueChange = { inputText = it },
                        modifier = Modifier.weight(1f),
                        placeholder = { Text("Ask SmartMart AI...") },
                        shape = RoundedCornerShape(16.dp),
                        singleLine = false,
                        maxLines = 3
                    )
                    Surface(
                        shape = RoundedCornerShape(16.dp),
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier
                            .height(56.dp)
                            .width(56.dp)
                            .clickable {
                                val trimmed = inputText.trim()
                                if (trimmed.isNotEmpty()) {
                                    sendMessage(
                                        text = trimmed,
                                        products = products,
                                        messages = messages,
                                        scope = scope
                                    )
                                    inputText = ""
                                }
                            }
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            Icon(
                                imageVector = Icons.Default.Send,
                                contentDescription = "Send",
                                tint = Color.White
                            )
                        }
                    }
                }
            }
        }
    ) { paddingValues ->
        LazyColumn(
            state = listState,
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                AssistantIntroCard()
            }

            items(messages, key = { it.id }) { message ->
                ChatBubble(
                    message = message,
                    onProductClick = onProductClick
                )
            }
        }
    }
}

@Composable
private fun AssistantIntroCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            Surface(
                shape = RoundedCornerShape(18.dp),
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier.size(54.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        imageVector = Icons.Default.SmartToy,
                        contentDescription = null,
                        tint = Color.White
                    )
                }
            }
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = "Try asking:",
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "'show me dairy products' • 'what is your return policy?' • 'track my order'",
                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.8f),
                    fontSize = 13.sp
                )
            }
        }
    }
}

@Composable
private fun QuickPromptRow(onPromptClick: (String) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            AssistChip(
                onClick = { onPromptClick("Track my order") },
                label = { Text("Track order") },
                leadingIcon = { Icon(Icons.Default.ReceiptLong, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
            AssistChip(
                onClick = { onPromptClick("What are your delivery times?") },
                label = { Text("Delivery") },
                leadingIcon = { Icon(Icons.Default.LocalShipping, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            AssistChip(
                onClick = { onPromptClick("What payment methods do you support?") },
                label = { Text("Payments") },
                leadingIcon = { Icon(Icons.Default.Payment, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
            AssistChip(
                onClick = { onPromptClick("Show me groceries") },
                label = { Text("Groceries") },
                leadingIcon = { Icon(Icons.Default.Storefront, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            AssistChip(
                onClick = { onPromptClick("What is your return policy?") },
                label = { Text("Returns") },
                leadingIcon = { Icon(Icons.Default.Restore, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
            AssistChip(
                onClick = { onPromptClick("Recommend me snacks") },
                label = { Text("Snacks") },
                leadingIcon = { Icon(Icons.Default.Chat, contentDescription = null, modifier = Modifier.size(18.dp)) },
                colors = AssistChipDefaults.assistChipColors(containerColor = Color(0xFFF1F7FF))
            )
        }
    }
}

@Composable
private fun ChatBubble(
    message: ChatMessage,
    onProductClick: (Product) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (message.isUser) Arrangement.End else Arrangement.Start
    ) {
        Column(
            horizontalAlignment = if (message.isUser) Alignment.End else Alignment.Start,
            modifier = Modifier.fillMaxWidth(0.88f)
        ) {
            Surface(
                shape = RoundedCornerShape(20.dp),
                color = if (message.isUser) MaterialTheme.colorScheme.primary else Color.White,
                tonalElevation = 2.dp,
                shadowElevation = 2.dp
            ) {
                Text(
                    text = message.text,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp),
                    color = if (message.isUser) Color.White else Color(0xFF1F2937),
                    fontSize = 14.sp,
                    lineHeight = 20.sp
                )
            }

            if (message.suggestions.isNotEmpty()) {
                Spacer(modifier = Modifier.height(8.dp))
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        text = "Suggested products",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF6B7280)
                    )
                    message.suggestions.forEach { product ->
                        ProductSuggestionChip(
                            product = product,
                            onClick = { onProductClick(product) }
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun ProductSuggestionChip(
    product: Product,
    onClick: () -> Unit
) {
    Surface(
        shape = RoundedCornerShape(16.dp),
        color = Color.White,
        tonalElevation = 1.dp,
        shadowElevation = 1.dp,
        modifier = Modifier.clickable(onClick = onClick)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Surface(
                shape = RoundedCornerShape(12.dp),
                color = MaterialTheme.colorScheme.primaryContainer,
                modifier = Modifier.size(36.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Icon(
                        imageVector = Icons.Default.Storefront,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(18.dp)
                    )
                }
            }
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = product.name,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium,
                    color = Color(0xFF111827)
                )
                Text(
                    text = "LKR ${product.discountedPrice.toInt()} • ${product.unit}",
                    fontSize = 12.sp,
                    color = Color(0xFF6B7280)
                )
            }
            TextButton(onClick = onClick) {
                Text("Open")
            }
        }
    }
}

private fun sendMessage(
    text: String,
    products: List<Product>,
    messages: MutableList<ChatMessage>,
    scope: CoroutineScope
) {
    val userMessageId = (messages.maxOfOrNull { it.id } ?: 0) + 1
    messages.add(
        ChatMessage(
            id = userMessageId,
            text = text,
            isUser = true
        )
    )

    scope.launch {
        delay(350)
        val botReply = buildAssistantReply(text, products)
        messages.add(
            ChatMessage(
                id = userMessageId + 1,
                text = botReply.text,
                isUser = false,
                suggestions = botReply.suggestions
            )
        )
    }
}

private data class AssistantReply(
    val text: String,
    val suggestions: List<Product> = emptyList()
)

private fun buildAssistantReply(query: String, products: List<Product>): AssistantReply {
    val normalized = query.trim().lowercase()

    if (normalized.isBlank()) {
        return AssistantReply(
            text = "Type a question and I’ll help with orders, delivery, returns, payments, or product recommendations."
        )
    }

    val greetingKeywords = listOf("hello", "hi", "hey", "good morning", "good afternoon")
    if (greetingKeywords.any { normalized.contains(it) }) {
        return AssistantReply(
            text = "Hello! I can help you find products, explain delivery times, check returns, or point you to order tracking."
        )
    }

    if (normalized.contains("track") || normalized.contains("order status") || normalized.contains("where is my order") || normalized.contains("order")) {
        return AssistantReply(
            text = "You can track orders from Profile > Track Order. If you share your order ID, I can also remind you of the next step."
        )
    }

    if (normalized.contains("delivery") || normalized.contains("shipping") || normalized.contains("when will it arrive")) {
        return AssistantReply(
            text = "Delivery usually takes 1-3 business days inside Colombo and 3-5 days for outstation areas. Express delivery may be available depending on your area."
        )
    }

    if (normalized.contains("return") || normalized.contains("refund") || normalized.contains("cancel")) {
        return AssistantReply(
            text = "Returns are accepted within 7 days if the item is unused and in original packaging. Orders can usually be cancelled within 1 hour of placing them."
        )
    }

    if (normalized.contains("payment") || normalized.contains("card") || normalized.contains("cash") || normalized.contains("bank")) {
        return AssistantReply(
            text = "Supported payment options include Cash on Delivery, card payment, and online banking. If you need help choosing one, I can explain each option."
        )
    }

    val suggestions = findProductSuggestions(normalized, products)
    if (suggestions.isNotEmpty()) {
        return AssistantReply(
            text = "I found a few products that match your request. Tap one to open the product page.",
            suggestions = suggestions
        )
    }

    return AssistantReply(
        text = "I can help with products, delivery, returns, payments, and order tracking. Try asking for a category like 'show me dairy' or a product type like 'recommend me snacks'."
    )
}

private fun findProductSuggestions(query: String, products: List<Product>): List<Product> {
    val tokens = query.split(" ", ",", ".", "?", "!", "-")
        .map { it.trim() }
        .filter { it.isNotBlank() }

    val prioritized = products
        .map { product ->
            val haystack = listOf(product.name, product.brand, product.category, product.description)
                .joinToString(" ")
                .lowercase()

            val score = buildList {
                if (haystack.contains(query)) add(5)
                tokens.forEach { token ->
                    if (token.length >= 3 && haystack.contains(token)) add(1)
                }
                if (query.contains(product.category.lowercase())) add(2)
                if (query.contains(product.name.lowercase())) add(3)
            }.sum()

            product to score
        }
        .filter { it.second > 0 }
        .sortedByDescending { it.second }
        .map { it.first }
        .distinctBy { it.id }

    return prioritized.take(3)
}
