import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';

class MenuListItem extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onTap;

  const MenuListItem({super.key, required this.menu, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final borderColor = theme.dividerColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: menu.photoUrl?.isNotEmpty == true
                    ? Image.network(
                        menu.photoUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/nasigoreng.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              // Informasi menu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama menu
                    Text(
                      menu.name ?? 'No Name',
                      style: AppFonts.lgBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Harga menu
                    Text(
                      menu.price?.toCurrencyFormat ?? '-',
                      style: AppFonts.smMedium.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Kategori
              if (menu.category?.name != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: Text(
                    menu.category!.name!,
                    style: AppFonts.smBold.copyWith(color: AppColors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
