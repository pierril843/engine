// @dart = 2.6
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'dart:ui';

void main() {}

@pragma('vm:entry-point')
void createVertices() {
  const int uint16max = 65535;

  final Int32List colors = Int32List(uint16max);
  final Float32List coords = Float32List(uint16max * 2);
  final Uint16List indices = Uint16List(uint16max);
  final Float32List positions = Float32List(uint16max * 2);
  colors[0] = const Color(0xFFFF0000).value;
  colors[1] = const Color(0xFF00FF00).value;
  colors[2] = const Color(0xFF0000FF).value;
  colors[3] = const Color(0xFF00FFFF).value;
  indices[1] = indices[3] = 1;
  indices[2] = indices[5] = 3;
  indices[4] = 2;
  positions[2] = positions[4] = positions[5] = positions[7] = 250.0;

  final Vertices vertices = Vertices.raw(
    VertexMode.triangles,
    positions,
    textureCoordinates: coords,
    colors: colors,
    indices: indices,
  );
  _validateVertices(vertices);
}
void _validateVertices(Vertices vertices) native 'ValidateVertices';

@pragma('vm:entry-point')
void frameCallback(FrameInfo info) {
  print('called back');
}

@pragma('vm:entry-point')
void messageCallback(dynamic data) {
}


// Draw a circle on a Canvas that has a PictureRecorder. Take the image from
// the PictureRecorder, and encode it as png. Check that the png data is
// backed by an external Uint8List.
@pragma('vm:entry-point')
Future<void> encodeImageProducesExternalUint8List() async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()
    ..color = Color.fromRGBO(255, 255, 255, 1.0)
    ..style = PaintingStyle.fill;
  final Offset c = Offset(50.0, 50.0);
  canvas.drawCircle(c, 25.0, paint);
  final Picture picture = pictureRecorder.endRecording();
  final Image image = await picture.toImage(100, 100);
  _encodeImage(image, ImageByteFormat.png.index, _validateExternal);
}
void _encodeImage(Image i, int format, void Function(Uint8List result))
  native 'EncodeImage';
void _validateExternal(Uint8List result) native 'ValidateExternal';
