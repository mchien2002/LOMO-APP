import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/api_time_out_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/error_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';
import 'dialog_widget.dart';

abstract class BaseState<M extends BaseModel, W extends StatefulWidget>
    extends State<W> {
  late M model;
  Widget? _loadingDialog;

  @override
  void initState() {
    super.initState();
    model = createModel();
    onModelReady();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  Widget buildContent() {
    return ChangeNotifierProvider<M>.value(
      value: model,
      child: Consumer<M>(
          builder: (context, model, child) => buildViewByState(context, model)),
    );
  }

  Widget buildDefaultLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundLoadingColor,
      child: Center(child: LoadingWidget()),
    );
  }

  Widget buildViewByState(BuildContext context, M model) {
    switch (model.viewState) {
      case ViewState.error:
        return ErrorViewWidget(
          message: model.errorMessage!.localize(context),
          onRetry: onRetry,
        );
      case ViewState.loaded:
      case ViewState.loading:
        if (isSliverOverlapAbsorber) {
          return getViewState(model);
        } else {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              child: getViewState(model));
        }
      default:
        return Container();
    }
  }

  Widget getViewState(M model) {
    return model.viewState == ViewState.loading
        ? buildLoadingView
        : buildContentView(context, model);
  }

  showLoading({BuildContext? dialogContext}) {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog();
      showDialog(
          barrierDismissible: false,
          context: dialogContext ?? context,
          builder: (_) =>
              _loadingDialog ??
              Container(
                color: Colors.transparent,
              ));
    }
  }

  hideLoading({BuildContext? dialogContext}) {
    if (_loadingDialog != null) {
      Navigator.pop(dialogContext ?? context);
      _loadingDialog = null;
    }
  }

  showError(String? errorMessage, {String? title}) {
    if (errorMessage?.isNotEmpty == true)
      showDialog(
          context: context,
          builder: (_) => OneButtonDialogWidget(
                title: title,
                description: errorMessage?.localize(context),
                textConfirm: Strings.close.localize(context),
              ));
  }

  M createModel() => locator<M>();

  Widget buildContentView(BuildContext context, M model);

  Widget get buildLoadingView => buildDefaultLoading();

  void onModelReady() {}

  void onRetry() {}

  callApi(
      {required Function callApiTask,
      Function? onSuccess,
      Function? onFail}) async {
    showLoading();
    try {
      eventBus.on<ApiTimeOutEvent>().listen((event) async {
        hideLoading();
        showError(Strings.unknownErrorMessage.localize(context));
      });
      await callApiTask();
    } catch (e, stackTrace) {
      model.sendErrorLogToServer(
        exception: e,
        stackTrace: stackTrace,
        className: this.runtimeType.toString(),
      );
    }
    hideLoading();
    if (model.progressState == ProgressState.success && onSuccess != null)
      onSuccess();
    else if (model.progressState == ProgressState.error) {
      if (onFail != null)
        onFail();
      else {
        showError(model.errorMessage!.localize(context));
      }
    }
  }

  Color get backgroundLoadingColor => DColors.whiteColor;

  bool get isSliverOverlapAbsorber => false;
}

mixin BaseAutomaticKeepAliveClientMixin<M extends BaseModel,
    T extends StatefulWidget> on BaseState<M, T> {}
