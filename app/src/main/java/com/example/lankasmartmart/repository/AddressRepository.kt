package com.example.lankasmartmart.repository

import com.example.lankasmartmart.data.local.dao.AddressDao
import com.example.lankasmartmart.data.local.entity.AddressEntity
import com.example.lankasmartmart.model.Address
import com.example.lankasmartmart.utils.MockDataStore
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.tasks.await

class AddressRepository(private val addressDao: AddressDao? = null) {
    private val db = FirebaseFirestore.getInstance()
    private val auth = FirebaseAuth.getInstance()
    
    private fun getUserId(): String {
        return auth.currentUser?.uid ?: "mock_user_id"
    }
    
    // Mapping functions
    private fun Address.toEntity(): AddressEntity = AddressEntity(
        id = id,
        userId = userId,
        name = name,
        phone = phone,
        addressLine1 = addressLine1,
        addressLine2 = addressLine2,
        city = city,
        postalCode = postalCode,
        latitude = latitude,
        longitude = longitude,
        isDefault = isDefault,
        createdAt = createdAt
    )

    private fun AddressEntity.toModel(): Address = Address(
        id = id,
        userId = userId,
        name = name,
        phone = phone,
        addressLine1 = addressLine1,
        addressLine2 = addressLine2,
        city = city,
        postalCode = postalCode,
        latitude = latitude,
        longitude = longitude,
        isDefault = isDefault,
        createdAt = createdAt
    )

    suspend fun getAddresses(): List<Address> {
        val userId = getUserId()
        
        // If not using real Firebase, use local Room data or mock data
        if (auth.currentUser == null) {
            val localAddresses = addressDao?.getAddressesByUserIdSync(userId)
            if (!localAddresses.isNullOrEmpty()) {
                return localAddresses.map { it.toModel() }
            }
            return MockDataStore.addresses.filter { it.userId == userId }
        }

        return try {
            val snapshot = db.collection("addresses")
                .whereEqualTo("userId", userId)
                .get()
                .await()
            
            val remoteAddresses = snapshot.documents.mapNotNull { it.toObject(Address::class.java) }
            
            // Sync to local Room if available
            remoteAddresses.forEach { addr ->
                addressDao?.insertAddress(addr.toEntity())
            }
            
            remoteAddresses
        } catch (e: Exception) {
            // Fallback for Firestore errors
            val localAddresses = addressDao?.getAddressesByUserIdSync(userId)
            if (!localAddresses.isNullOrEmpty()) {
                return localAddresses.map { it.toModel() }
            }
            MockDataStore.addresses.filter { it.userId == userId }
        }
    }
    
    suspend fun addAddress(address: Address): Boolean {
        val userId = getUserId()
        val addressId = address.id.ifBlank { 
            if (auth.currentUser != null) db.collection("addresses").document().id 
            else "mock_addr_${System.currentTimeMillis()}"
        }
        
        val addressWithUser = address.copy(
            id = addressId,
            userId = userId
        )
        
        // Save to Local Room if available
        addressDao?.insertAddress(addressWithUser.toEntity())
        
        if (auth.currentUser == null) {
            MockDataStore.addresses.add(addressWithUser)
            return true
        }

        return try {
            db.collection("addresses")
                .document(addressWithUser.id)
                .set(addressWithUser)
                .await()
            true
        } catch (e: Exception) {
            // Fallback for Firestore errors
            MockDataStore.addresses.add(addressWithUser)
            true
        }
    }
    
    suspend fun updateAddress(address: Address): Boolean {
        // Save to Local Room if available
        addressDao?.updateAddress(address.toEntity())

        if (auth.currentUser == null) {
            val index = MockDataStore.addresses.indexOfFirst { it.id == address.id }
            if (index != -1) {
                MockDataStore.addresses[index] = address
            }
            return true
        }

        return try {
            db.collection("addresses")
                .document(address.id)
                .set(address)
                .await()
            true
        } catch (e: Exception) {
            val index = MockDataStore.addresses.indexOfFirst { it.id == address.id }
            if (index != -1) {
                MockDataStore.addresses[index] = address
            }
            true
        }
    }
    
    suspend fun deleteAddress(addressId: String): Boolean {
        // Delete from Local Room if available
        addressDao?.deleteAddress(addressId)

        if (auth.currentUser == null) {
            MockDataStore.addresses.removeIf { it.id == addressId }
            return true
        }

        return try {
            db.collection("addresses")
                .document(addressId)
                .delete()
                .await()
            true
        } catch (e: Exception) {
            MockDataStore.addresses.removeIf { it.id == addressId }
            true
        }
    }
    
    suspend fun setDefaultAddress(addressId: String): Boolean {
        val userId = getUserId()

        // Local processing
        addressDao?.clearDefaultStatus(userId)
        addressDao?.setDefaultAddress(addressId)

        // Firebase / Mock syncing
        val addresses = getAddresses()
        addresses.forEach { address ->
            if (address.isDefault && address.id != addressId) {
                updateAddress(address.copy(isDefault = false))
            }
        }
        
        addresses.find { it.id == addressId }?.let { address ->
            updateAddress(address.copy(isDefault = true))
        }
        
        return true
    }
    
    suspend fun getDefaultAddress(): Address? {
        return getAddresses().find { it.isDefault }
    }
}
