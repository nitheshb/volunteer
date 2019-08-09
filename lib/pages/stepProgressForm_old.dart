// 

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class StepProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: const Scaffold(
        body: const MobileStepper(
          steps: const <Widget> [
            const Text('Step 1'),
            const Text('Step 2'),
            const Text('Step 3'),
          ],
        )
      )
    );
  }
}

class MobileStepper extends StatefulWidget {
  final List<Widget> steps;
  
  const MobileStepper({this.steps});

  @override
  State createState() => new MobileStepperState();
}

class MobileStepperState extends State<MobileStepper> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: new TabBarView(
            children: widget.steps,
            controller: _controller,
          ),
        ),
        new Row(
          children: <Widget> [
            new FlatButton(
              child: new Row(
                children: <Widget> [
                  new Icon(Icons.chevron_left),
                  new Text('BACK'),
                ],
              ),
              onPressed: _controller.index > 0
                ?  () { _controller.animateTo(_controller.index - 1); }
                : null
            ),
            new Expanded(
              child: new Center(
                child: new TabPageSelector(controller: _controller),
              ),
            ),
            new FlatButton(
              child: new Row(
                children: <Widget> [
                  new Text('NEXT'),
                  new Icon(Icons.chevron_right),
                ],
              ),
              onPressed: _controller.index < _controller.length - 1
                ? () { _controller.animateTo(_controller.index + 1); }
                : null
            ),
          ]
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: widget.steps.length, vsync: this);
    _controller.addListener(() { setState(() {}); });
  }
}

// import 'package:flutter/material.dart';



// class StepProgressForm extends StatefulWidget {
//   @override
//   _StepProgressFormState createState() => _StepProgressFormState();
// }

// class _StepProgressFormState extends State<StepProgressForm> {
//   PageController _pageController = new PageController(initialPage: 0);

//   final _stepsText = ["About you", "Some more..", "Your credit card details"];

//   final _stepCircleRadius = 10.0;

//   final _stepProgressViewHeight = 150.0;

//   Color _activeColor = Colors.lightBlue;

//   Color _inactiveColor = Colors.grey;

//   TextStyle _headerStyle =
//       TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

//   TextStyle _stepStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);

//   Size _safeAreaSize;

//   int _curPage = 1;

//   ProgressPageIndicator _getStepProgress() {
//     return ProgressPageIndicator(
//       _stepsText,
//       _curPage,
//       _stepProgressViewHeight,
//       _safeAreaSize.width,
//       _stepCircleRadius,
//       _activeColor,
//       _inactiveColor,
//       _headerStyle,
//       _stepStyle,
//       decoration: BoxDecoration(color: Colors.white),
//       padding: EdgeInsets.only(
//         top: 48.0,
//         left: 24.0,
//         right: 24.0,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQD = MediaQuery.of(context);
//     _safeAreaSize = mediaQD.size;
//     return Scaffold(
//         body: Column(
//       children: <Widget>[
//         Container(height: 150.0, child: _getStepProgress()),
//         Expanded(
//           child: PageView(
//           onPageChanged: (i) {
//             setState(() {
//               _curPage = i + 1;
//             });
//           },
//           children: <Widget>[
//           Container(
//             color: Colors.greenAccent,
//             child: Center(
//               child: Text("Page 1"),
//             ),
//           ),
//           Container(
//             color: Colors.blueAccent,
//             child: Center(
//               child: Text("Page 2"),
//             ),
//           ),
//           Container(
//             color: Colors.amberAccent,
//             child: Center(
//               child: Text("Page 3"),
//             ),
//           ),
//           Container(
//             color: Colors.purpleAccent,
//             child: Center(
//               child: Text("Page 4"),
//             ),
//           ),
//         ],
//         ),
//         )
//       ],
//     ));
//   }
// }

// class ProgressPageIndicator extends AnimatedWidget {
 



//   // var height;

//   // final num height;

// //height of the container
// final double _height;
// //width of the container
// final double _width;
// //container decoration
// final BoxDecoration decoration;
// //list of texts to be shown for each step
// final List<String> _stepsText;
// //cur step identifier
// final int _curStep;
// //active color
// final Color _activeColor;
// //in-active color
// final Color _inactiveColor;
// //dot radius
// final double _dotRadius;
// //container padding
// final EdgeInsets padding;
// //line height
// final double lineHeight;
// //header textstyle
// final TextStyle _headerStyle;
// //steps text
// final TextStyle _stepStyle;

//   ProgressPageIndicator(
//     List<String> stepsText,
//     int curStep,
//     double height,
//     double width,
//     double dotRadius,
//     Color activeColor,
//     Color inactiveColor, 
//     TextStyle headerStyle,
//     TextStyle stepsStyle,
//     {
//     Key key,Animation<double> animation,
//     this.decoration, 
//     this.padding,
//     this.lineHeight = 2.0,
//   })  : _stepsText = stepsText,
//         _curStep = curStep,
//         _height = height,
//         _width = width,
//         _dotRadius = dotRadius,
//         _activeColor = activeColor,
//         _inactiveColor = inactiveColor,
//         _headerStyle = headerStyle,
//         _stepStyle = stepsStyle,
//         assert(curStep > 0 == true && curStep <= stepsText.length),
//         assert(width > 0),
//         assert(height >= 2 * dotRadius),
//         assert(width >= dotRadius * 2 * stepsText.length),
//         super(key: key, listenable: animation);



// List<Widget> _buildDots() {
//     var wids = <Widget>[];
//     _stepsText.asMap().forEach((i, text) {
//       var circleColor = (i == 0 || _curStep > i + 1)
//                         ? _activeColor
//                         : _inactiveColor;
      
//       var lineColor = _curStep > i + 1
//                       ? _activeColor
//                       : _inactiveColor;

//       wids.add(CircleAvatar(
//         radius: _dotRadius,
//         backgroundColor: circleColor,
//       ));
      
//       //add a line separator
//       //0-------0--------0
//       if (i != _stepsText.length - 1) {        
//         wids.add(
//           Expanded(
//             child: Container(height: lineHeight, color: lineColor,)
//           )
//         );
//       }
//     });

//     return wids;
//   }

// List<Widget> _buildText() {
//     var wids = <Widget>[];
//     _stepsText.asMap().forEach((i, text) {
      
//       wids.add(Text(text, style: _stepStyle));
//     });

//     return wids;
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = listenable;
//     return Container(
//         padding: padding,
//         height: this._height,
//         width: animation.value,
//         decoration: this.decoration,
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Center(
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: (_curStep).toString(),
//                         style: _headerStyle.copyWith(
//                           color: _activeColor,//this is always going to be active
//                         ),
//                       ),
//                       TextSpan(
//                         text: " / " + _stepsText.length.toString(),
//                         style: _headerStyle.copyWith(
//                           color: _curStep == _stepsText.length
//                           ? _activeColor
//                           : _inactiveColor,
//                         ),
//                       ),
//                     ]
//                   )
//                 )
//               )
//             ),
//             Row(
//               children: _buildDots(),
//             ),
//             SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: _buildText(),
//             )
//           ],
//         ));
//   }
// }
