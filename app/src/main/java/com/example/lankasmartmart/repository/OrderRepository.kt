package com.example.lankasmartmart.repository

import com.example.lankasmartmart.model.Order
import com.example.lankasmartmart.model.OrderItem
import com.example.lankasmartmart.utils.MockDataStore
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import kotlinx.coroutines.tasks.await

class OrderRepository {
    private val db = FirebaseFirestore.getInstance()
    private val auth = FirebaseAuth.getInstance()
    
    private fun getUserId(): String {
        return auth.currentUser?.uid ?: "mock_user_id"
    }
    
    suspend fun createOrder(order: Order): String? {
        val userId = getUserId()
        val orderId = if (auth.currentUser != null) db.collection("orders").document().id 
                      else "mock_order_${System.currentTimeMillis()}"
        
        val orderWithDetails = order.copy(
            id = orderId,
            userId = userId,
            createdAt = System.currentTimeMillis(),
            updatedAt = System.currentTimeMillis()
        )
        
        if (auth.currentUser == null) {
            MockDataStore.orders.add(orderWithDetails)
            return orderId
        }

        return try {
            db.collection("orders")
                .document(orderId)
                .set(orderWithDetails)
                .await()
            
            orderId
        } catch (e: Exception) {
            // Fallback
            MockDataStore.orders.add(orderWithDetails)
            orderId
        }
    }
    
    suspend fun getOrders(): List<Order> {
        val userId = getUserId()
        
        if (auth.currentUser == null) {
            return MockDataStore.orders.filter { it.userId == userId }
                .sortedByDescending { it.createdAt }
        }

        return try {
            val snapshot = db.collection("orders")
                .whereEqualTo("userId", userId)
                .orderBy("createdAt", Query.Direction.DESCENDING)
                .get()
                .await()
            
            snapshot.documents.mapNotNull { it.toObject(Order::class.java) }
        } catch (e: Exception) {
            MockDataStore.orders.filter { it.userId == userId }
                .sortedByDescending { it.createdAt }
        }
    }
    
    suspend fun getOrder(orderId: String): Order? {
        if (auth.currentUser == null) {
            return MockDataStore.orders.find { it.id == orderId }
        }

        return try {
            val snapshot = db.collection("orders")
                .document(orderId)
                .get()
                .await()
            
            snapshot.toObject(Order::class.java) ?: MockDataStore.orders.find { it.id == orderId }
        } catch (e: Exception) {
            MockDataStore.orders.find { it.id == orderId }
        }
    }
    
    suspend fun updateOrderStatus(orderId: String, status: String): Boolean {
        if (auth.currentUser == null) {
            val index = MockDataStore.orders.indexOfFirst { it.id == orderId }
            if (index != -1) {
                MockDataStore.orders[index] = MockDataStore.orders[index].copy(
                    status = status,
                    updatedAt = System.currentTimeMillis()
                )
            }
            return true
        }

        return try {
            db.collection("orders")
                .document(orderId)
                .update(
                    mapOf(
                        "status" to status,
                        "updatedAt" to System.currentTimeMillis()
                    )
                )
                .await()
            
            true
        } catch (e: Exception) {
            val index = MockDataStore.orders.indexOfFirst { it.id == orderId }
            if (index != -1) {
                MockDataStore.orders[index] = MockDataStore.orders[index].copy(
                    status = status,
                    updatedAt = System.currentTimeMillis()
                )
            }
            true
        }
    }
    
    suspend fun cancelOrder(orderId: String): Boolean {
        return updateOrderStatus(orderId, "cancelled")
    }
}
