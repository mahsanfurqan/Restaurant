import 'package:flutter/material.dart';
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
                controller: controller.namaController,
                hintText: AppLocalizations.menuName(),
                validator: controller.validateNama,
              ),
              const SizedBox(height: 16),
              Obx(() => AppDropdown<CategoryModel>(
                    value: controller.selectedKategori.value,
                    items: controller.kategoriList
                        .map((kategori) => DropdownMenuItem<CategoryModel>(
                              value: kategori,
                              child: Text(kategori.name ?? 'Tanpa Nama'),
                            ))
                        .toList(),
                    onChanged: (value) => controller.selectedKategori.value =
                        value as CategoryModel?,
                    label: AppLocalizations.category(),
                    validator: controller.validateKategori,
                  )),
              const SizedBox(height: 16),
              AppInput.textarea(
                controller: controller.deskripsiController,
                hintText: AppLocalizations.descriptionOptional(),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: controller.hargaController,
                hintText: AppLocalizations.price(),
                keyboardType: TextInputType.number,
                validator: controller.validateHarga,
              ),
              const SizedBox(height: 24),
              Obx(() {
                final state = controller.submitState.value;
                if (state is ResultFailed<bool>) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      state.message ?? 'Failed to save menu',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Obx(() {
                final state = controller.submitState.value;
                return AppButton(
                  text: AppLocalizations.save(),
                  isLoading: state is ResultLoading,
                  backgroundColor: AppColors.green,
                  textColor: Colors.white,
                  onPressed: () => controller.submit(
                    onFailed: (message) {
                      Get.snackbar('Error', message);
                    },
                    onSuccess: (success) {
                      Get.snackbar('Success', 'Menu saved successfully');
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
