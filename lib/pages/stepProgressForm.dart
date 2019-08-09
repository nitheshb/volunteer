import 'package:flutter/material.dart';
import 'data.dart';
import 'page_indicator.dart';
import 'package:gradient_text/gradient_text.dart';



class StepProgressForm extends StatefulWidget {
  @override
  _StepProgressFormState createState() => new _StepProgressFormState();
}

class _StepProgressFormState extends State<StepProgressForm> with TickerProviderStateMixin {
  PageController _controller;
  int currentPage = 0;
  bool lastPage = false;
  String _name = '';
  AnimationController animationController;
  Animation<double> _scaleAnimation;
    final _formKey = GlobalKey<FormState>(); 
  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    return formWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (currentPage == pageList.length - 1) {
                    lastPage = true;
                    animationController.forward();
                  } else {
                    lastPage = false;
                    animationController.reset();
                  }
                  print(lastPage);
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    var page = pageList[index];
                    var delta;
                    var y = 1.0;

                    if (_controller.position.haveDimensions) {
                      delta = _controller.page - index;
                      y = 1 - delta.abs().clamp(0.0, 1.0);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(page.imageUrl),
                        Container(
                          margin: EdgeInsets.only(left: 12.0, top: 10.0),
                          height: 100.0,
                          child: Stack(
                            children: <Widget>[
                              Opacity(
                                opacity: .10,
                                child: GradientText(
                                  page.title,
                                  gradient: LinearGradient(
                                      colors: pageList[index].titleGradient),
                                  style: TextStyle(
                                      fontSize: 80.0,
                                      fontFamily: "Montserrat-Black",
                                      letterSpacing: 0.5),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30.0, left: 22.0),
                                child: GradientText(
                                  page.title,
                                  gradient: LinearGradient(
                                      colors: pageList[index].titleGradient),
                                  style: TextStyle(
                                    fontSize: 50.0,
                                    fontFamily: "Montserrat-Black",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 34.0,),
                          child: Transform(
                            transform:
                                Matrix4.translationValues(0, 50.0 * (1 - y), 0),
                            child: Text(
                              page.body,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Montserrat-Medium",
                                  color: Color(0xFF9B9B9B)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 34.0,),
                          child: Transform(
                            transform:
                                Matrix4.translationValues(0, 50.0 * (1 - y), 0),
                            
                
                              child: Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15.0,
                      spreadRadius: -5.0,
                      offset: Offset(0.0, 7.0)),
                ],
              ),
              width: 320.0,
              height: 420.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                child:  Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            TextFormField(
    decoration: InputDecoration(labelText: 'First name 11'),
),
          ],
        )),
              ),
              
                          ),
                          
                          
                        
                          )
                        )
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              left: 30.0,
              bottom: 55.0,
              child: Container(
                  width: 160.0,
                  child: PageIndicator(currentPage, pageList.length)),
            ),
            Positioned(
              right: 30.0,
              bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: lastPage
                    ? FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
