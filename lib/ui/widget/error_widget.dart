import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';

import 'button_widgets.dart';

class ErrorViewWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  ErrorViewWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment(0, -0.25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, style: textTheme(context).body.colorDart),
          SizedBox(height: Dimens.spacing16),
          PrimaryButton(
            width: 120,
            text: Strings.retry.localize(context),
            onPressed: onRetry,
          )
        ],
      ),
    );
  }
}
