import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:managerpro/utilities/theme_helper.dart';

class Loader {
  static OverlayEntry overlayLoader(BuildContext context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Colors.white.withOpacity(0.5),
          child: LoadingAnimationWidget.inkDrop(
              color: ThemeHelper.primary, size: 60),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 500), () {
      loader.remove();
    });
  }
}
