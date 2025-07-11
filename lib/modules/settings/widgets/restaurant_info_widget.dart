import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:flutter_boilerplate/shared/widgets/app_refresher.dart';
import 'package:flutter_boilerplate/shared/widgets/app_skeletonizer.dart';
import 'package:flutter_boilerplate/shared/widgets/app_error_bottom_sheet.dart';
import 'package:flutter_boilerplate/shared/widgets/app_fill_layout.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/restaurant_model.dart';

class RestaurantInfoWidget extends StatelessWidget {
  RestaurantInfoWidget({Key? key}) : super(key: key);

  final SettingsController controller = Get.find<SettingsController>();
  final RxBool isEditing = false.obs;
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  void _startEdit(RestaurantModel? restaurant) {
    nameCtrl.text = restaurant?.name ?? '';
    addressCtrl.text = restaurant?.address ?? '';
    descCtrl.text = restaurant?.description ?? '';
    phoneCtrl.text = restaurant?.phone ?? '';
    isEditing.value = true;
  }

  Future<void> _save(BuildContext context) async {
    if (nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantNameRequired())),
      );
      return;
    }
    final success = await controller.updateRestaurant({
      'name': nameCtrl.text,
      'address': addressCtrl.text,
      'description': descCtrl.text,
      'phone': phoneCtrl.text,
    });
    if (!context.mounted) return;
    if (success) {
      await controller.fetchRestaurant();
      isEditing.value = false;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantUpdateSuccess())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.restaurantUpdateFailed())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.restaurantError.value != null) {
        return AppFillLayout(
          child:
              AppErrorBottomSheet(message: controller.restaurantError.value!),
        );
      }
      return AppRefresher(
        onRefresh: controller.fetchRestaurant,
        child: AppSkeletonizer(
          enabled: controller.isRestaurantLoading.value,
          child: Obx(() {
            final restaurant = controller.restaurant.value;
            if (restaurant == null) {
              return AppFillLayout(
                child: AppErrorBottomSheet(
                    message: AppLocalizations.restaurantNotFound()),
              );
            }
            if (!isEditing.value) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
                          AppButton.text(
                            onPressed: () => _startEdit(restaurant),
                            text: AppLocalizations.edit(),
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
            // Edit mode
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.editRestaurant(),
                        style:
                            AppFonts.lgBold.copyWith(color: AppColors.green)),
                    const SizedBox(height: 12),
                    AppInput(
                      controller: nameCtrl,
                      hintText: AppLocalizations.restaurantNamePlaceholder(),
                      validator: (v) => v == null || v.isEmpty
                          ? AppLocalizations.restaurantNameRequired()
                          : null,
                      enabled: !controller.isRestaurantLoading.value,
                    ),
                    const SizedBox(height: 8),
                    AppInput(
                      controller: addressCtrl,
                      hintText: AppLocalizations.restaurantAddressPlaceholder(),
                      enabled: !controller.isRestaurantLoading.value,
                    ),
                    const SizedBox(height: 8),
                    AppInput(
                      controller: descCtrl,
                      hintText:
                          AppLocalizations.restaurantDescriptionPlaceholder(),
                      enabled: !controller.isRestaurantLoading.value,
                    ),
                    const SizedBox(height: 8),
                    AppInput(
                      controller: phoneCtrl,
                      hintText: AppLocalizations.restaurantPhonePlaceholder(),
                      enabled: !controller.isRestaurantLoading.value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onPressed: controller.isRestaurantLoading.value
                                ? null
                                : () => _save(context),
                            text: AppLocalizations.save(),
                            isLoading: controller.isRestaurantLoading.value,
                            backgroundColor: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton.text(
                            onPressed: controller.isRestaurantLoading.value
                                ? null
                                : () => isEditing.value = false,
                            text: AppLocalizations.cancel(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
