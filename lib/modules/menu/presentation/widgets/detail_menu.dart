import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
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
import 'package:flutter_boilerplate/modules/menu/presentation/controllers/view_menu_controller.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/widgets/app_alert_dialog.dart';
import 'package:flutter_boilerplate/shared/widgets/app_skeletonizer.dart';

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
            Center(child: _MenuImage(menu: menu)),
            const SizedBox(height: 24),
            _MenuInfoRow(menu: menu, onEditSuccess: onEditSuccess),
            const SizedBox(height: 12),
            _MenuPrice(menu: menu),
            const SizedBox(height: 24),
            _MenuDescription(menu: menu),
            const SizedBox(height: 24),
            Column(
              children: [
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 16),
                Center(
                  child:
                      _MenuActionRow(menu: menu, onEditSuccess: onEditSuccess),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  final MenuModel menu;
  const _MenuImage({required this.menu});
  @override
  Widget build(BuildContext context) {
    if (menu.photoUrl?.isNotEmpty ?? false) {
      return Image.network(
        menu.photoUrl ?? '',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return AppSkeletonizer(
            enabled: true,
            child: Container(
              width: 200,
              height: 200,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        'assets/images/placeholder.png',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
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
            menu.name ?? '',
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
            menu.category?.name ?? '',
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
              builder: (context) => EditMenuDialog(menu: menu, restaurantId: 0),
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
      menu.price?.toCurrencyFormat ?? '-',
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
          menu.description ?? '-',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppButton(
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
            final controller = Get.find<ViewMenuController>();
            final success = await controller.deleteMenu(menu.id!);
            Get.back();
            if (success) {
              Get.back();
              await AlertDialogHelper.showSuccess(
                  AppLocalizations.deleteMenuSuccess());
              if (onEditSuccess != null) onEditSuccess!();
            } else {
              await AlertDialogHelper.showError(
                  AppLocalizations.editMenuFailed());
            }
          }
        },
        text: AppLocalizations.deleteMenu(),
        prefixIcon: const Icon(Icons.delete, color: Colors.white),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        height: 44,
        alignment: MainAxisAlignment.center,
      ),
    );
  }
}

class EditMenuDialog extends StatefulWidget {
  final MenuModel menu;
  final int restaurantId;
  const EditMenuDialog(
      {super.key, required this.menu, required this.restaurantId});

  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  late String kategori;
  final _formKey = GlobalKey<FormState>();
  final Rx<ResultState<bool>> _editState =
      const ResultState<bool>.initial().obs;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.menu.name);
    priceCtrl = TextEditingController(text: widget.menu.price.toString());
    descCtrl = TextEditingController(text: widget.menu.description);
    kategori = widget.menu.category?.name ?? '';
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

    final Rx<ResultState<bool>> _editState =
        const ResultState<bool>.initial().obs;

    final controller = Get.find<ViewMenuController>();

    final result = await controller.editMenuFromFields(
      menuId: widget.menu.id,
      nameCtrl: nameCtrl,
      priceCtrl: priceCtrl,
      descCtrl: descCtrl,
      menu: widget.menu,
      restaurantId: widget.restaurantId,
    );

    _editState.value = result;

    result.maybeWhen(
      success: (data) async {
        await AlertDialogHelper.showSuccess(AppLocalizations.editMenuSuccess());
        if (mounted) Get.back(result: true);
      },
      failed: (message) {
        BottomSheetHelper.showError(message ?? 'Gagal menyimpan perubahan');
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.editMenu()),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInput(
              controller: nameCtrl,
              hintText: AppLocalizations.menuNameLabel(),
              validator: (v) => v == null || v.isEmpty
                  ? AppLocalizations.menuNameRequired()
                  : null,
            ),
            const SizedBox(height: 8),
            AppInput(
              controller: priceCtrl,
              hintText: AppLocalizations.priceLabel(),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty)
                  return AppLocalizations.priceRequired();
                if (double.tryParse(v) == null)
                  return AppLocalizations.priceMustBeNumber();
                return null;
              },
            ),
            const SizedBox(height: 8),
            AppInput(
              controller: descCtrl,
              hintText: AppLocalizations.descriptionLabel(),
              validator: (v) => v == null || v.isEmpty
                  ? AppLocalizations.description()
                  : null,
            ),
            Obx(() {
              final state = _editState.value;
              if (state is ResultLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ResultFailed) {
                final msg = AppUtils.getErrorMessage(null) ??
                    state.maybeWhen(failed: (m) => m, orElse: () => null);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(msg ?? '',
                      style: const TextStyle(color: Colors.red)),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
      actions: [
        AppButton.text(
          onPressed: () => Get.back(),
          text: AppLocalizations.cancel(),
        ),
        Obx(() {
          final state = _editState.value;
          return AppButton(
            text: AppLocalizations.save(),
            isLoading: state is ResultLoading,
            backgroundColor: AppColors.green,
            textColor: Colors.white,
            onPressed: () async {
              await _submit();
              final result = _editState.value;
              result.maybeWhen(
                failed: (message) {
                  BottomSheetHelper.showError(message ?? '');
                },
                success: (_) async {
                  await AlertDialogHelper.showSuccess(
                      AppLocalizations.editMenuSuccess());
                  Get.back(result: true);
                },
                orElse: () {},
              );
            },
          );
        }),
      ],
    );
  }
}
