import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/pages/bottomnav_page.dart';
import 'blocs/blocs.dart';
import 'environment/environment.dart' as env;
import 'models/qr_model.dart';
import 'repositories/hivedb_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar la base de datos
  // final document = await getApplicationDocumentsDirectory();
  // Hive.init(document.path);

  // Base de datos: history
  await HiveDatabase().createDatabase(
      database: env.HiveHistory,
      adapter: ScanAdapter(),
      type: env.HiveTypes.Scan.toString());
  // SimpleBlocDelegate
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc(),
            child: BottomNavPage()));
  }
}
