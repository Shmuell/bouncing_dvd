import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// https://twitter.com/creativemaybeno/status/1323082856898404352?s=20

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Stack(
        children: [
          SizedBox.square(
            dimension: 100,
            child: BouncingFlutterLogo(
              globalKey: GlobalKey(),
              dx: 10,
              dy: 10,
            ),
          ),
          BouncingFlutterLogo(
            globalKey: GlobalKey(),
            dx: 15,
            dy: 15,
          ),
          BouncingFlutterLogo(
            globalKey: GlobalKey(),
            dx: 20,
            dy: 20,
          ),
          BouncingFlutterLogo(
            globalKey: GlobalKey(),
            dx: 25,
            dy: 25,
          ),
        ],
      ),
    ),
  ));
}

class BouncingFlutterLogo extends StatefulWidget {
  const BouncingFlutterLogo({
    Key? key,
    required this.globalKey,
    required this.dx,
    required this.dy
  }) : super(key: key);

  final GlobalKey globalKey;
  final int dx;
  final int dy;
  @override
  _BouncingFlutterLogoState createState() => _BouncingFlutterLogoState();
}

class _BouncingFlutterLogoState extends State<BouncingFlutterLogo> {
  // final _logoKey = GlobalKey();
  late Timer _updateTimer;
  var _x = .0, _y = .0, _dx = 1, _dy = 1;
  var _color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scheduleUpdate();
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }



  void _update() {
    final availableSize = (context.findRenderObject() as RenderBox).constraints;
    final size = (widget.globalKey.currentContext?.findRenderObject() as RenderBox).size;

    final previousDx = _dx;
    final previousDy = _dy;
    if (availableSize.maxWidth < _x + (size.width + Random().nextInt(10))) {
      _dx = -1;
    } else if (_x < 0) {
      _dx = 1;
    }
    if (availableSize.maxHeight < _y + (size.height + Random().nextInt(10))) {
      _dy = -1;
    } else if (_y < 0) {
      _dy = 1;
    }
    if (previousDx != _dx || previousDy != _dy) {
      // final random = Random();
      // _color = Color.fromRGBO(random.nextInt(59) + 196,
      //     random.nextInt(59) + 196, random.nextInt(59) + 196, 1);
      _color = Colors.transparent;
    }

    setState(() {
      _x += _dx * 2;
      _y += _dy * 2;
    });
    _scheduleUpdate();
  }

  void _scheduleUpdate() {
    _updateTimer = Timer(
      // Lock the update rate, no matter the frame rate.
      const Duration(microseconds: 1e6 ~/ 60 ),
      _update,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: _color,
        child: Stack(
          children: [
            AnimatedPositioned(
              top: _y,
              left: _x,
              duration: const Duration(milliseconds: 100),
              child: Container(
                key: widget.globalKey,
                child: Text(widget.dx.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}