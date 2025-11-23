import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get time => text().nullable()(); // Tambahkan ini
}