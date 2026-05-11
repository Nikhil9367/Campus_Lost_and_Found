// lib/providers/item_provider.dart
// Manages the list of Lost/Found items with local persistence.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  static const _kItemsKey = 'cr_items';
  final _uuid = const Uuid();

  final List<ItemModel> _items = [];
  String _query = '';
  String _category = 'All';
  ItemStatus _statusFilter = ItemStatus.lost;

  List<ItemModel> get allItems => List.unmodifiable(_items);
  String get query => _query;
  String get category => _category;
  ItemStatus get statusFilter => _statusFilter;

  /// Items filtered by status + search + category.
  List<ItemModel> get visibleItems {
    return _items.where((i) {
      if (i.status != _statusFilter) return false;
      if (_category != 'All' && i.category != _category) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return i.title.toLowerCase().contains(q) ||
          i.category.toLowerCase().contains(q) ||
          i.location.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<ItemModel> itemsByOwner(String email) =>
      _items.where((i) => i.ownerEmail == email).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  // ---- Filters ----
  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void setCategory(String c) {
    _category = c;
    notifyListeners();
  }

  void setStatus(ItemStatus s) {
    _statusFilter = s;
    notifyListeners();
  }

  // ---- Persistence ----
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kItemsKey) ?? [];
    _items
      ..clear()
      ..addAll(raw.map(ItemModel.fromJson));
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _kItemsKey, _items.map((i) => i.toJson()).toList());
  }

  // ---- CRUD ----
  Future<void> addItem({
    required String title,
    required String description,
    required String category,
    required String location,
    required String imagePath,
    required ItemStatus status,
    required String ownerEmail,
    required String ownerName,
    required String ownerPhone,
  }) async {
    final item = ItemModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      category: category,
      location: location,
      imagePath: imagePath,
      status: status,
      date: DateTime.now(),
      ownerEmail: ownerEmail,
      ownerName: ownerName,
      ownerPhone: ownerPhone,
    );
    _items.add(item);
    await _persist();
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    await _persist();
    notifyListeners();
  }
}
