import 'package:expen/core/providers.dart';
import 'package:expen/core/router.dart';
import 'package:expen/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Entry point of app
void main() {
  runApp(appProvider(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme mode from provider
    var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior(),
      title: "Expen",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      routerConfig: router,
    );
  }
}
