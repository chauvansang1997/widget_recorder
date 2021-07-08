import 'dart:typed_data';
import 'dart:ui';

class WidgetRecorderSnapshot {
  WidgetRecorderSnapshot({
    required this.widgetSize,
    required this.pixelRatio,
    required this.scaleFactor,
    required this.byteFormat,
    required this.byteData,
  });

  final Size widgetSize;
  final double pixelRatio;
  final double scaleFactor;
  final ImageByteFormat byteFormat;
  final ByteData byteData;
}
