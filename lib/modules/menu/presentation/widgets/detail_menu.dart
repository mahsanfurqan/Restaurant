import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';

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
              child: _buildImage(),
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
                  (menu.categories.name ?? '') == 'categoryFood'
                      ? AppLocalizations.categoryFood()
                      : (menu.categories.name ?? '') == 'categoryDrink'
                          ? AppLocalizations.categoryDrink()
                          : (menu.categories.name ?? ''),
                  style: AppFonts.smBold.copyWith(color: AppColors.green),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.green),
                tooltip: AppLocalizations.edit(),
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
            toCurrency(menu.price ?? ''),
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
              label: Text(AppLocalizations.deleteMenu()),
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
                    title: Text(AppLocalizations.confirm()),
                    content: Text(AppLocalizations.deleteMenuConfirmation()),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text(AppLocalizations.cancel()),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.back(result: true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text(AppLocalizations.deleteMenu()),
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
                  Get.back(); // tutup loading
                  Get.back(); // tutup bottomsheet
                  await AlertDialogHelper.showSuccess(
                      AppLocalizations.deleteMenuSuccess());
                  if (onEditSuccess != null) onEditSuccess!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      'assets/images/placeholder.png',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  String toCurrency(String value) {
    if (value.isEmpty) return '-';
    try {
      final number = int.tryParse(value) ?? 0;
      return 'Rp${number.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')},-';
    } catch (_) {
      return value;
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
    kategori = widget.menu.categories.name ?? '';
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
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (mounted) {
        await AlertDialogHelper.showSuccess(AppLocalizations.editMenuSuccess());
        Get.back(result: true);
      }
    } catch (e) {
      setState(() {
        errorMsg = AppLocalizations.errorOccurred();
      });
      await AlertDialogHelper.showError(AppLocalizations.editMenuFailed());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.editMenu()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration:
                  InputDecoration(labelText: AppLocalizations.menuNameLabel()),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: kategori,
              items: [
                DropdownMenuItem(
                    value: 'categoryFood',
                    child: Text(AppLocalizations.categoryFood())),
                DropdownMenuItem(
                    value: 'categoryDrink',
                    child: Text(AppLocalizations.categoryDrink())),
              ],
              onChanged: (val) {
                if (val != null) setState(() => kategori = val);
              },
              decoration:
                  InputDecoration(labelText: AppLocalizations.categoryLabel()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: AppLocalizations.priceLabel()),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                  labelText: AppLocalizations.descriptionLabel()),
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
          onPressed: isLoading ? null : () => Get.back(),
          child: Text(AppLocalizations.cancel()),
        ),
        ElevatedButton(
          onPressed: isValid && !isLoading ? _submit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? AppColors.green : Colors.grey,
          ),
          child: Text(AppLocalizations.save()),
        ),
      ],
    );
  }
}
