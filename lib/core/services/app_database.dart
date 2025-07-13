import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/db/note_dao.dart';
import 'package:flutter_boilerplate/modules/note/data/data_sources/local/entities/note_entity.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/db/user_dao.dart';
import 'package:flutter_boilerplate/modules/user/data/data_sources/local/entities/user_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/menu_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/db/category_dao.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/menu_entity.dart';
import 'package:flutter_boilerplate/modules/menu/data/data_sources/local/entities/category_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'generated/app_database.g.dart';

@Database(
    version: 1, entities: [UserEntity, NoteEntity, MenuEntity, CategoryEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  NoteDao get noteDao;
  MenuDao get menuDao;
  CategoryDao get categoryDao;
}
