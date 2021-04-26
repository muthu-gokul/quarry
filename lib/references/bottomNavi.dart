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