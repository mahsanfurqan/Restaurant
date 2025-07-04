import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/dummy_data/dummy_menu.dart';

class DetailMenu extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onEditSuccess;
  const DetailMenu({Key? key, required this.menu, this.onEditSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(menu.imageUrl),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                menu.name == 'menuNasiGoreng'
                    ? AppLocalizations.menuNasiGoreng()
                    : menu.name == 'menuMatcha'
                        ? AppLocalizations.menuMatcha()
                        : menu.name,
                style: AppFonts.lgBold,
              ),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.green, width: 1.5),
                ),
                child: Text(
                  menu.kategori == 'categoryFood'
                      ? AppLocalizations.categoryFood()
                      : menu.kategori == 'categoryDrink'
                          ? AppLocalizations.categoryDrink()
                          : menu.kategori,
                  style: AppFonts.smBold.copyWith(color: AppColors.green),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.green),
                tooltip: 'Edit',
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => EditMenuDialog(menu: menu),
                  );
                  if (result == true && onEditSuccess != null) {
                    onEditSuccess!();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            menu.priceFormatted,
            style: AppFonts.lgMedium.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.description(),
            style: AppFonts.smBold,
          ),
          const SizedBox(height: 8),
          Text(
            menu.description == 'descNasiGoreng'
                ? AppLocalizations.descNasiGoreng()
                : menu.description == 'descMatcha'
                    ? AppLocalizations.descMatcha()
                    : (menu.description.isNotEmpty ? menu.description : '-'),
            style: AppFonts.mdRegular,
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text('Hapus Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(140, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus menu ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  try {
                    dummyMenuList.removeWhere((m) => m.id == menu.id);
                    Get.back(); // close loading
                    Get.back(); // close detail
                    Get.snackbar('Sukses', 'Menu berhasil dihapus',
                        backgroundColor: Colors.green[100]);
                    if (onEditSuccess != null) onEditSuccess!();
                  } catch (e) {
                    Get.back(); // close loading
                    Get.snackbar('Gagal', 'Menu gagal dihapus',
                        backgroundColor: Colors.red[100]);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imageUrl),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}

class EditMenuDialog extends StatefulWidget {
  final MenuModel menu;
  const EditMenuDialog({Key? key, required this.menu}) : super(key: key);

  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  String kategori = '';
  bool isLoading = false;
  String? errorMsg;

  bool get isValid {
    return nameCtrl.text.trim().isNotEmpty &&
        kategori.isNotEmpty &&
        priceCtrl.text.trim().isNotEmpty &&
        int.tryParse(priceCtrl.text.trim()) != null &&
        int.parse(priceCtrl.text.trim()) > 0 &&
        descCtrl.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(
        text: widget.menu.name == 'menuNasiGoreng' ? '' : widget.menu.name);
    priceCtrl = TextEditingController(text: widget.menu.price.toString());
    descCtrl = TextEditingController(
        text: widget.menu.description == 'descNasiGoreng' ||
                widget.menu.description == 'descMatcha'
            ? ''
            : widget.menu.description);
    kategori = widget.menu.kategori;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    try {
      final idx = dummyMenuList.indexWhere((m) => m.id == widget.menu.id);
      if (idx != -1) {
        dummyMenuList[idx] = widget.menu.copyWith(
          name: nameCtrl.text.trim(),
          kategori: kategori,
          price: int.parse(priceCtrl.text.trim()),
          description: descCtrl.text.trim(),
        );
        if (mounted) {
          Get.snackbar('Sukses', 'Menu berhasil diedit',
              backgroundColor: Colors.green[100]);
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          errorMsg = 'Menu tidak ditemukan.';
        });
        Get.snackbar('Gagal', 'Menu gagal diedit',
            backgroundColor: Colors.red[100]);
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Terjadi kesalahan.';
      });
      Get.snackbar('Gagal', 'Menu gagal diedit',
          backgroundColor: Colors.red[100]);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Menu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Menu'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: kategori,
              items: [
                DropdownMenuItem(value: 'categoryFood', child: Text('Makanan')),
                DropdownMenuItem(
                    value: 'categoryDrink', child: Text('Minuman')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => kategori = val);
              },
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
              onChanged: (_) => setState(() {}),
            ),
            if (errorMsg != null) ...[
              const SizedBox(height: 8),
              Text(errorMsg!, style: const TextStyle(color: Colors.red)),
            ],
            if (isLoading) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: isValid && !isLoading ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? AppColors.green : Colors.grey,
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
