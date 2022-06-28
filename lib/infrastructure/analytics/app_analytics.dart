import 'package:analytics_example/core/di/base_injection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppAnalytics {
  Future<void> setup(bool enabled);
  Future<void> setUserId(String? id);
  void logEvent(String name, {Map<String, dynamic>? parameters});
  void logCounterClick(int count);
  void logAppNavigate({
    required String currentPageName,
    required String previousPageName,
    required int timeOnRoute,
  });
  void logLifeCycleEvent({required String event});
  FirebaseAnalyticsObserver getAnalyticsObserver();
}

class AppAnalyticsImpl implements AppAnalytics {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  //Faz o setup do firebase analytics
  @override
  Future<void> setup(bool enabled) async {
    await _setCustomDefinitions();
    await _setEnabled(enabled);
  }

  Future<void> _setEnabled(bool enabled) async {
    await _firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);
  }

  //Define os parametros customizados e propriedades do usuário
  Future<void> _setCustomDefinitions() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    await _firebaseAnalytics.setUserProperty(
        name: "VersionNumber", value: version);
  }

  //Envia o userId para o firebase
  @override
  Future<void> setUserId(String? id) async {
    await _firebaseAnalytics.setUserId(id: id);
  }

  //Envio base de evento para o firebase
  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  //Padrão para enviar evento de click
  @override
  void logCounterClick(int count) {
    logEvent("counter", parameters: {
      "count": "$count",
    });
  }

  //Padrão para enviar evento de navegação
  @override
  void logAppNavigate({
    required String currentPageName,
    required String previousPageName,
    required int timeOnRoute,
  }) {
    logEvent("navegacao_app", parameters: {
      "nome_pagina": previousPageName,
      "nome_pagina_originaria": currentPageName,
      "tempo_permanencia": "$timeOnRoute",
    });
  }

  //Padrão para enviar eventos do lifecycle
  @override
  void logLifeCycleEvent({required String event}) {
    logEvent("lifeCycle_event", parameters: {"event": event});
  }

  //Pega a instância do FirebaseAnalyticsObserver
  @override
  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      BaseInjection.getIt<FirebaseAnalyticsObserver>();
}
