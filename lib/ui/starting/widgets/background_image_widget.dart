import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/Wallpaper.jpg"),
        Positioned(
          right: 0,
          child: Container(
            width: 720,
            //height: 720,
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.center,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
