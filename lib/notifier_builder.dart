import 'package:flutter/material.dart';

class NotifierBuilder<T extends Listenable> extends StatefulWidget {
  const NotifierBuilder({
    required this.notifier,
    required this.builder,
    super.key,
    this.child,
  });

  final T Function() notifier;

  final Widget Function(
    BuildContext context,
    Widget? child,
    T controller,
  ) builder;

  final Widget? child;

  @override
  State<NotifierBuilder> createState() => NotifierBuilderState<T>();
}

class NotifierBuilderState<T extends Listenable>
    extends State<NotifierBuilder<T>> {
  T? controller;

  @override
  void initState() {
    super.initState();
    controller ??= widget.notifier();
    controller?.addListener(_handleChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller ??= widget.notifier();
  }

  @override
  void dispose() {
    controller?.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.child, controller!);
}
