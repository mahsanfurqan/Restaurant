import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_dropdown.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_boilerplate/shared/widgets/app_fill_layout.dart';
import 'package:flutter_boilerplate/shared/widgets/app_refresher.dart';

class DetailMenu extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onEditSuccess;
  final VoidCallback? onRefresh;
  const DetailMenu(
      {super.key, required this.menu, this.onEditSuccess, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppRefresher(
      onRefresh: onRefresh ?? () async {},
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _MenuImage()),
            const SizedBox(height: 24),
            _MenuInfoRow(menu: menu, onEditSuccess: onEditSuccess),
            const SizedBox(height: 12),
            _MenuPrice(menu: menu),
            const SizedBox(height: 24),
            _MenuDescription(menu: menu),
            const SizedBox(height: 24),
            Center(
                child:
                    _MenuActionRow(menu: menu, onEditSuccess: onEditSuccess)),
          ],
        ),
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  const _MenuImage();
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/placeholder.png',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}

class _MenuInfoRow extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onEditSuccess;
  const _MenuInfoRow({required this.menu, this.onEditSuccess});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            menu.name == 'menuNasiGoreng'
                ? AppLocalizations.menuNasiGoreng()
                : menu.name == 'menuMatcha'
                    ? AppLocalizations.menuMatcha()
                    : menu.name,
            style: AppFonts.lgBold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }
}

class _MenuPrice extends StatelessWidget {
  final MenuModel menu;
  const _MenuPrice({required this.menu});
  @override
  Widget build(BuildContext context) {
    return Text(
      int.tryParse(menu.price ?? '')?.toCurrencyFormat ?? '-',
      style: AppFonts.lgMedium.copyWith(color: Colors.black87),
    );
  }
}

class _MenuDescription extends StatelessWidget {
  final MenuModel menu;
  const _MenuDescription({required this.menu});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

class _MenuActionRow extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onEditSuccess;
  const _MenuActionRow({required this.menu, this.onEditSuccess});
  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.confirm()),
            content: Text(AppLocalizations.deleteMenuConfirmation()),
            actions: [
              AppButton.text(
                onPressed: () => Get.back(result: false),
                text: AppLocalizations.cancel(),
              ),
              AppButton(
                onPressed: () => Get.back(result: true),
                text: AppLocalizations.deleteMenu(),
                backgroundColor: Colors.red,
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
      text: AppLocalizations.deleteMenu(),
      prefixIcon: const Icon(Icons.delete, color: Colors.white),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      width: 140,
      height: 44,
    );
  }
}

class EditMenuDialog extends StatefulWidget {
  final MenuModel menu;
  const EditMenuDialog({super.key, required this.menu});

  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  String? kategori;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
    kategori = widget.menu.categories.name;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    try {
      if (mounted) {
        await AlertDialogHelper.showSuccess(AppLocalizations.editMenuSuccess());
        Get.back(result: true);
      }
    } catch (e) {
      await AlertDialogHelper.showError(AppLocalizations.editMenuFailed());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.editMenu()),
      content: AppFillLayout(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppInput(
                controller: nameCtrl,
                hintText: AppLocalizations.menuNameLabel(),
                validator: FormBuilderValidators.required(
                  errorText: AppLocalizations.menuNameRequired(),
                ),
              ),
              const SizedBox(height: 8),
              AppDropdown<String>(
                value: kategori,
                items: [
                  DropdownMenuItem(
                      value: 'categoryFood',
                      child: Text(AppLocalizations.categoryFood())),
                  DropdownMenuItem(
                      value: 'categoryDrink',
                      child: Text(AppLocalizations.categoryDrink())),
                ],
                onChanged: (val) => setState(() => kategori = val),
                label: AppLocalizations.categoryLabel(),
                validator: FormBuilderValidators.required(
                  errorText: AppLocalizations.categoryRequired(),
                ),
              ),
              const SizedBox(height: 8),
              AppInput(
                controller: priceCtrl,
                hintText: AppLocalizations.priceLabel(),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: AppLocalizations.priceRequired(),
                  ),
                  FormBuilderValidators.numeric(
                    errorText: AppLocalizations.priceMustBeNumber(),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              AppInput.textarea(
                controller: descCtrl,
                hintText: AppLocalizations.descriptionLabel(),
                validator: FormBuilderValidators.required(
                  errorText: AppLocalizations.description(),
                ),
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppButton.text(
          onPressed: isLoading ? null : () => Get.back(),
          text: AppLocalizations.cancel(),
        ),
        AppButton(
          onPressed: !isLoading ? _submit : null,
          text: AppLocalizations.save(),
          isLoading: isLoading,
          backgroundColor: AppColors.green,
        ),
      ],
    );
  }
}
