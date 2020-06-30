import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:qrcode/models/qr_model.dart';

class HiveDatabase {
  Future<void> createDatabase(
      {String database, TypeAdapter adapter, String type}) async {
    // Establece el path donde se guardara la base de datos
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    // Registra el adapter
    if (adapter != null) Hive.registerAdapter(adapter);
    // Abre la base de datos segun su tipo
    await openDatabase(database: database, type: type);
    print("Base de datos creada: $database");
  }

  Future<void> openDatabase({String database, String type}) async {
    if (type == HiveTypes.Scan.toString()) await Hive.openBox<Scan>(database);
  }

  Future<dynamic> returnBox({String database, String type}) async {
    if (type == HiveTypes.Scan.toString()) return Hive.box<Scan>(database);
  }

  Future<bool> addToDatabase(
      {String database, dynamic record, String type}) async {
    final Box box = await returnBox(database: database, type: type);
    box.add(record);
    return true;
  }

  Future<bool> removeFromDatabase(
      {String database, dynamic key, String type}) async {
    final Box box = await returnBox(database: database, type: type);
    box.delete(key);
    return true;
  }

  Future<bool> updateFromDatabase(
      {String database, dynamic key, dynamic record, String type}) async {
    final Box box = await returnBox(database: database, type: type);
    box.put(key, record);
    return true;
  }

  Future<bool> clearDatabase({String database, String type}) async {
    final Box box = await returnBox(database: database, type: type);
    box.clear();
    return true;
  }
}
