import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/bottle_store.dart';
import 'pages/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await BottleStore.open();
  runApp(DewaterApp(store: store));
}

class DewaterApp extends StatelessWidget {
  const DewaterApp({super.key, required this.store});

  final BottleStore store;

  @override
  Widget build(BuildContext context) {
    return BottleScope(
      store: store,
      child: MaterialApp(
        title: 'DEWater Tracker',
        debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      themeMode: ThemeMode.light,
      home: const HomeShell(),
      ),
    );
  }
}
