package com.example.lankasmartmart.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "saved_addresses")
data class AddressEntity(
    @PrimaryKey
    val id: String,
    val userId: String,
    val name: String,
    val phone: String,
    val addressLine1: String,
    val addressLine2: String,
    val city: String,
    val postalCode: String,
    val latitude: Double,
    val longitude: Double,
    val isDefault: Boolean,
    val createdAt: Long = System.currentTimeMillis()
)
