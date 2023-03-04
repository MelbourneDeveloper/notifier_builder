// ignore: lines_longer_than_80_chars
// ignore_for_file: inference_failure_on_untyped_parameter, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifier_builder/notifier_builder.dart';

class MockNotifier extends ChangeNotifier {}

void main() {
  testWidgets('NotifierBuilder builds widget tree', (tester) async {
    final mockNotifier = MockNotifier();
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierBuilder(
          notifier: () => mockNotifier,
          builder: (context, child, notifier) => Text(notifier.toString()),
        ),
      ),
    );
    expect(find.text(mockNotifier.toString()), findsOneWidget);
  });

  testWidgets('NotifierBuilder disposes notifier', (tester) async {
    final mockNotifier = MockNotifier();
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierBuilder(
          notifier: () => mockNotifier,
          builder: (context, child, notifier) => Text(notifier.toString()),
        ),
      ),
    );
    await tester.pumpWidget(Container());
    expect(mockNotifier.hasListeners, isFalse);
  });

  testWidgets('NotifierBuilder rebuilds widget tree', (tester) async {
    final mockNotifier = MockNotifier();
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierBuilder(
          notifier: () => mockNotifier,
          builder: (context, child, notifier) => Text(notifier.toString()),
        ),
      ),
    );
    mockNotifier.notifyListeners();
    await tester.pump();
    expect(find.text(mockNotifier.toString()), findsOneWidget);
  });

  testWidgets('NotifierBuilder exposes notifier in tests', (tester) async {
    final mockNotifier = MockNotifier();
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierBuilder(
          child: const SizedBox(),
          notifier: () => mockNotifier,
          builder: (context, child, notifier) => child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    // ignore: unused_local_variable
    final state = tester.state<NotifierBuilderState>(
      find.byType(NotifierBuilder<MockNotifier>),
    );
    expect(state.notifier, equals(mockNotifier));
  });
}
