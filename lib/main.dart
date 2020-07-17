import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
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
      type: env.HiveTypes.Scan.value);
  // Creamos y abrimos la base de datos: settings
  await Hive.openBox<bool>(env.HiveSettings);
  // SimpleBlocObserver
  Bloc.observer = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc()..add(ThemeLoadStarted()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, themeState) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Tema oscuro o normal
            brightness: Brightness.light,
            backgroundColor: Colors.grey[200],
            bottomAppBarColor: Colors.white,
            dividerColor: Colors.grey[700],
            textSelectionColor: Colors.white,
            accentColorBrightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            // Tema oscuro o normal
            brightness: Brightness.dark,
            // Colores en RGB
            primaryColor: Color(0xff212121),
            primaryColorDark: Colors.black,
            bottomAppBarColor: Color(0xff212121),
            backgroundColor: Color(0xff303030),
            cardColor: Color(0xff424242),
            accentColor: Color(0xff64ffda),
            disabledColor: Colors.blueGrey,
            iconTheme: IconThemeData(color: Colors.white),
            dividerColor: Colors.white,
            textSelectionColor: Colors.black,
            primaryColorLight: Colors.white,
          ),
          themeMode: themeState.themeMode,
          home: BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc(),
            child: BottomNavPage(),
          ),
        ),
      ),
    );
  }
}
