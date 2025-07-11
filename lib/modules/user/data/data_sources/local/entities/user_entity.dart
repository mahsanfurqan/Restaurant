import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserEntity extends Equatable {
  @primaryKey
  final int? id;
  final String? username;
  final String? name;
  final String? email;

  const UserEntity({
    this.id,
    this.username,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        name,
      ];
}
