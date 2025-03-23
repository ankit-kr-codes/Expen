import 'package:expen/core/providers.dart';
import 'package:expen/core/router.dart';
import 'package:expen/core/theme.dart';
import 'package:expen/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

///Entry point of app
void main() {
  runApp(appProvider(const MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: AppColors.transparent),
  );
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
      theme: ThemeData.light().copyWith(splashColor: AppColors.transparent),
      darkTheme: ThemeData.dark().copyWith(splashColor: AppColors.transparent),
      themeMode: themeProvider.themeMode,
      routerConfig: router,
    );
  }
}
