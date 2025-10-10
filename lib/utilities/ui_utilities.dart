
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sedefwpwebapp/utilities/ui_functions.dart';


TextStyle fixedTextStyle(
    {double fontSize = 15, String fontFamily = "Inter", int fontWeight = 500, int? colorCode ,bool underline = false,bool lineThrough = false}) {
  // Parametrik Textstyle
  TextStyle style = TextStyle(
     decoration: underline ? TextDecoration.underline :lineThrough ? TextDecoration.lineThrough :TextDecoration.none,
      fontSize: fontSize,
      fontFamily: fontFamily,
      
      fontWeight: fontWeight == 100
          ? FontWeight.w100
          : fontWeight == 200
              ? FontWeight.w200
              : fontWeight == 300
                  ? FontWeight.w300
                  : fontWeight == 400
                      ? FontWeight.w400
                      : fontWeight == 500
                          ? FontWeight.w500
                          : fontWeight == 600
                              ? FontWeight.w600
                              : fontWeight == 700
                                  ? FontWeight.w700
                                  : fontWeight == 800
                                      ? FontWeight.w800
                                      : FontWeight.w900,
      color:colorCode == null ?  Colors.black : Color(colorCode));
  return style;
}

Color stringToColor(String color){
  return Color(int.parse("0x${color.substring(1)}"));
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget background(){
  return Stack(alignment: Alignment.center,children: [
     Image.asset("assets/images/bg.png"),
    Image.asset("assets/images/bg_pattern.png"),
  ],);
}

Future<void>? pushToPage(Widget page,WidgetRef ref, BuildContext context, {bool hasText = false}) {
  return Navigator.push(
    context,
    FadeRoute(
      page:customProgressHUD(context,ref, page, hasText: hasText),
    ),
  );
}
Future<void>? pushTopushReplacement(Widget page,WidgetRef ref, BuildContext context) {
  Navigator.pushReplacement(
      context,
      FadeRoute(
        page: customProgressHUD(context, ref, page),
      ));
  return null;
}
void popToPage(BuildContext context) {
  return Navigator.pop(context);
}

Future<void>? pushToPageAndRemoveUntil(Widget page, BuildContext context) {
  Navigator.pushAndRemoveUntil(
      context,
      FadeRoute(
        page: page,
      ),
      (route) => false);

  return null;
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
