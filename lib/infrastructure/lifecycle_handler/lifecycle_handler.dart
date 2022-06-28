import 'package:flutter/material.dart';

import '../../core/di/base_injection.dart';
import '../analytics/app_analytics.dart';

class LifeCycleHandler extends WidgetsBindingObserver {
  LifeCycleHandler({this.onPauseCallback});

  VoidCallback? onPauseCallback;
  final AppAnalytics analytics = BaseInjection.getIt<AppAnalytics>();

  AppLifecycleState _previousState = AppLifecycleState.inactive;

  //Quando o app mudar o estado da tela chama o callback
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state != _previousState) {
      if (state == AppLifecycleState.paused) {
        onPauseCallback?.call();
      }

      // TODO: O detach está com um problema no seu funcionamento do Android, por isso a
      //  implementação está sendo feita diretamente no pause.
      // https://github.com/flutter/flutter/issues/57594
      /* switch (state) {
        case AppLifecycleState.paused:
          onDetachCallback?.call();

          break;

        case AppLifecycleState.detached:
          onDetachCallback?.call();
          break;

        default:
          print(state);
          break;
      } */
    }

    _previousState = state;
  }
}
