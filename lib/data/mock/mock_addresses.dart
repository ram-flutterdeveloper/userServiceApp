import 'package:user_servicehub/data/models/address_model.dart';

final List<AddressModel> mockAddresses = [
  const AddressModel(
    id: 'ADR001',
    type: 'Home',
    fullAddress: '42, Chandni Chowk, Old Delhi, Near Fatehpuri Masjid',
    city: 'Delhi',
    pincode: '110006',
    isDefault: true,
    lat: 28.6611,
    lng: 77.2287,
  ),
  const AddressModel(
    id: 'ADR002',
    type: 'Work',
    fullAddress: 'B-201, Sector 62, Noida, Opp. Fortis Hospital',
    city: 'Noida',
    pincode: '201309',
    isDefault: false,
    lat: 28.6203,
    lng: 77.3699,
  ),
  const AddressModel(
    id: 'ADR003',
    type: 'Other',
    fullAddress: 'D-45, DLF Phase 2, Gurugram, Near Galleria Market',
    city: 'Gurugram',
    pincode: '122002',
    isDefault: false,
    lat: 28.4833,
    lng: 77.0937,
  ),
];
