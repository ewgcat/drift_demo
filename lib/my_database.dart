import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'my_database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tasks])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  ///插入
  Future<int> insertTask(Task task) async {
    return await into(tasks).insert(task);
  }

  ///查询数据
  Future<List<Task>> queryTasks() async {
    return await select(tasks).get();
  }

  /// 更新数据
  Future<bool> updateTask(Task task) async {
    return await update(tasks).replace(task);
  }

  ///删除数据
  Future<int> deleteTask(Task task) async {
    return await delete(tasks).delete(task);
  }
  ///删除数据
  Future<int> deleteAllTasks() => delete(tasks).go();


}

class DatabaseManager {
  MyDatabase myDatabase = MyDatabase();

  DatabaseManager._();

  static final DatabaseManager _instance = DatabaseManager._();

  static DatabaseManager get instance {
    return _instance;
  }
}
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'test.db'));
    return NativeDatabase(file);
  });
}

