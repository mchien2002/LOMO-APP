import 'package:flutter/material.dart';

import '../../res/strings.dart';
import 'dialog_widget.dart';

class MaintenanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: NoButtonDialogWidget(
          title: Strings.systemNotification.localize(context),
          description: Strings.serverMaintenance.localize(context),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
