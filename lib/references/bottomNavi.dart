import 'package:flutter/material.dart';
import 'package:quarry/styles/app_theme.dart';

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 60,
              color: Colors.white,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 60),
                    painter: RPSCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.5,
                    child: FloatingActionButton(backgroundColor: Colors.orange, child: Icon(Icons.shopping_basket), elevation: 0.1, onPressed: () {}),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.restaurant_menu,
                              color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = AppTheme.gridTextColor
      ..style = PaintingStyle.stroke
    ;

    Path path = Path();
    path.moveTo(0, 0); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(
        Offset(size.width * 0.60, 20), radius: Radius.circular(20.0),
        clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
/*    canvas.drawShadow(path, Colors.black, 5, true);*/
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.7519167,size.height*0.05466667);
    path_0.lineTo(size.width*0.7519167,size.height*0.05466667);
    path_0.cubicTo(size.width*0.6884167,size.height*0.05466667,size.width*0.6562222,size.height*0.2845000,size.width*0.6251111,size.height*0.5065000);
    path_0.cubicTo(size.width*0.5943056,size.height*0.7263333,size.width*0.5624444,size.height*0.9538333,size.width*0.4999444,size.height*0.9538333);
    path_0.cubicTo(size.width*0.4374444,size.height*0.9538333,size.width*0.4055833,size.height*0.7265000,size.width*0.3747778,size.height*0.5065000);
    path_0.cubicTo(size.width*0.3436667,size.height*0.2845000,size.width*0.3115000,size.height*0.05500000,size.width*0.2481111,size.height*0.05466667);
    path_0.lineTo(size.width*0.2481111,size.height*0.05466667);
    path_0.lineTo(0,size.height*0.05466667);
    path_0.lineTo(0,size.height*0.06766667);
    path_0.lineTo(size.width*0.2480833,size.height*0.06766667);
    path_0.lineTo(size.width*0.2480833,size.height*0.06766667);
    path_0.cubicTo(size.width*0.3105000,size.height*0.06800000,size.width*0.3423333,size.height*0.2951667,size.width*0.3731111,size.height*0.5150000);
    path_0.cubicTo(size.width*0.4042500,size.height*0.7370000,size.width*0.4364444,size.height*0.9666667,size.width*0.4999444,size.height*0.9666667);
    path_0.cubicTo(size.width*0.5634444,size.height*0.9666667,size.width*0.5956389,size.height*0.7370000,size.width*0.6267500,size.height*0.5148333);
    path_0.cubicTo(size.width*0.6575556,size.height*0.2950000,size.width*0.6894167,size.height*0.06750000,size.width*0.7519167,size.height*0.06750000);
    path_0.lineTo(size.width*0.7519167,size.height*0.06750000);
    path_0.lineTo(size.width,size.height*0.06750000);
    path_0.lineTo(size.width,size.height*0.05466667);
    path_0.lineTo(size.width*0.7519167,size.height*0.05466667);
    path_0.close();

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xff697B8C).withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class RPSCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.7519444,size.height*0.04333333);
    path_0.lineTo(size.width*0.7519444,size.height*0.04333333);
    path_0.cubicTo(size.width*0.6883333,size.height*0.04333333,size.width*0.6563889,size.height*0.2733333,size.width*0.6252778,size.height*0.4950000);
    path_0.cubicTo(size.width*0.5944444,size.height*0.7150000,size.width*0.5625000,size.height*0.9433333,size.width*0.5000000,size.height*0.9433333);
    path_0.cubicTo(size.width*0.4375000,size.height*0.9433333,size.width*0.4055556,size.height*0.7166667,size.width*0.3747222,size.height*0.4966667);
    path_0.cubicTo(size.width*0.3436111,size.height*0.2733333,size.width*0.3113889,size.height*0.04500000,size.width*0.2480556,size.height*0.04333333);
    path_0.lineTo(size.width*0.2480556,size.height*0.04333333);
    path_0.lineTo(0,size.height*0.04333333);
    path_0.lineTo(0,size.height*0.05666667);
    path_0.lineTo(size.width*0.2480556,size.height*0.05666667);
    path_0.lineTo(size.width*0.2480556,size.height*0.05666667);
    path_0.cubicTo(size.width*0.3105556,size.height*0.05666667,size.width*0.3422222,size.height*0.2850000,size.width*0.3730556,size.height*0.5033333);
    path_0.cubicTo(size.width*0.4041667,size.height*0.7250000,size.width*0.4363889,size.height*0.9550000,size.width*0.5000000,size.height*0.9550000);
    path_0.cubicTo(size.width*0.5636111,size.height*0.9550000,size.width*0.5955556,size.height*0.7250000,size.width*0.6269444,size.height*0.5033333);
    path_0.cubicTo(size.width*0.6577778,size.height*0.2833333,size.width*0.6897222,size.height*0.05666667,size.width*0.7522222,size.height*0.05666667);
    path_0.lineTo(size.width*0.7522222,size.height*0.05666667);
    path_0.lineTo(size.width,size.height*0.05666667);
    path_0.lineTo(size.width,size.height*0.04333333);
    path_0.lineTo(size.width*0.7519444,size.height*0.04333333);
    path_0.close();

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xff697B8C).withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width*0.6266667,size.height*0.5050000);
    path_1.cubicTo(size.width*0.5955556,size.height*0.7266667,size.width*0.5633333,size.height*0.9566667,size.width*0.5000000,size.height*0.9566667);
    path_1.cubicTo(size.width*0.4363889,size.height*0.9566667,size.width*0.4041667,size.height*0.7266667,size.width*0.3730556,size.height*0.5050000);
    path_1.cubicTo(size.width*0.3422222,size.height*0.2850000,size.width*0.3105556,size.height*0.05833333,size.width*0.2480556,size.height*0.05833333);
    path_1.lineTo(0,size.height*0.05833333);
    path_1.lineTo(0,size.height);
    path_1.lineTo(size.width,size.height);
    path_1.lineTo(size.width,size.height*0.05666667);
    path_1.lineTo(size.width*0.7519444,size.height*0.05666667);
    path_1.cubicTo(size.width*0.6894444,size.height*0.05666667,size.width*0.6575000,size.height*0.2850000,size.width*0.6266667,size.height*0.5050000);
    path_1.close();

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class RPSCustomPainter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.7522222,size.height*0.1546392);
    path_0.lineTo(size.width*0.7522222,size.height*0.1546392);
    path_0.cubicTo(size.width*0.6886111,size.height*0.1546392,size.width*0.6563889,size.height*0.3578792,size.width*0.6252778,size.height*0.5537555);
    path_0.cubicTo(size.width*0.5944444,size.height*0.7481591,size.width*0.5625000,size.height*0.9484536,size.width*0.5000000,size.height*0.9484536);
    path_0.cubicTo(size.width*0.4375000,size.height*0.9484536,size.width*0.4055556,size.height*0.7481591,size.width*0.3747222,size.height*0.5537555);
    path_0.cubicTo(size.width*0.3436111,size.height*0.3578792,size.width*0.3113889,size.height*0.1546392,size.width*0.2480556,size.height*0.1546392);
    path_0.lineTo(size.width*0.2480556,size.height*0.1546392);
    path_0.lineTo(size.width*0.0002777778,size.height*0.1546392);
    path_0.lineTo(size.width*0.0002777778,size.height*0.1664212);
    path_0.lineTo(size.width*0.2483333,size.height*0.1664212);
    path_0.lineTo(size.width*0.2483333,size.height*0.1664212);
    path_0.cubicTo(size.width*0.3108333,size.height*0.1664212,size.width*0.3425000,size.height*0.3681885,size.width*0.3733333,size.height*0.5611193);
    path_0.cubicTo(size.width*0.4044444,size.height*0.7569956,size.width*0.4366667,size.height*0.9602356,size.width*0.5002778,size.height*0.9602356);
    path_0.cubicTo(size.width*0.5638889,size.height*0.9602356,size.width*0.5958333,size.height*0.7569956,size.width*0.6272222,size.height*0.5611193);
    path_0.cubicTo(size.width*0.6580556,size.height*0.3667158,size.width*0.6900000,size.height*0.1664212,size.width*0.7525000,size.height*0.1664212);
    path_0.lineTo(size.width*0.7525000,size.height*0.1664212);
    path_0.lineTo(size.width*1.000556,size.height*0.1664212);
    path_0.lineTo(size.width*1.000556,size.height*0.1546392);
    path_0.lineTo(size.width*0.7522222,size.height*0.1546392);
    path_0.close();

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = Color(0xff697B8C).withOpacity(1.0);
    canvas.drawPath(path_0,paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width*0.6269444,size.height*0.5611193);
    path_1.cubicTo(size.width*0.5958333,size.height*0.7569956,size.width*0.5636111,size.height*0.9602356,size.width*0.5002778,size.height*0.9602356);
    path_1.cubicTo(size.width*0.4366667,size.height*0.9602356,size.width*0.4044444,size.height*0.7569956,size.width*0.3733333,size.height*0.5611193);
    path_1.cubicTo(size.width*0.3425000,size.height*0.3667158,size.width*0.3108333,size.height*0.1664212,size.width*0.2483333,size.height*0.1664212);
    path_1.lineTo(size.width*0.0002777778,size.height*0.1664212);
    path_1.lineTo(size.width*0.0002777778,size.height);
    path_1.lineTo(size.width*1.000278,size.height);
    path_1.lineTo(size.width*1.000278,size.height*0.1664212);
    path_1.lineTo(size.width*0.7522222,size.height*0.1664212);
    path_1.cubicTo(size.width*0.6897222,size.height*0.1664212,size.width*0.6577778,size.height*0.3681885,size.width*0.6269444,size.height*0.5611193);
    path_1.close();

    Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_1,paint_1_fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}