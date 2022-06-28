import 'package:get_it/get_it.dart';

class BaseInjection {
  //Classe base para facilitar a implementação
  //de injeções de depêndencias
  final GetIt locator = GetIt.I;

  T get<T extends Object>({String? instanceName}) {
    return locator.get<T>(instanceName: instanceName);
  }

  static T getIt<T extends Object>({String? instanceName}) {
    return GetIt.I.get<T>(instanceName: instanceName);
  }
}
