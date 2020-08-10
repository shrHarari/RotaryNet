import 'package:flutter/material.dart';

class BubblesBoxDecoration extends StatelessWidget {

  final String aText;
  final Color bubbleColor;
  final bool isWithShadow;
  final bool isWithGradient;

  const BubblesBoxDecoration({Key key, this.bubbleColor, this.aText, this.isWithShadow, this.isWithGradient});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                boxShadow: [
                  isWithShadow ? BoxShadow(
                    blurRadius: 10.0,
                    offset: Offset(5, 5),
                    color: Colors.black54,
                  ) :
                  BoxShadow(
                    blurRadius: 0.0,
                    offset: Offset(0, 0),
                    color: bubbleColor,),
                ],
                gradient: isWithGradient ? LinearGradient(
                    colors: [
                      bubbleColor, Colors.blue[50]
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ) : LinearGradient(
                    colors: [
                      bubbleColor, bubbleColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
            ),
            child: Align(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(
                  buildTextSpan(aText),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: BubblesBoxDecorationPin(bubbleColor: bubbleColor),
            ),
          )
        ],
      ),
    );
  }

  TextSpan buildTextSpan(String aDescription){
    return TextSpan(
        style: TextStyle(fontSize: 14),
        children: [
          TextSpan(
              text: aDescription,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  //decorationStyle: TextDecorationStyle.wavy,
                  //decorationColor: Colors.red,
                  fontWeight: FontWeight.bold
              ))
        ]
    );
  }
}

// Draw the Bubble Pin
// The Pin location is set on positioning which call this function
class BubblesBoxDecorationPin extends CustomPainter {
  Color bubbleColor;
  BubblesBoxDecorationPin({this.bubbleColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = bubbleColor;

    var path = Path();
    path.lineTo(-10, 0);
    path.lineTo(0, -10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
}
