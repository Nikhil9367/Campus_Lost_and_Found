// lib/models/item_model.dart
// Data model for a Lost or Found item.

import 'dart:convert';

enum ItemStatus { lost, found }

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String imagePath; // local file path (image_picker)
  final ItemStatus status;
  final DateTime date;
  final String ownerEmail;
  final String ownerName;
  final String ownerPhone; // for WhatsApp link

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.imagePath,
    required this.status,
    required this.date,
    required this.ownerEmail,
    required this.ownerName,
    required this.ownerPhone,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'imagePath': imagePath,
        'status': status.name,
        'date': date.toIso8601String(),
        'ownerEmail': ownerEmail,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
      };

  factory ItemModel.fromMap(Map<String, dynamic> map) => ItemModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        location: map['location'] as String,
        imagePath: map['imagePath'] as String? ?? '',
        status: ItemStatus.values.firstWhere(
          (s) => s.name == map['status'],
          orElse: () => ItemStatus.lost,
        ),
        date: DateTime.parse(map['date'] as String),
        ownerEmail: map['ownerEmail'] as String? ?? '',
        ownerName: map['ownerName'] as String? ?? '',
        ownerPhone: map['ownerPhone'] as String? ?? '',
      );

  String toJson() => jsonEncode(toMap());
  factory ItemModel.fromJson(String s) =>
      ItemModel.fromMap(jsonDecode(s) as Map<String, dynamic>);
}
