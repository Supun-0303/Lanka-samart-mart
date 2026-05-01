package com.example.lankasmartmart.utils

import com.example.lankasmartmart.model.Address
import com.example.lankasmartmart.model.PaymentCard
import com.example.lankasmartmart.model.Order

/**
 * A singleton store to hold mock data during the application session.
 * This is used when Firebase Authentication or Firestore is unavailable.
 */
object MockDataStore {
    val addresses = mutableListOf<Address>()
    val cards = mutableListOf<PaymentCard>()
    val orders = mutableListOf<Order>()

    // Initialize with some default mock data if needed
    init {
        // Optional: Add a sample address for easier testing
        /*
        addresses.add(Address(
            id = "mock_addr_1",
            userId = "mock_user_id",
            name = "Home",
            addressLine1 = "123 Main St, Colombo",
            city = "Colombo",
            isDefault = true
        ))
        */
    }
}
