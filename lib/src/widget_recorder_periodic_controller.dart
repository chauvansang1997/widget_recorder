import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:widget_recorder/src/widget_recorder_controller.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

class WidgetRecorderPeriodicController extends WidgetRecorderController {
  final Duration delay;
  final Function(WidgetRecorderSnapshot)? onSnapshotReady;

  Timer? _timer;
  bool pause;
  late Completer _newFrameAvailable;

  final ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();

  WidgetRecorderPeriodicController(
      {double pixelRatio = 1.0,
      double scaleFactor = 1.0,
      ImageByteFormat byteFormat = ImageByteFormat.png,
      this.delay = const Duration(seconds: 1),
      this.pause = false,
      this.onSnapshotReady})
      : super(
            pixelRatio: pixelRatio,
            scaleFactor: scaleFactor,
            byteFormat: byteFormat);

  @override
  void setCallback(SnapshotCallback callback) {
    super.setCallback(callback);
    //
    //start();
  }

  @override
  void dispose() {
    super.dispose();
    //
    stop();
  }

  void start() {
    if (_timer == null) {
      _timer = Timer.periodic(delay, _takeSnapshot);
    }
  }

  void requestFrame() {
    notifyListeners();
  }

  void newFrameReady() {
    if (!_newFrameAvailable.isCompleted) {
      _newFrameAvailable.complete();
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _takeSnapshot(Timer timer) async {
    if (!pause) {
      // print('wait');
      requestFrame();
      _newFrameAvailable = Completer();
      await _newFrameAvailable.future;
      WidgetRecorderSnapshot? snapshot = await this.getSnapshot?.call();
      // print('data');
      if (this.onSnapshotReady != null && snapshot != null) {
        onSnapshotReady?.call(snapshot);
      }
    }
  }

  /// Calls the listener every time a new frame is requested.
  ///
  /// Listeners can be removed with [removeListener].
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Stop calling the listener every time a new frame is requested.
  ///
  /// Listeners can be added with [addListener].
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Calls all the listeners.
  ///
  /// If listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void notifyListeners() {
    final List<VoidCallback> localListeners =
        List<VoidCallback>.from(_listeners);
    for (final VoidCallback listener in localListeners) {
      // InformationCollector collector;
      try {
        if (_listeners.contains(listener)) listener();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          context:
              ErrorDescription('while notifying listeners for $runtimeType'),
          // informationCollector: collector,
        ));
      }
    }
  }
}
