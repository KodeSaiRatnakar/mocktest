import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FetchedDataModel {
  final String topicName;
  final String timeStamp;

  const FetchedDataModel({required this.timeStamp, required this.topicName});
}

class LocalDataBase {
  static Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), "database.db"),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Topic(id INTEGER PRIMARY KEY AUTOINCREMENT ,topicName TEXT,timeStamp TEXT)"),
      version: 1,
    );
  }

  static Future writeData(String topic) async {
    final db = await getDataBase();
    String timeStamp = DateTime.now().toString();

    return db.rawInsert(
        "INSERT INTO Topic('topicName','timeStamp') VALUES ('${topic}','${timeStamp}')");
  }

  static Future<List<FetchedDataModel>> getDataFromLocalStorage() async {
    final db = await getDataBase();
    List<FetchedDataModel> list = [];

    List<Map<String, Object?>> data_list = await db.query("Topic");

    list = data_list
        .map((obj) => FetchedDataModel(
            timeStamp: obj['timeStamp'] as String,
            topicName: obj['topicName'] as String))
        .toList();

    return list;
  }
}
