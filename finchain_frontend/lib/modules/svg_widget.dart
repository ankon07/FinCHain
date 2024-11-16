import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String imageUrl;
  final String? label;
  final double width;
  final double height;

  const SvgWidget({
    super.key,
    this.label,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imageUrl,
      semanticsLabel: label,
      width: width,
      height: height,
    );
  }
}
