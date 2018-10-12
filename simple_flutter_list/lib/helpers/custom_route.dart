import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Do not play an animation for the very first page we see
    if (settings.isInitialRoute) {
      return child;
    }

    return FadeTransition(opacity: animation, child: child);
  }
}
