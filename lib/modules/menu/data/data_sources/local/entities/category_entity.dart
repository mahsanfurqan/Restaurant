import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class CategoryEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final String? createdAt;

  const CategoryEntity({
    this.id,
    this.name,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
      ];
}
