import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/core/ui/loading_Indicator.dart';

class LoadingIndicatorDialog extends StatelessWidget {
  final Stream<double>? valueStream;

  const LoadingIndicatorDialog({super.key, this.valueStream});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr("processing")),
      content: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: LoadingIndicator(valueStream: valueStream, popOnDone: true,),
        ),
      ),
    );
  }
}
