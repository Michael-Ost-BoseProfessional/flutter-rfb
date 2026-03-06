import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_rfb/src/remote_frame_buffer_isolate_messages.dart';
import 'package:fpdart/fpdart.dart';

class RemoteFrameBufferGestureDetector extends StatelessWidget {
  final Image _image;
  final Option<SendPort> _sendPort;

  const RemoteFrameBufferGestureDetector({
    super.key,
    required final Image image,
    required final Option<SendPort> sendPort,
  })  : _image = image,
        _sendPort = sendPort;

  @override
  Widget build(final BuildContext context) {
    void send(final RemoteFrameBufferIsolateSendMessage message) =>
        _sendPort.match(() {}, (final SendPort sendPort) => sendPort.send(message));

    Point<int> coords(final Offset pos) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      return Point<int>(
        (pos.dx / box.size.width  * _image.width ).toInt(),
        (pos.dy / box.size.height * _image.height).toInt(),
      );
    }

    return GestureDetector(
      onSecondaryTapDown: (final TapDownDetails details) {
        Focus.of(context).requestFocus();
        final Point<int> p = coords(details.localPosition);
        send(RemoteFrameBufferIsolateSendMessage.pointerEvent(
          button1Down: false,
          button2Down: false,
          button3Down: true,
          button4Down: false,
          button5Down: false,
          button6Down: false,
          button7Down: false,
          button8Down: false,
          x: p.x,
          y: p.y,
        ));
      },
      onSecondaryTapUp: (final TapUpDetails details) {
        final Point<int> p = coords(details.localPosition);
        send(RemoteFrameBufferIsolateSendMessage.pointerEvent(
          button1Down: false,
          button2Down: false,
          button3Down: false,
          button4Down: false,
          button5Down: false,
          button6Down: false,
          button7Down: false,
          button8Down: false,
          x: p.x,
          y: p.y,
        ));
      },
      onTapDown: (final TapDownDetails details) {
        Focus.of(context).requestFocus();
        final Point<int> p = coords(details.localPosition);
        send(RemoteFrameBufferIsolateSendMessage.pointerEvent(
          button1Down: true,
          button2Down: false,
          button3Down: false,
          button4Down: false,
          button5Down: false,
          button6Down: false,
          button7Down: false,
          button8Down: false,
          x: p.x,
          y: p.y,
        ));
      },
      onTapUp: (final TapUpDetails details) {
        final Point<int> p = coords(details.localPosition);
        send(RemoteFrameBufferIsolateSendMessage.pointerEvent(
          button1Down: false,
          button2Down: false,
          button3Down: false,
          button4Down: false,
          button5Down: false,
          button6Down: false,
          button7Down: false,
          button8Down: false,
          x: p.x,
          y: p.y,
        ));
      },
      child: RawImage(image: _image),
    );
  }
}
