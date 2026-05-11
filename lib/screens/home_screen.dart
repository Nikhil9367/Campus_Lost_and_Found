// lib/screens/home_screen.dart
// Home feed: Lost / Found tabs, search, category filter, grid of items.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../utils/categories.dart';
import '../utils/theme.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';
import 'profile_screen.dart';
import 'report_item_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>();
    final auth = context.watch<AuthProvider>();
    final categories = ['All', ...kCategories];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Rescue',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.deepIndigo,
        onPressed: () {
          if (!auth.isAuthenticated) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportItemScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Report', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status toggle
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _StatusToggle(
                value: items.statusFilter,
                onChanged: items.setStatus,
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: items.setQuery,
                decoration: const InputDecoration(
                  hintText: 'Search by name, category, location…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Category chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = categories[i];
                  final selected = items.category == c;
                  return ChoiceChip(
                    label: Text(c),
                    selected: selected,
                    onSelected: (_) => items.setCategory(c),
                    selectedColor: AppColors.deepIndigo,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.deepIndigo,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.slateLight),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Grid
            Expanded(
              child: items.visibleItems.isEmpty
                  ? const _EmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: items.visibleItems.length,
                      itemBuilder: (_, i) {
                        final item = items.visibleItems[i];
                        return ItemCard(
                          item: item,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ItemDetailScreen(item: item),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final ItemStatus value;
  final ValueChanged<ItemStatus> onChanged;
  const _StatusToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slateLight),
      ),
      child: Row(
        children: ItemStatus.values.map((s) {
          final selected = s == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      selected ? AppColors.deepIndigo : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    s == ItemStatus.lost ? 'Lost' : 'Found',
                    style: TextStyle(
                      color:
                          selected ? Colors.white : AppColors.deepIndigo,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 72, color: AppColors.slate),
          const SizedBox(height: 12),
          Text('No items yet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('Tap "Report" to add the first one.',
              style: TextStyle(color: AppColors.slate)),
        ],
      ),
    );
  }
}
