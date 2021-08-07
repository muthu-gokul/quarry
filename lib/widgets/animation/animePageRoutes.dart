import 'package:flutter/material.dart';

Route fadeRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    //pageBuilder: (context, animation, secondaryAnimation) => QuaryAddNew(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
        child: child,
      );
    },
  );
}

Route rightLeftRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}