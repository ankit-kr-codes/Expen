import 'package:expen/pages/add_expense.dart';
import 'package:expen/pages/chart.dart';
import 'package:expen/pages/home.dart';
import 'package:expen/pages/about.dart';
import 'package:expen/pages/settings.dart';
import 'package:expen/provider/amount_provider.dart';
import 'package:expen/provider/theme_provider.dart';
import 'package:expen/provider/version_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'bloc/currency/currency_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AmountProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => VersionProvider()..loadVersion(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CurrencyBloc()),
          //
        ],
        child: const MyApp(),
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
      //
    ),
    GoRoute(
      path: '/chart',
      builder: (context, state) => const Chart(),
      //
    ),
    GoRoute(
      path: '/addexpense',
      builder: (context, state) => const AddExpense(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const Settings(),
      //
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const About(),
      //
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior(),
      title: "Expen",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      routerConfig: _router,
    );
  }
}
