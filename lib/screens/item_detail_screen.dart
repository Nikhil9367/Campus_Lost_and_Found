// lib/screens/item_detail_screen.dart
// Detail page with Contact Owner (Email + WhatsApp) deep links.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/item_model.dart';
import '../utils/theme.dart';

class ItemDetailScreen extends StatelessWidget {
  final ItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  Future<void> _email(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: item.ownerEmail,
      query:
          'subject=Campus Rescue: ${Uri.encodeComponent(item.title)}&body=${Uri.encodeComponent("Hi ${item.ownerName},\n\nI'm reaching out about your '${item.title}' post on Campus Rescue.")}',
    );
    final launched = await launchUrl(uri);
    if (!context.mounted) return;
    if (!launched) {
      _toast(context, 'Could not open email app');
    }
  }

  Future<void> _whatsapp(BuildContext context) async {
    final phone = item.ownerPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) {
      _toast(context, 'No phone number on file');
      return;
    }
    final msg =
        "Hi ${item.ownerName}, I'm contacting you about your '${item.title}' post on Campus Rescue.";
    final uri = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(msg)}');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!launched) {
      _toast(context, 'Could not open WhatsApp');
    }
  }

  void _toast(BuildContext context, String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  @override
  Widget build(BuildContext context) {
    final isLost = item.status == ItemStatus.lost;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.deepIndigo,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.imagePath.isNotEmpty &&
                      File(item.imagePath).existsSync())
                    Image.file(File(item.imagePath), fit: BoxFit.cover)
                  else
                    Container(
                      decoration: const BoxDecoration(gradient: kAuthGradient),
                      child: const Icon(Icons.image_outlined,
                          size: 96, color: Colors.white54),
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLost ? Colors.redAccent : Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isLost ? 'LOST' : 'FOUND',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(item.category,
                          style: const TextStyle(
                              color: AppColors.slate,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.slate),
                      const SizedBox(width: 4),
                      Text(item.location,
                          style: const TextStyle(color: AppColors.slate)),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today,
                          size: 14, color: AppColors.slate),
                      const SizedBox(width: 4),
                      Text(DateFormat.yMMMd().format(item.date),
                          style: const TextStyle(color: AppColors.slate)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Description',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(item.description,
                      style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 24),

                  // Owner card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.slateLight),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.deepIndigo,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.ownerName.isEmpty
                                  ? 'Anonymous'
                                  : item.ownerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              Text(item.ownerEmail,
                                  style: const TextStyle(
                                      color: AppColors.slate, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _email(context),
                          icon: const Icon(Icons.email_outlined),
                          label: const Text('Email'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                          ),
                          onPressed: () => _whatsapp(context),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('WhatsApp'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
