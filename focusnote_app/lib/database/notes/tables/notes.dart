// lib/database/tables/notes.dart
import 'package:drift/drift.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content =>
      text().named('content').withDefault(const Constant(''))();
}
