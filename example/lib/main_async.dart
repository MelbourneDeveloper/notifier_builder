import 'package:flutter/material.dart';
import 'package:notifier_builder/notifier_future_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) => NotifierFutureBuilder(
        future: getValueNotifier,
        builder: (context, child, notifierSnapshot) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: notifierSnapshot.connectionState == ConnectionState.done
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        '${notifierSnapshot.data!.value}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  )
                : const CircularProgressIndicator.adaptive(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => notifierSnapshot.data?.value++,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      );
}

Future<ValueNotifier<int>> getValueNotifier() =>
    Future<ValueNotifier<int>>.delayed(
      const Duration(seconds: 3),
      () => ValueNotifier<int>(0),
    );
