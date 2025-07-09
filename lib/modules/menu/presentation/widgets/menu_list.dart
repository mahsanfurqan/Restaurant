import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/modules/menu/data/models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/utils/app_utils.dart';

class MenuListItem extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onTap;
  const MenuListItem({super.key, required this.menu, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: context.theme.dividerColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/placeholder.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            menu.name == 'menuNasiGoreng'
                                ? AppLocalizations.menuNasiGoreng()
                                : menu.name == 'menuMatcha'
                                    ? AppLocalizations.menuMatcha()
                                    : menu.name,
                            style: AppFonts.lgBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                            border:
                                Border.all(color: AppColors.green, width: 1.5),
                          ),
                          child: Text(
                            (menu.categories.name ?? '') == 'categoryFood'
                                ? AppLocalizations.categoryFood()
                                : (menu.categories.name ?? '') ==
                                        'categoryDrink'
                                    ? AppLocalizations.categoryDrink()
                                    : (menu.categories.name ?? ''),
                            style: AppFonts.smBold
                                .copyWith(color: AppColors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      int.tryParse(menu.price ?? '')?.toCurrencyFormat ?? '-',
                      style: AppFonts.smMedium.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
