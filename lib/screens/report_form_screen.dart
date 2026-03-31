import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

const _categories = ['Electronics', 'Bags', 'Documents', 'Clothing', 'Keys', 'Accessories', 'Books', 'Other'];

class ReportFormScreen extends StatefulWidget {
  final String type; // 'Lost' or 'Found'
  const ReportFormScreen({super.key, required this.type});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _phone = TextEditingController();
  final _desc = TextEditingController();
  String? _selectedCategory;
  File? _imageFile;
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.lightImpact();
    try {
      final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
      if (picked != null) setState(() => _imageFile = File(picked.path));
    } catch (_) {}
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Upload Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _PickerOption(icon: Icons.camera_alt_rounded, label: 'Camera', onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
            _PickerOption(icon: Icons.photo_library_rounded, label: 'Gallery', onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ]),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Future<void> _submit() async {
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Please select a category'), backgroundColor: kError, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      context.read<AppState>().addItem(
        title: _title.text.trim(), category: _selectedCategory!,
        location: _location.text.trim(), phone: _phone.text.trim(),
        description: _desc.text.trim(), type: widget.type, imageFile: _imageFile,
      );
      _title.clear(); _location.clear(); _phone.clear(); _desc.clear();
      setState(() { _loading = false; _selectedCategory = null; _imageFile = null; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${widget.type} item reported! ✅'),
        backgroundColor: kSuccess, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLost = widget.type == 'Lost';
    final color = isLost ? kPrimary : kAccent;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: glassDecoration(color: color.withOpacity(0.08)),
                child: Row(children: [
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                    child: Icon(isLost ? Icons.search_off_rounded : Icons.inventory_2_rounded, color: color, size: 28)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Report ${widget.type} Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                    Text(isLost ? 'Fill in the details about your lost item' : 'Help someone recover their item', style: const TextStyle(fontSize: 13, color: kTextMedium)),
                  ])),
                ]),
              ),
              const SizedBox(height: 24),
              // Image Picker
              GestureDetector(
                onTap: _showImageOptions,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3), width: 2, style: BorderStyle.solid),
                  ),
                  child: _imageFile != null
                      ? Stack(children: [
                          ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(_imageFile!, width: double.infinity, height: 160, fit: BoxFit.cover)),
                          Positioned(top: 8, right: 8, child: GestureDetector(
                            onTap: () { HapticFeedback.lightImpact(); setState(() => _imageFile = null); },
                            child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: kError, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 16)),
                          )),
                        ])
                      : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.add_a_photo_outlined, size: 40, color: color.withOpacity(0.6)),
                          const SizedBox(height: 10),
                          Text('Tap to add a photo', style: TextStyle(color: color.withOpacity(0.7), fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          const Text('Camera or Gallery', style: TextStyle(color: kTextMedium, fontSize: 12)),
                        ]),
                ),
              ),
              const SizedBox(height: 20),
              _label('Item Title'),
              TextFormField(controller: _title, decoration: InputDecoration(hintText: 'e.g. Blue Backpack', prefixIcon: Icon(Icons.label_outline, color: color)), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _label('Category'),
              Wrap(spacing: 8, runSpacing: 8,
                children: _categories.map((cat) => ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (v) { HapticFeedback.selectionClick(); if (v) setState(() => _selectedCategory = cat); },
                  selectedColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(color: _selectedCategory == cat ? color : kTextMedium, fontWeight: FontWeight.w600, fontSize: 12),
                  side: BorderSide(color: _selectedCategory == cat ? color : Colors.grey.shade200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                )).toList(),
              ),
              const SizedBox(height: 16),
              _label('Location'),
              TextFormField(controller: _location, decoration: InputDecoration(hintText: 'e.g. Library, Block B', prefixIcon: Icon(Icons.location_on_outlined, color: color)), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _label('Contact Phone'),
              TextFormField(
                controller: _phone, keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '9876543210',
                  prefixIcon: Icon(Icons.phone_outlined, color: color),
                  prefixText: '+91  ', prefixStyle: const TextStyle(color: kTextDark, fontWeight: FontWeight.w600),
                ),
                validator: (v) => v!.length < 10 ? 'Enter valid phone number' : null,
              ),
              const SizedBox(height: 16),
              _label('Description'),
              TextFormField(controller: _desc, maxLines: 3, decoration: InputDecoration(hintText: 'Describe the item in detail...', prefixIcon: Icon(Icons.notes_rounded, color: color)), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  icon: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.check_circle_outline),
                  label: Text(_loading ? 'Submitting...' : 'Submit Report'),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
        if (_loading) Container(color: Colors.black12, child: const Center(child: CircularProgressIndicator(color: kPrimary))),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextDark)),
  );
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PickerOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: kSecondary, borderRadius: BorderRadius.circular(20)),
          child: Icon(icon, size: 32, color: kAccent)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
