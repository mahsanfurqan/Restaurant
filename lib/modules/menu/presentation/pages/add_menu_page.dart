import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/helpers/alert_dialog_helper.dart';
import 'package:flutter_boilerplate/shared/helpers/bottom_sheet_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/shared/widgets/app_input.dart';
import 'package:flutter_boilerplate/shared/widgets/app_button.dart';
import 'package:flutter_boilerplate/shared/widgets/app_media_input.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'dart:io';
import '../controllers/add_menu_controller.dart';
import 'package:flutter_boilerplate/shared/widgets/app_dropdown.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/category_model.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddMenuPage extends GetView<AddMenuController> {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.addMenu())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              AppMediaInput.image(
                onSelect: (file) {
                  controller.image.value =
                      file is List && file.isNotEmpty ? file.first : file;
                },
              ),
              Obx(() => controller.image.value == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        AppLocalizations.imageRequired(),
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Image.file(
                        File(controller.image.value.path),
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.nameController,
                hintText: AppLocalizations.menuName(),
                validator: FormBuilderValidators.required(
                  errorText: AppLocalizations.menuNameRequired(),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => AppDropdown<CategoryModel>(
                    value: controller.selectedCategory.value,
                    items: controller.categoryList
                        .map((category) => DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(category.name ?? 'No Name'),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        controller.selectedCategory.value = value,
                    label: AppLocalizations.category(),
                    validator: (value) {
                      if (value == null) {
                        return AppLocalizations.categoryRequired();
                      }
                      return null;
                    },
                  )),
              const SizedBox(height: 16),
              AppInput.textarea(
                controller: controller.descriptionController,
                hintText: AppLocalizations.descriptionOptional(),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.priceController,
                hintText: AppLocalizations.price(),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: AppLocalizations.priceRequired(),
                  ),
                  (value) {
                    final numeric = value?.replaceAll(RegExp(r'[^0-9]'), '');
                    if (numeric == null || numeric.isEmpty) {
                      return AppLocalizations.priceRequired();
                    }
                    if (double.tryParse(numeric) == null) {
                      return AppLocalizations.priceMustBeNumber();
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final state = controller.submitState.value;
                return AppButton(
                  text: AppLocalizations.save(),
                  isLoading: state is ResultLoading,
                  backgroundColor: AppColors.green,
                  textColor: Colors.white,
                  onPressed: () => controller.submit(
                    onFailed: (message) {
                      BottomSheetHelper.showError(message);
                    },
                    onSuccess: (data) {
                      AlertDialogHelper.showSuccess(
                          AppLocalizations.createMenuSuccessMessage());
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
