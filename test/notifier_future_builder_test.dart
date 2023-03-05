import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifier_builder/notifier_future_builder.dart';

void main() {
  testWidgets('NotifierFutureBuilder updates UI when future resolves',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierFutureBuilder<ValueNotifier<int>>(
          future: () async => ValueNotifier(42),
          builder: (context, child, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? Text('${snapshot.data!.value}')
                  : const CircularProgressIndicator(),
        ),
      ),
    );

    // Verify that CircularProgressIndicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('42'), findsNothing);

    // Wait for future to resolve
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that Text widget with value 42 is shown after future resolves
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('NotifierFutureBuilder updates UI when future errors',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotifierFutureBuilder<ValueNotifier<int>>(
          future: () async => Future<ValueNotifier<int>>.delayed(
            const Duration(milliseconds: 500),
            () => throw Exception('Oops'),
          ),
          builder: (context, child, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.error != null) {
              final dynamic error = snapshot.error as dynamic;
              // ignore: avoid_dynamic_calls
              final errorMessage = 'Error: ${error.message}';
              return Text(errorMessage);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );

    // Verify that CircularProgressIndicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Error: Oops'), findsNothing);

    // Wait for future to resolve
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that Text widget with error message is shown after future errors
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Error: Oops'), findsOneWidget);
  });
}
