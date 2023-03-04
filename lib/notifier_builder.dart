import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///👷🏽 A Builder for any Listenable notifier/controller
class NotifierBuilder<T extends Listenable> extends StatefulWidget {
  ///Constructs a [NotifierBuilder]
  const NotifierBuilder({
    required this.notifier,
    required this.builder,
    super.key,
    this.child,
  });

  ///🔔The Builder calls this when it needs a new notifier. That will only
  ///happen once
  final T Function() notifier;

  ///🏗️ The Builder calls this when it needs to build the widget tree. You can
  ///access the notifier and its state here
  final Widget Function(
    BuildContext context,
    Widget? child,
    T notifier,
  ) builder;

  ///👶🏽 This is entirely optional. You can use this prebuilt Widget in the
  ///builder to improve performance, but you don't need to
  final Widget? child;

  @override
  State<NotifierBuilder> createState() => NotifierBuilderState<T>();
}

///This exposes the state of the [NotifierBuilder]. You can access the notifier
///in widget tests to verify the state
class NotifierBuilderState<T extends Listenable>
    extends State<NotifierBuilder<T>> {
  ///The notifier that was created by the [NotifierBuilder.notifier] function
  late final T notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.notifier();
    notifier.addListener(_handleChange);
  }

  @override
  void dispose() {
    notifier.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() => setState(() {});

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => widget.builder(context, widget.child, notifier),
      );

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('notifier', notifier));
  }
  // coverage:ignore-end
}
