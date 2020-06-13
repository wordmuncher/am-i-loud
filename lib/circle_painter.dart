import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mic_stream/mic_stream.dart';
import 'dart:math';

final AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

class CirclePainter extends CustomPainter {
  List<int> samples;
  List<Offset> points;
  Color color;
  BuildContext context;
  Size size;

  // Set max val possible in stream, depending on the config
  final int absMax =
      (AUDIO_FORMAT == AudioFormat.ENCODING_PCM_8BIT) ? 127 : 32767;

  CirclePainter(this.samples, this.color, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = context.size;
    size = this.size;

    Paint paint = new Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    points = toPoints(samples);

    Path path = new Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => true;

  // Maps a list of ints and their indices to a list of points on a cartesian grid
  List<Offset> toPoints(List<int> samples) {
    List<Offset> points = [];
    if (samples == null) samples = List<int>.filled(1280, 0);
    for (int i = 0; i < samples.length; i++) {
      points.add(new Offset.fromDirection(
          (samples.length.toDouble() - i.toDouble()) *
                  pi /
                  samples.length.toDouble() -
              pi / 2,
          project(samples[i], absMax, 100)));
    }
    for (int i = 0; i < samples.length; i++) {
      points.add(new Offset.fromDirection(
          -0.5 * pi -
              (samples.length.toDouble() - i.toDouble()) *
                  pi /
                  samples.length.toDouble(),
          project(samples[i], absMax, 100)));
    }
    return points;
  }

  double project(int val, int max, double height) {
    double waveRadius =
        (max == 0) ? val.toDouble() : 3 * (val.abs() / max) * height + 80;
    return waveRadius;
  }
}
