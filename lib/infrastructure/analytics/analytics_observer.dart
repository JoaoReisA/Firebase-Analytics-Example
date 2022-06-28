import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'app_analytics.dart';

class CustomAnalyticsObserver extends FirebaseAnalyticsObserver {
  //Observador do comportamento das rotas

  CustomAnalyticsObserver({
    required this.firebaseAnalytics,
    required this.appAnalytics,
  }) : super(analytics: firebaseAnalytics);

  final FirebaseAnalytics firebaseAnalytics;
  final AppAnalytics appAnalytics;
  final _stopwatch = Stopwatch();

  int _timeOnRoute = 0;

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
  }

  void _finishTimer() {
    if (_stopwatch.isRunning) {
      _timeOnRoute = _stopwatch.elapsed.inSeconds;
      _stopwatch.reset();
      _stopwatch.stop();
    }
  }

  //Verifica se aconteceu um [Navigator.pop()]
  //Envia o tempo gasto na rota para o analytics
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute is PageRoute && route is PageRoute) {
      _finishTimer();

      appAnalytics.logAppNavigate(
        currentPageName: "${route.settings.name}",
        previousPageName: "${previousRoute.settings.name}",
        timeOnRoute: _timeOnRoute,
      );

      _startTimer();
    }
  }

  //Verifica se aconteceu um [Navigator.push()]
  //Envia para o firebase o nome da rota atual e o nome da rota anterior
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      _finishTimer();

      appAnalytics.logAppNavigate(
        currentPageName: "${route.settings.name}",
        previousPageName: "${previousRoute?.settings.name}",
        timeOnRoute: _timeOnRoute,
      );

      _startTimer();
    }
  }

  //Verifica se aconteceu um [Navigator.pushReplacement()]
  //Envia para o firebase o nome da rota atual e o nome da rota anterior
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute is PageRoute) {
      _finishTimer();

      appAnalytics.logAppNavigate(
        previousPageName: "${oldRoute?.settings.name}",
        currentPageName: "${newRoute.settings.name}",
        timeOnRoute: _timeOnRoute,
      );

      _startTimer();
    }
  }
}
