package com.example.lankasmartmart.utils

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Geocoder
import android.location.Location
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import kotlinx.coroutines.tasks.await
import java.util.*

class LocationHelper(private val context: Context) {
    private val fusedLocationClient: FusedLocationProviderClient =
        LocationServices.getFusedLocationProviderClient(context)

    @android.annotation.SuppressLint("MissingPermission")
    suspend fun getCurrentCity(): String {
        return try {
            if (!hasLocationPermission()) {
                return "Sri Lanka" // Default if no permission
            }

            // Try to get fresh location first
            val location = try {
                fusedLocationClient.lastLocation.await()
            } catch (e: Exception) {
                null
            }
            
            if (location != null) {
                val city = getCityFromCoordinates(location.latitude, location.longitude)
                println("📍 Location detected: ${location.latitude}, ${location.longitude} -> $city")
                city
            } else {
                println("📍 No location available, using default")
                "Sri Lanka" // Default if location unavailable
            }
        } catch (e: Exception) {
            println("📍 Location error: ${e.message}")
            "Sri Lanka" // Default on error
        }
    }

    @Suppress("DEPRECATION")
    private fun getCityFromCoordinates(latitude: Double, longitude: Double): String {
        // FIRST try manual mapping (more accurate for Sri Lankan cities)
        val manualCity = getSriLankanCityFromCoordinates(latitude, longitude)
        
        // If manual mapping found a specific city, use it
        if (manualCity != "Sri Lanka") {
            println("📍 Manual mapping: $manualCity for ($latitude, $longitude)")
            return manualCity
        }
        
        // Otherwise try Geocoder as fallback
        return try {
            val geocoder = Geocoder(context, Locale.getDefault())
            val addresses = geocoder.getFromLocation(latitude, longitude, 1)
            
            if (addresses != null && addresses.isNotEmpty()) {
                val locality = addresses[0].locality
                val subLocality = addresses[0].subAdminArea
                
                println("📍 Geocoder found: locality=$locality, subLocality=$subLocality")
                
                // Return the most specific location available
                when {
                    !locality.isNullOrEmpty() -> locality
                    !subLocality.isNullOrEmpty() -> subLocality
                    else -> "Sri Lanka"
                }
            } else {
                "Sri Lanka"
            }
        } catch (e: Exception) {
            println("📍 Geocoder error: ${e.message}")
            "Sri Lanka"
        }
    }

    // Manually map coordinates to Sri Lankan cities
    private fun getSriLankanCityFromCoordinates(lat: Double, lon: Double): String {
        println("📍 Checking coordinates: lat=$lat, lon=$lon")
        
        return when {
            // Hanwella area (6.9061° N, 80.0842° E) - CHECK THIS FIRST
            (lat in 6.87..6.95 && lon in 80.05..80.20) -> {
                println("📍 ✅ Hanwella detected!")
                "Hanwella"
            }
            
            // Colombo area (6.9271° N, 79.8612° E)
            (lat in 6.85..7.00 && lon in 79.80..79.92) -> "Colombo"
            
            // Kandy area (7.2906° N, 80.6337° E)
            (lat in 7.20..7.40 && lon in 80.55..80.70) -> "Kandy"
            
            // Galle area (6.0535° N, 80.2210° E)
            (lat in 5.95..6.15 && lon in 80.15..80.30) -> "Galle"
            
            // Negombo area (7.2083° N, 79.8358° E)
            (lat in 7.15..7.25 && lon in 79.80..79.90) -> "Negombo"
            
            // Gampaha area (7.0911° N, 80.0164° E)
            (lat in 7.00..7.15 && lon in 79.95..80.10) -> "Gampaha"
            
            // Kurunegala area (7.4863° N, 80.3647° E)
            (lat in 7.40..7.55 && lon in 80.30..80.45) -> "Kurunegala"
            
            // Matara area (5.9549° N, 80.5550° E)
            (lat in 5.90..6.00 && lon in 80.50..80.60) -> "Matara"
            
            // Jaffna area (9.6615° N, 80.0255° E)
            (lat in 9.60..9.75 && lon in 79.95..80.10) -> "Jaffna"
            
            // Anuradhapura area (8.3114° N, 80.4037° E)
            (lat in 8.25..8.40 && lon in 80.35..80.50) -> "Anuradhapura"
            
            else -> "Colombo" // Default
        }
    }

    private fun hasLocationPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }
}

// Extension function to extract clean name (only letters and spaces)
fun String.extractName(): String {
    return this.split(" ")
        .filter { word ->
            word.all { char -> char.isLetter() || char.isWhitespace() }
        }
        .joinToString(" ")
        .trim()
}
