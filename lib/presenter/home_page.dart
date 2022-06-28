import 'package:analytics_example/infrastructure/analytics/app_analytics.dart';
import 'package:analytics_example/presenter/second_page.dart';
import 'package:flutter/material.dart';

import '../infrastructure/lifecycle_handler/lifecycle_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LifeCycleHandler? _lifecycleObserver;
  int _counter = 0;

  @override
  void initState() {
    initPageObserver();
    super.initState();
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance!.addObserver(_lifecycleObserver!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance!.removeObserver(_lifecycleObserver!);
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final _analytics = AppAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondPage()));
              },
              child: const Text("Segunda página",
                  style: TextStyle(color: Colors.white))),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
          _analytics.logCounterClick(_counter);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
