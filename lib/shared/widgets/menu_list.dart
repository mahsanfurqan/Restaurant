import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/utils/app_assets.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';

class MenuList extends StatelessWidget {
  final List<MenuModel> menus;
  final bool isLoading;
  final bool isError;
  final bool isEmpty;
  final VoidCallback? onRefresh;
  final Function(MenuModel) onTap;
  final ScrollController? scrollController;

  const MenuList({
    super.key,
    required this.menus,
    required this.isLoading,
    required this.isError,
    required this.isEmpty,
    this.onRefresh,
    required this.onTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isError) {
      return Center(child: Text('Gagal mengambil data menu'));
    }
    if (isEmpty) {
      return Center(child: Text('Menu kosong'));
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: menus.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final menu = menus[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(menu),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
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
                        menu.imageUrl,
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
                                  border: Border.all(
                                      color: AppColors.green, width: 1.5),
                                ),
                                child: Text(
                                  menu.kategori == 'categoryFood'
                                      ? AppLocalizations.categoryFood()
                                      : menu.kategori == 'categoryDrink'
                                          ? AppLocalizations.categoryDrink()
                                          : menu.kategori,
                                  style: AppFonts.smBold
                                      .copyWith(color: AppColors.green),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            menu.priceFormatted,
                            style: AppFonts.smMedium
                                .copyWith(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
