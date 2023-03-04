# NotifierBuilder

A Flutter library that provides an alternative to AnimatedBuilder for building widgets that depend on any Listenable notifier/controller

## Introduction

The `NotifierBuilder` class is a Flutter widget that enables you to build widgets that depend on any Listenable notifier/controller. The `NotifierBuilder` class works by creating a `notifier` once and holding onto it in the `State`. This is the key difference from [`AnimatedBuilder`](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html). No matter how many times the widget rebuilds, the controller only has one instance. That means you can safely instantiate your controller with `notifier` in a `StatelessWidget`. You don't need any special library like `Provider` to hold onto the controller for you.

The builder function is then called, which builds the widget tree based on the notifier's state. The NotifierBuilder is designed to work with any Listenable notifier, including ValueNotifier, ChangeNotifier, and StreamController.

## Installation

To use the NotifierBuilder class in your Flutter project, add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  notifier_builder: #VERSION
```

Then, run `flutter pub get` in your terminal.

## Usage

To use the NotifierBuilder class, create a new instance of the class and pass in the notifier and builder functions. Here's an example:

```dart
import 'package:flutter/material.dart';
import 'package:notifier_builder/notifier_builder.dart';

ValueNotifier<int> _counter = ValueNotifier<int>(0);

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
        home: NotifierBuilder<ValueNotifier<int>>(
          notifier: () => _counter,
          builder: (context, child, notifier) => Scaffold(
            body: Center(
              child: Text(
                notifier.value.toString(),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => notifier.value++,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );
}
```

In this example, we create a new instance of the NotifierBuilder class with a ValueNotifier as the notifier. We also pass in a builder function that builds a Scaffold widget with a Text widget that displays the current value of the ValueNotifier and a FloatingActionButton that increments the ValueNotifier when pressed.

In addition to taking care of instantiation, the builder function also exposes the notifier to the widget tree. This is useful if you want to access the notifier from a child widget. For example, you can use the notifier to access the current value of the notifier in a child widget.

## Conclusion

Use this library instead of `AnimatedBuilder`. The widget will not instantiate your controller multiple times, and you have access to the controller via the `builder` function.