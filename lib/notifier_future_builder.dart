import 'package:flutter/material.dart';

//According to ChatGPT: there are no obvious potential bugs with
//NotifierFutureBuilder

class NotifierFutureBuilder<T extends Listenable> extends StatefulWidget {
  const NotifierFutureBuilder({
    required this.future,
    required this.builder,
    this.child,
    super.key,
  });

  ///Set this to a fixed function. The widget will only call this once
  final Future<T> Function() future;

  final Widget Function(
    BuildContext context,
    Widget? child,
    AsyncSnapshot<T> notifier,
  ) builder;

  final Widget? child;

  @override
  State<NotifierFutureBuilder<T>> createState() =>
      _NotifierFutureBuilderState<T>();
}

class _NotifierFutureBuilderState<T extends Listenable>
    extends State<NotifierFutureBuilder<T>> {
  Object? _activeCallbackIdentity;
  late AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = AsyncSnapshot<T>.nothing();
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => widget.builder(context, widget.child, _snapshot),
      );

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _handleChange() => setState(() {});

  void _subscribe() {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    // ignore: discarded_futures
    widget.future().then<void>(
      (data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
            _snapshot.data!.addListener(_handleChange);
          });
        }
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withError(
              ConnectionState.done,
              error,
              stackTrace,
            );
          });
        }
      },
    );

    if (_snapshot.connectionState != ConnectionState.done) {
      _snapshot = _snapshot.inState(ConnectionState.waiting);
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
    if (_snapshot.connectionState == ConnectionState.done &&
        _snapshot.data != null) {
      _snapshot.data!.removeListener(_handleChange);
    }
  }
}
