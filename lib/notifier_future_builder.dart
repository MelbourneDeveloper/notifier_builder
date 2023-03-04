import 'package:flutter/material.dart';

class NotifierFutureBuilder<T extends Listenable> extends StatefulWidget {
  const NotifierFutureBuilder({
    required this.future,
    required this.builder,
    required this.child,
    super.key,
  });

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
  void didUpdateWidget(NotifierFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.child, _snapshot);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    // ignore: discarded_futures
    widget.future().then<void>(
      (data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withData(ConnectionState.done, data);
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
  }
}
