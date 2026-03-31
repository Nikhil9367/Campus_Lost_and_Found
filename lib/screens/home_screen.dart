import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import 'history_screen.dart';
import 'report_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = const [
      HistoryScreen(type: 'Lost'),
      HistoryScreen(type: 'Found'),
      ReportFormScreen(type: 'Lost'),
      ReportFormScreen(type: 'Found'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;
    return PopScope(
      canPop: _idx != 0,
      onPopInvoked: (didPop) {
        if (!didPop && _idx != 0) setState(() => _idx = 0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text('Campus Rescue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kPrimary)),
            Text('Hello, ${user?.username ?? 'Guest'} 👋', style: const TextStyle(fontSize: 12, color: kTextMedium, fontWeight: FontWeight.w400)),
          ]),
          actions: [
            IconButton(
              icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: kSecondary, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.logout_rounded, size: 20, color: kAccent)),
              onPressed: () { HapticFeedback.lightImpact(); context.read<AppState>().logout(); },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(index: _idx, children: _tabs),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.manage_search_rounded, 'label': 'Lost History'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Found History'},
      {'icon': Icons.report_problem_rounded, 'label': 'Report Lost'},
      {'icon': Icons.add_location_alt_rounded, 'label': 'Report Found'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 20, offset: const Offset(0, -4))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = _idx == i;
              final label = items[i]['label'] as String;
              final icon = items[i]['icon'] as IconData;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _idx = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon, color: isActive ? Colors.white : kTextMedium, size: 22),
                    if (isActive) ...[
                      const SizedBox(width: 6),
                      Text(label.split(' ').last, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
