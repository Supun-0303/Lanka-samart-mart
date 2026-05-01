package com.example.lankasmartmart.data.local.dao

import androidx.room.*
import com.example.lankasmartmart.data.local.entity.AddressEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface AddressDao {
    @Query("SELECT * FROM saved_addresses WHERE userId = :userId ORDER BY createdAt DESC")
    fun getAddressesByUserId(userId: String): Flow<List<AddressEntity>>

    @Query("SELECT * FROM saved_addresses WHERE userId = :userId ORDER BY createdAt DESC")
    suspend fun getAddressesByUserIdSync(userId: String): List<AddressEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAddress(address: AddressEntity)

    @Update
    suspend fun updateAddress(address: AddressEntity)

    @Query("DELETE FROM saved_addresses WHERE id = :addressId")
    suspend fun deleteAddress(addressId: String)

    @Query("UPDATE saved_addresses SET isDefault = 0 WHERE userId = :userId")
    suspend fun clearDefaultStatus(userId: String)

    @Query("UPDATE saved_addresses SET isDefault = 1 WHERE id = :addressId")
    suspend fun setDefaultAddress(addressId: String)
}
