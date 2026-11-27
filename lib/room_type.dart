import 'package:flutter/material.dart';

enum RoomPreference { single, double, family }

class RoomType {
  RoomType({
    required this.preference,
    required this.name,
    required this.icon,
    required this.description,
    required this.price,
    this.isExpanded = false,
  });

  final RoomPreference preference;
  final String name;
  final IconData icon;
  final String description;
  final int price;
  bool isExpanded;
}

List<RoomType> buildRooms(RoomPreference preferred) {
  return [
    RoomType(
      preference: RoomPreference.single,
      name: 'Single Room',
      icon: Icons.single_bed,
      description: 'One guest, one single bed. RM 120 per night.',
      price: 120,
      isExpanded: preferred == RoomPreference.single,
    ),
    RoomType(
      preference: RoomPreference.double,
      name: 'Double Room',
      icon: Icons.king_bed,
      description: 'Two guests, one double bed. RM 180 per night.',
      price: 180,
      isExpanded: preferred == RoomPreference.double,
    ),
    RoomType(
      preference: RoomPreference.family,
      name: 'Family Room',
      icon: Icons.family_restroom,
      description: 'Four guests, two beds, living area. RM 260 per night.',
      price: 260,
      isExpanded: preferred == RoomPreference.family,
    ),
  ];
}
