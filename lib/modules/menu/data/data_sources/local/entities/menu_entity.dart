import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';

@Entity(tableName: 'menus', foreignKeys: [
  ForeignKey(
    childColumns: ['categoryId'],
    parentColumns: ['id'],
    entity: CategoryEntity,
    onDelete: ForeignKeyAction.cascade,
    onUpdate: ForeignKeyAction.cascade,
  )
])
class MenuEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? createdAt;
  final String? name;
  final String? description;
  final int? price;
  final bool? isAvailable;
  final int? categoryId;
  final String? photoUrl;

  const MenuEntity({
    this.id,
    this.createdAt,
    this.name,
    this.description,
    this.price,
    this.isAvailable,
    this.categoryId,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        name,
        description,
        price,
        isAvailable,
        categoryId,
        photoUrl,
      ];
}
