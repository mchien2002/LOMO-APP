import 'package:flutter/material.dart';
import 'package:lomo/ui/base/base_state.dart';

import 'base_form_model.dart';

abstract class BaseFormState<M extends BaseFormModel, W extends StatefulWidget>
    extends BaseState<M, W> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget buildContentView(BuildContext context, M model) {
    return Form(
      key: formKey,
      child: buildContentForm(context, model),
    );
  }

  Widget buildContentForm(BuildContext context, M model);
}
