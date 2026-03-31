import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import '../theme.dart';

class HistoryScreen extends StatelessWidget {
  final String type; // 'Lost' or 'Found'
  const HistoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final items = type == 'Lost' ? context.watch<AppState>().lostItems : context.watch<AppState>().foundItems;
    final isLost = type == 'Lost';
    final accentColor = isLost ? kPrimary : kAccent;

    if (items.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: accentColor.withAlpha(25), shape: BoxShape.circle),
            child: Icon(isLost ? Icons.manage_search_rounded : Icons.inventory_2_rounded, size: 56, color: accentColor.withAlpha(127))),
          const SizedBox(height: 20),
          Text('No ${type.toLowerCase()} items yet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kTextDark)),
          const SizedBox(height: 8),
          Text('Use the tab below to report a ${type.toLowerCase()} item', style: const TextStyle(color: kTextMedium)),
        ]),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _HistoryCard(item: items[i], accentColor: accentColor),
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ItemModel item;
  final Color accentColor;
  const _HistoryCard({required this.item, required this.accentColor});

  String _relativeTime() {
    final diff = DateTime.now().difference(item.date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(item.date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<AppState>().cycleStatus(item.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status → ${item.status.label}'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: item.status.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: glassDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image section
          if (item.imageFile != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.file(item.imageFile!, width: double.infinity, height: 180, fit: BoxFit.cover),
            )
          else
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(height: 80, color: accentColor.withAlpha(20),
                child: Center(child: Icon(Icons.image_not_supported_outlined, color: accentColor.withAlpha(76), size: 36))),
            ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: item.status.color.withAlpha(38), borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 5), decoration: BoxDecoration(color: item.status.color, shape: BoxShape.circle)),
                    Text(item.status.label, style: TextStyle(color: item.status.color, fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
                Text(_relativeTime(), style: const TextStyle(color: kTextMedium, fontSize: 12)),
              ]),
              const SizedBox(height: 10),
              Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kTextDark)),
              const SizedBox(height: 4),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: accentColor.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                  child: Text(item.category, style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 12),
              _infoRow(Icons.location_on_outlined, item.location),
              const SizedBox(height: 6),
              _infoRow(Icons.phone_outlined, '+91 ${item.phone}'),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kTextMedium, fontSize: 13, height: 1.5)),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: accentColor.withAlpha(13), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.touch_app_outlined, size: 14, color: accentColor),
                  const SizedBox(width: 6),
                  Text('Tap to cycle status', style: TextStyle(fontSize: 12, color: accentColor, fontWeight: FontWeight.w600)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 15, color: kTextMedium),
      const SizedBox(width: 6),
      Expanded(child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kTextMedium, fontSize: 13, fontWeight: FontWeight.w500))),
    ]);
  }
}
