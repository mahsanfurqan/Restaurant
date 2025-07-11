import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    final restaurant = Get.find<SettingsController>().restaurant.value;
    nameCtrl = TextEditingController(text: restaurant?.name ?? '');
    addressCtrl = TextEditingController(text: restaurant?.address ?? '');
    descCtrl = TextEditingController(text: restaurant?.description ?? '');
    phoneCtrl = TextEditingController(text: restaurant?.phone ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    descCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _startEdit() {
    setState(() => isEditing = true);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    final controller = Get.find<SettingsController>();
    final success = await controller.updateRestaurant({
      'name': nameCtrl.text,
      'address': addressCtrl.text,
      'description': descCtrl.text,
      'phone': phoneCtrl.text,
    });
    setState(() => isLoading = false);
    if (success) {
      await controller.fetchRestaurant();
      setState(() => isEditing = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantUpdateSuccess())),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantUpdateFailed())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final restaurant = Get.find<SettingsController>().restaurant.value;
      if (restaurant == null) {
        return Center(child: Text(AppLocalizations.restaurantNotFound()));
      }
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
                            style: AppFonts.lgBold
                                .copyWith(color: AppColors.black)),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.green),
                      onPressed: _startEdit,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    });
  }
}
