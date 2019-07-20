import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;


class LeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leader View',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Leader View'),
        ),
        body: _getStatsUi(context)
      ),
    );
  }

    Widget _getStatsUi(BuildContext context) {
    return Column(children: [
        _getHeightContainer(
          context: context,
          height: 250,
          child: StatsCount(150, 4, 'Esclated Issues'),
        ),
         _getHeightContainer(
          context: context,
          height:250,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StatsCount(150, 99, 'Ward Level View '),
               StatsCount(150, 2, 'On Going Works'),
          ])
         ),
    ]);
  }
    Widget StatsCount(double size,count, title) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0), color: Colors.grey),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size  *0.6, fontWeight: FontWeight.w800)),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size * 0.1, fontWeight: FontWeight.w400))
          ]),
    );
  }

  Widget _getHeightContainer(
      {double height,
      BuildContext context,
      Widget child,
      bool hasTopStroke = false}) {
    return Container(
        height: height,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        // decoration: hasTopStroke? topLineBorderDecoration : null,
        child: child);
  }
}

class ScratchCard extends StatefulWidget {
  const ScratchCard({
    Key key,
    this.cover,
    this.reveal,
    this.strokeWidth = 25.0,
    this.finishPercent,
    this.onComplete,
  }) : super(key: key);

  final Widget cover;
  final Widget reveal;
  final double strokeWidth;
  final int finishPercent;
  final VoidCallback onComplete;

  @override
  _ScratchCardState createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  _ScratchData _data = _ScratchData();

  Offset _lastPoint = null;

  Offset _globalToLocal(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }

  double _distanceBetween(Offset point1, Offset point2) {
    return math.sqrt(math.pow(point2.dx - point1.dx, 2) + math.pow(point2.dy - point1.dy, 2));
  }

  double _angleBetween(Offset point1, Offset point2) {
    return math.atan2(point2.dx - point1.dx, point2.dy - point1.dy);
  }

  void _onPanDown(DragDownDetails details) {
    _lastPoint = _globalToLocal(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currentPoint = _globalToLocal(details.globalPosition);
    final distance = _distanceBetween(_lastPoint, currentPoint);
    final angle = _angleBetween(_lastPoint, currentPoint);
    for (double i = 0.0; i < distance; i++) {
      _data.addPoint(Offset(
        _lastPoint.dx + (math.sin(angle) * i),
        _lastPoint.dy + (math.cos(angle) * i),
      ));
    }
    _lastPoint = currentPoint;
  }

  void _onPanEnd(TapUpDetails details) {
    final areaRect = context.size.width * context.size.height;
    double touchArea = math.pi * widget.strokeWidth * widget.strokeWidth;
    double areaRevealed = _data._points.fold(0.0, (double prev, Offset point) => touchArea);
    print('areaRect $areaRect $areaRevealed');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onTapUp: _onPanEnd,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.reveal,
          _ScratchCardLayout(
            strokeWidth: widget.strokeWidth,
            data: _data,
            child: widget.cover,
          ),
        ],
      ),
    );
  }
}

class _ScratchCardLayout extends SingleChildRenderObjectWidget {
  _ScratchCardLayout({
    Key key,
    this.strokeWidth = 25.0,
    @required this.data,
    @required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final double strokeWidth;
  final _ScratchData data;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ScratchCardRender(
      strokeWidth: strokeWidth,
      data: data,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _ScratchCardRender renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..data = data;
  }
}

class _ScratchCardRender extends RenderProxyBox {
  _ScratchCardRender({
    RenderBox child,
    double strokeWidth,
    _ScratchData data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child);

  double _strokeWidth;
  _ScratchData _data;

  set strokeWidth(double strokeWidth) {
    assert(strokeWidth != null);
    if (_strokeWidth == strokeWidth) {
      return;
    }
    _strokeWidth = strokeWidth;
    markNeedsPaint();
  }

  set data(_ScratchData data) {
    assert(data != null);
    if (_data == data) {
      return;
    }
    if (attached) {
      _data.removeListener(markNeedsPaint);
      data.addListener(markNeedsPaint);
    }
    _data = data;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _data.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _data.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);
      Paint clear = Paint()..blendMode = BlendMode.clear;
      _data._points.forEach((point) => context.canvas.drawCircle(offset + point, _strokeWidth, clear));
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}

class _ScratchData extends ChangeNotifier {
  List<Offset> _points = [];

  void addPoint(Offset offset) {
    _points.add(offset);
    notifyListeners();
  }
}