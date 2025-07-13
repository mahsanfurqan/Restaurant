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
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';

class RestaurantInfoWidget extends StatelessWidget {
  const RestaurantInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    return Obx(() {
      final state = controller.restaurantState.value;
      final isEditing = controller.isEditingRestaurant.value;
      final isLoading = controller.isLoadingRestaurant.value;

      if (state is ResultLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is ResultFailed) {
        final msg = AppUtils.getErrorMessage(null) ??
            state.maybeWhen(failed: (m) => m, orElse: () => null);
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
                        onPressed: () =>
                            controller.startEditRestaurant(restaurant),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.restaurantFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.editRestaurant(),
                      style: AppFonts.lgBold.copyWith(color: AppColors.green)),
                  const SizedBox(height: 12),
                  AppInput(
                    controller: controller.nameCtrl,
                    hintText: AppLocalizations.restaurantName(),
                    validator: (v) => v == null || v.isEmpty
                        ? AppLocalizations.restaurantNameRequired()
                        : null,
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: controller.addressCtrl,
                    hintText: AppLocalizations.restaurantAddress(),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: controller.descCtrl,
                    hintText: AppLocalizations.restaurantDescription(),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: controller.phoneCtrl,
                    hintText: AppLocalizations.restaurantPhone(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed:
                              isLoading ? null : controller.saveRestaurant,
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
                              : controller.cancelEditRestaurant,
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
