import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DiagonallyCatColoredImage extends StatelessWidget {
  final Image image;
  final Color color;

  DiagonallyCatColoredImage(this.image, {@required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DiagonalClipper(),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(color: color),
        child: image,
      ),
    );
  }

}

class DiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {   
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height - 50)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}