import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_recorder/src/widget_recorder_controller.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

export 'package:widget_recorder/src/widget_recorder_controller.dart';
export 'package:widget_recorder/src/widget_recorder_periodic_controller.dart';
export 'package:widget_recorder/src/widget_recorder_simple_controller.dart';
export 'package:widget_recorder/src/widget_recorder_snapshot.dart';

/// A [Widget] that generates an image from a Widget following the provided schedule.
class WidgetRecorder extends StatefulWidget {
  WidgetRecorder({
    Key? key,
    required this.child,
    required this.controller,
    this.onSnapshotTaken,
    this.globalKey,
  }) : super(key: key);

  /// The [Widget] from where to get image.
  final Widget child;

  /// The [WidgetRecorderController] from where to get the snapshots.
  final WidgetRecorderController controller;

  final Function(WidgetRecorderSnapshot?)? onSnapshotTaken;
  final GlobalKey? globalKey;

  @override
  State<StatefulWidget> createState() => _WidgetRecorderState();
}

class _WidgetRecorderState extends State<WidgetRecorder> {
  late GlobalKey _globalKey;

  RenderObject? _renderObject;

  @override
  void initState() {
    super.initState();
    if (widget.globalKey != null) {
      _globalKey = widget.globalKey!;
    } else {
      _globalKey = GlobalKey();
    }
    widget.controller.setCallback(_getSnapshot);
  }

  @override
  void didUpdateWidget(WidgetRecorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.dispose();
      widget.controller.setCallback(_getSnapshot);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  Future<WidgetRecorderSnapshot?> _getSnapshot() async {
    RenderObject? renderObject = _getRepaintBoundary();
    WidgetRecorderSnapshot? snapshot;

    if (renderObject != null) {
      ByteData? byteData;
      try {
        RenderRepaintBoundary repaintBoundary =
            renderObject as RenderRepaintBoundary;
        Size widgetSize = repaintBoundary.size;
        // repaintBoundary.layer;

        final OffsetLayer offsetLayer = repaintBoundary.layer! as OffsetLayer;
        ui.Image image = await offsetLayer.toImage(
            Offset.zero & repaintBoundary.size,
            pixelRatio: widget.controller.pixelRatio);

        // ui.Image image = await repaintBoundary.toImage(
        //     pixelRatio: widget.controller.pixelRatio);
        byteData = await image.toByteData(format: widget.controller.byteFormat);

        if (widget.controller.scaleFactor != 1.0 && byteData != null) {
          // _base64 = await compute(encodeImage, _image);
          final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
              byteData.buffer.asUint8List(),
              targetWidth:
                  (widgetSize.width * widget.controller.scaleFactor).toInt(),
              targetHeight:
                  (widgetSize.height * widget.controller.scaleFactor).toInt());
          final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
          byteData = await frameInfo.image
              .toByteData(format: widget.controller.byteFormat);
        }

        if (byteData != null) {
          snapshot = WidgetRecorderSnapshot(
              widgetSize: widgetSize,
              pixelRatio: widget.controller.pixelRatio,
              scaleFactor: widget.controller.scaleFactor,
              byteFormat: widget.controller.byteFormat,
              byteData: byteData);

          widget.onSnapshotTaken?.call(snapshot);
        }
      } catch (e, stack) {}
    }

    return snapshot;
  }

  RenderObject? _getRepaintBoundary() {
    _renderObject = _globalKey.currentContext?.findRenderObject();

    return _renderObject;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: widget.child,
    );
  }
}
