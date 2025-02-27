import 'dart:async';

import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final Stream<double>? valueStream;
  final bool popOnDone;

  const LoadingIndicator({super.key, required this.valueStream, this.popOnDone = false});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  double? value;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.valueStream?.listen(
      (data) {
        setState(() {
          value = data;
        });
      },
      onDone: () {
        if(widget.popOnDone && mounted){
          Navigator.of(context).pop();
        }
      },
    );
  }


  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(value: value,);
  }
}
