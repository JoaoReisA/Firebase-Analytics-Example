import 'package:analytics_example/infrastructure/lifecycle_handler/lifecycle_handler.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  LifeCycleHandler? _lifecycleObserver;

  @override
  void initState() {
    initPageObserver();
    super.initState();
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance?.addObserver(_lifecycleObserver!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance?.removeObserver(_lifecycleObserver!);
    }
  }

  void initPageObserver() {
    _lifecycleObserver = LifeCycleHandler(onPauseCallback: onPauseCallback);
  }

  //Envia o evento para o firebase
  void onPauseCallback() {
    if (_lifecycleObserver != null) {
      _lifecycleObserver!.analytics
          .logLifeCycleEvent(event: "O estado de tela mudou");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Segunda Página"),
      ),
      body: const Center(
        child: Text("Segunda Página",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
    );
  }
}
