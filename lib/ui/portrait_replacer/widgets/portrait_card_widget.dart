import 'package:flutter/material.dart';
import 'package:portrait_replacer/data/models/portrait.dart';

class PortraitCardWidget extends StatefulWidget {
  final Portrait portrait;
  final Widget? topPositioned;
  final bool loading;

  const PortraitCardWidget({
    super.key,
    this.topPositioned,
    required this.portrait,
    this.loading = false,
  });

  @override
  State<PortraitCardWidget> createState() => _PortraitCardWidgetState();
}

class _PortraitCardWidgetState extends State<PortraitCardWidget> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          hover = true;
        });
      },
      onExit: (value) {
        setState(() {
          hover = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(widget.portrait.imageBytes),
          AnimatedOpacity(
            opacity: widget.loading ? 1.0 : 0.0,
            duration: Duration(milliseconds: 120),
            child: Container(color: Colors.black.withAlpha(180)),
          ),
          widget.loading
              ? CircularProgressIndicator()
              : Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: hover ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 120),
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(240),
                          Colors.black.withAlpha(0),
                        ],
                      ),
                    ),
                    child: widget.topPositioned,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
