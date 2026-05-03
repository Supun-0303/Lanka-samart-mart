import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/user_models.dart';
import '../theme/app_theme.dart';
import '../providers/address_provider.dart';
import 'map_address_picker_screen.dart';

class AddNewAddressScreen extends ConsumerStatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  ConsumerState<AddNewAddressScreen> createState() =>
      _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends ConsumerState<AddNewAddressScreen> {
  late TextEditingController nameController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController cityController;
  late TextEditingController postalCodeController;
  late TextEditingController phoneController;

  bool isDefault = false;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressLine1Controller = TextEditingController();
    addressLine2Controller = TextEditingController();
    cityController = TextEditingController();
    postalCodeController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF7FAF7),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 72,
          elevation: 6,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          title: const Text(
            'Add New Address',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF0FFF5), Color(0xFFE5F8FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.place_outlined,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Choose a clear delivery spot and save it with the map.',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: selectedLocation ??
                                const LatLng(6.9271, 80.7789),
                            zoom: selectedLocation != null ? 16 : 12,
                          ),
                          markers: selectedLocation != null
                              ? {
                                  Marker(
                                    markerId:
                                        const MarkerId('selected-address'),
                                    position: selectedLocation!,
                                    infoWindow: const InfoWindow(
                                      title: 'Selected address',
                                    ),
                                  ),
                                }
                              : {},
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                          onTap: (position) {
                            setState(() {
                              selectedLocation = position;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final pickedLocation = await Navigator.push<LatLng>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MapAddressPickerScreen(),
                            ),
                          );
                          if (pickedLocation != null) {
                            setState(() {
                              selectedLocation = pickedLocation;
                            });
                          }
                        },
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Pick location on map'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(
                controller: nameController,
                label: 'Address Label',
                hint: 'e.g., Home, Office',
              ),
              _buildTextField(
                controller: addressLine1Controller,
                label: 'Street Address',
                hint: 'Street name and number',
              ),
              _buildTextField(
                controller: addressLine2Controller,
                label: 'Additional Info',
                hint: 'Apartment, unit, etc.',
              ),
              _buildTextField(controller: cityController, label: 'City'),
              _buildTextField(
                controller: postalCodeController,
                label: 'Postal Code',
              ),
              _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                hint: '+94 123 456 789',
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(color: AppColors.borderGrey),
                ),
                child: CheckboxListTile(
                  activeColor: AppColors.primaryGreen,
                  title: const Text('Set as default address'),
                  subtitle: const Text('Use this location first at checkout'),
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saveAddress,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Address'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      );

  void _saveAddress() {
    if (nameController.text.isEmpty ||
        addressLine1Controller.text.isEmpty ||
        cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final address = Address(
      id: DateTime.now().toString(),
      userId: 'guest-user',
      name: nameController.text,
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: cityController.text,
      postalCode: postalCodeController.text,
      phone: phoneController.text,
      latitude: selectedLocation?.latitude ?? 0,
      longitude: selectedLocation?.longitude ?? 0,
      isDefault: isDefault,
    );

    ref.read(addressProvider.notifier).addAddress(address);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
