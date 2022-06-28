import 'package:flutter/material.dart';

import 'core/di/base_injection.dart';
import 'infrastructure/analytics/app_analytics.dart';
import 'presenter/home_page.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppAnalytics _analytics = BaseInjection.getIt<AppAnalytics>();

  List<NavigatorObserver> _observers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      _observers = [
        _analytics.getAnalyticsObserver(),
      ];
    } catch (e) {
      _observers = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: _observers,
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
