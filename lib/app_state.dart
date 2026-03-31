import 'dart:io';
import 'package:flutter/material.dart';

enum ItemStatus { searching, recovered, handedOver }

extension ItemStatusExt on ItemStatus {
  String get label {
    switch (this) { case ItemStatus.searching: return 'Searching'; case ItemStatus.recovered: return 'Recovered'; case ItemStatus.handedOver: return 'Handed Over'; }
  }
  Color get color {
    switch (this) { case ItemStatus.searching: return const Color(0xFFF39C12); case ItemStatus.recovered: return const Color(0xFF2ECC71); case ItemStatus.handedOver: return const Color(0xFF006D77); }
  }
}

class ItemModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String phone;
  final String description;
  final String type; // 'Lost' or 'Found'
  ItemStatus status;
  final DateTime date;
  final File? imageFile;

  ItemModel({
    required this.id, required this.title, required this.category,
    required this.location, required this.phone, required this.description,
    required this.type, this.status = ItemStatus.searching,
    required this.date, this.imageFile,
  });
}

class UserModel {
  final String username;
  final String email;
  final String phone;
  UserModel({required this.username, required this.email, required this.phone});
}

class AppState extends ChangeNotifier {
  UserModel? _user;
  final List<ItemModel> _items = [];

  bool get isLoggedIn => _user != null;
  UserModel? get user => _user;
  List<ItemModel> get lostItems => _items.where((i) => i.type == 'Lost').toList().reversed.toList();
  List<ItemModel> get foundItems => _items.where((i) => i.type == 'Found').toList().reversed.toList();

  bool login(String email, String password) {
    if (email.isNotEmpty && password.length >= 6) {
      _user = UserModel(username: email.split('@').first, email: email, phone: '');
      notifyListeners();
      return true;
    }
    return false;
  }

  bool register(String username, String email, String phone, String password) {
    if (username.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && password.length >= 6) {
      _user = UserModel(username: username, email: email, phone: phone);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() { _user = null; notifyListeners(); }

  void addItem({
    required String title, required String category, required String location,
    required String phone, required String description, required String type, File? imageFile,
  }) {
    _items.add(ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, category: category, location: location,
      phone: phone, description: description, type: type,
      date: DateTime.now(), imageFile: imageFile,
    ));
    notifyListeners();
  }

  void cycleStatus(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    final values = ItemStatus.values;
    item.status = values[(values.indexOf(item.status) + 1) % values.length];
    notifyListeners();
  }
}
