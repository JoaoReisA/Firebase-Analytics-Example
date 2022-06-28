import 'package:analytics_example/infrastructure/analytics/analytics_observer.dart';
import 'package:analytics_example/infrastructure/analytics/app_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'base_injection.dart';

class AppModuleInjection extends BaseInjection {
  AppModuleInjection.init() {
    //Registra dependências
    locator.registerSingleton<AppAnalytics>(AppAnalyticsImpl());

    locator.registerSingleton<FirebaseAnalyticsObserver>(
      CustomAnalyticsObserver(
          firebaseAnalytics: FirebaseAnalytics.instance,
          appAnalytics: get<AppAnalytics>()),
    );
  }
}
