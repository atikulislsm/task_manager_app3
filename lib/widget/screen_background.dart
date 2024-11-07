import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.sizeOf(context);
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsPath.backgroudPath,
          fit: BoxFit.cover,
          height: screenSize.height,
          width: screenSize.width,
        ),
        SafeArea(child: child),
      ],
    );
  }
}