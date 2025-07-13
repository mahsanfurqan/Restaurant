import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';

class RestaurantInfoWidget extends StatefulWidget {
  const RestaurantInfoWidget({Key? key}) : super(key: key);

  @override
  State<RestaurantInfoWidget> createState() => _RestaurantInfoWidgetState();
}

class _RestaurantInfoWidgetState extends State<RestaurantInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController descCtrl;
  late TextEditingController phoneCtrl;
  bool isEditing = false;
  bool isLoading = false;

  void _startEdit(Map<String, dynamic> data) {
    setState(() {
      isEditing = true;
      nameCtrl.text = data['name'] ?? '';
      addressCtrl.text = data['address'] ?? '';
      descCtrl.text = data['description'] ?? '';
      phoneCtrl.text = data['phone'] ?? '';
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    final controller = Get.find<SettingsController>();
    await controller.updateRestaurant({
      'name': nameCtrl.text,
      'address': addressCtrl.text,
      'description': descCtrl.text,
      'phone': phoneCtrl.text,
    });
    setState(() => isLoading = false);
    final state = controller.updateRestaurantState.value;
    if (state.successOrNull == true) {
      controller.fetchRestaurant();
      setState(() => isEditing = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantUpdateSuccess())),
      );
    } else if (state is ResultFailed) {
      final msg = state.maybeWhen(failed: (m) => m, orElse: () => null);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg ?? AppLocalizations.restaurantUpdateFailed())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    descCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    descCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<SettingsController>();
      final state = controller.restaurantState.value;
      if (state is ResultLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is ResultFailed) {
        final msg = state.maybeWhen(failed: (m) => m, orElse: () => null);
        return Center(
            child: Text(msg ?? AppLocalizations.restaurantNotFound()));
      }
      if (state is ResultSuccess<RestaurantModel>) {
        final restaurant = state.data;
        if (!isEditing) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.restaurant_menu_rounded,
                              color: AppColors.green),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.restaurantSettingTitle(),
                              style: AppFonts.lgBold.copyWith()),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.green),
                        onPressed: () => _startEdit({
                          'name': restaurant.name,
                          'address': restaurant.address,
                          'description': restaurant.description,
                          'phone': restaurant.phone,
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '${AppLocalizations.restaurantName()}: ${restaurant.name ?? "-"}',
                      style: AppFonts.mdSemiBold),
                  Text(
                      '${AppLocalizations.restaurantAddress()}: ${restaurant.address ?? "-"}',
                      style: AppFonts.smRegular),
                  Text(
                      '${AppLocalizations.restaurantDescription()}: ${restaurant.description ?? "-"}',
                      style: AppFonts.smRegular),
                  Text(
                      '${AppLocalizations.restaurantPhone()}: ${restaurant.phone ?? "-"}',
                      style: AppFonts.smRegular),
                ],
              ),
            ),
          );
        }
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.editRestaurant(),
                      style: AppFonts.lgBold.copyWith(color: AppColors.green)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.restaurantName()),
                    validator: (v) => v == null || v.isEmpty
                        ? AppLocalizations.restaurantNameRequired()
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.restaurantAddress()),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.restaurantDescription()),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.restaurantPhone()),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: isLoading ? null : _save,
                          text: AppLocalizations.save(),
                          isLoading: isLoading,
                          backgroundColor: AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton.text(
                          onPressed: isLoading
                              ? null
                              : () => setState(() => isEditing = false),
                          text: AppLocalizations.cancel(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
