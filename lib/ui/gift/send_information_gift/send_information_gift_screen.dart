import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/gift/send_information_gift/send_information_gift_model.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/dropdown_api_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/text_form_field_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/validate_utils.dart';

class SendInformationGiftScreen extends StatefulWidget {
  final Gift gift;

  const SendInformationGiftScreen({Key? key, required this.gift})
      : super(key: key);

  @override
  _SendInformationGiftScreenState createState() =>
      _SendInformationGiftScreenState();
}

class _SendInformationGiftScreenState
    extends BaseState<SendInformationGiftModel, SendInformationGiftScreen> {
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget buildContentView(
      BuildContext context, SendInformationGiftModel model) {
    return BottomSheetModal(
      isFull: true,
      contentWidget: _content(context),
      right: _rightWidget(context),
      appbarColor: DColors.whiteColor,
      title: Strings.exchangeGift.localize(context),
      titleStyle: textTheme(context).text18.bold.colorDart,
      isRadius: true,
    );
  }

  Widget _content(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formGlobalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          children: [
            Row(
              children: [
                RoundNetworkImage(
                  height: 90,
                  width: 90,
                  url: widget.gift.image,
                  boxFit: BoxFit.cover,
                  radius: 0,
                ),
                SizedBox(
                  width: Dimens.spacing20,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.gift.title!,
                      style: textTheme(context).text16.bold.colorDart,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: Dimens.size10,
                    ),
                    Row(
                      children: [
                        RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    "${(widget.gift.promotion != 0 && widget.gift.promotion != null) ? formatNumberDivThousand(widget.gift.promotion!) : formatNumberDivThousand(widget.gift.price!)}",
                                style: textTheme(context)
                                    .text16
                                    .semiBold
                                    .colorVioletFB,
                              ),
                              WidgetSpan(
                                child: Image.asset(
                                  DImages.candy,
                                  color: getColor().violetFBColor,
                                  width: 17,
                                  height: 17,
                                ),
                              ),
                            ])),
                        SizedBox(
                          width: Dimens.size10,
                        ),
                        if (widget.gift.price! != widget.gift.promotion)
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "${formatNumberDivThousand(widget.gift.price!)}",
                                  style: textTheme(context)
                                      .text14Normal
                                      .semiBold
                                      .colorGray99
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                WidgetSpan(
                                  child: Image.asset(
                                    DImages.candy,
                                    color: getColor().unSelectedTabBar,
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildName(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildPhone(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildEmail(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildCity(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildProvince(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildDistrict(),
            SizedBox(
              height: Dimens.spacing20,
            ),
            _buildWard(),
            SizedBox(
              height: Dimens.size30,
            ),
            PrimaryButton(
              text: Strings.confirm.localize(context),
              onPressed: () async {
                if (formGlobalKey.currentState!.validate()) {
                  await model.getExchangeGift(
                      model.techUserName!.text,
                      model.techPhone!.text,
                      model.techCity!.text,
                      widget.gift.id!,
                      model.getProvince.id,
                      model.getDistrict!.id,
                      model.getWard!.id,
                      model.emailController!.text.trim());
                  locator<TrackingManager>().trackRewardExchange();
                  await _handleExchangeGift(
                      context,
                      (widget.gift.promotion != 0 &&
                              widget.gift.promotion != null)
                          ? widget.gift.promotion!
                          : widget.gift.price!);
                }
              },
            ),
            SizedBox(
              height: Dimens.size50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return ClearTextField(
      hint: Strings.enterNameRecipient.localize(context),
      leftTitle: Strings.nameRecipient.localize(context),
      textStyle: textTheme(context).text18.colorViolet,
      controller: model.techUserName,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) => !validateUserName(text!)
          ? Strings.correct_format.localize(context)
          : null,
    );
  }

  Widget _buildPhone() {
    return ClearTextField(
      hint: Strings.enterPhoneNumber.localize(context),
      leftTitle: Strings.phoneNumber.localize(context),
      textStyle: textTheme(context).text18.colorViolet,
      controller: model.techPhone,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) =>
          !validatePhone(text!) ? Strings.errorPhone.localize(context) : null,
    );
  }

  Widget _buildCity() {
    return ClearTextField(
      hint: Strings.enterAddress.localize(context),
      leftTitle: Strings.address.localize(context),
      textStyle: textTheme(context).text18.colorViolet,
      controller: model.techCity,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) => !validateLength(text!)
          ? Strings.pleaseEnterAddress.localize(context)
          : null,
    );
  }

  // String? _validateExchangeGift() {
  //   // if (model.techUserName!.text == "" || model.techUserName == null) {
  //   //   return Strings.pleaseEnterName.localize(context);
  //   // }
  //   // if (model.techPhone!.text == "" || model.techPhone == null) {
  //   //   return Strings.pleaseEnterPhone.localize(context);
  //   // }
  //   // if (!validatePhone(model.techPhone!.text)) {
  //   //   return Strings.errorPhone.localize(context);
  //   // }
  //   // if (model.emailController!.text == "" || model.emailController == null) {
  //   //   return Strings.pleaseEnterEmail.localize(context);
  //   // }
  //   // if (!validateEmail(model.emailController!.text)) {
  //   //   return Strings.invalidEmail.localize(context);
  //   // }
  //   // if (model.techCity!.text == "" || model.techCity == null) {
  //   //   return Strings.pleaseEnterAddress.localize(context);
  //   // }
  //   if (model.provinceController!.text == "" ||
  //       model.provinceController == null) {
  //     return Strings.pleaseEnterProvince.localize(context);
  //   }
  //   if (model.districtController!.text == "" ||
  //       model.districtController == null) {
  //     return Strings.pleaseEnterDistrict.localize(context);
  //   }
  //   // if (model.wardController!.text == "" || model.wardController == null) {
  //   //   return Strings.pleaseEnterWard.localize(context);
  //   // }
  //   return null;
  // }

  Widget _buildProvince() {
    return InkWell(
      child: DTextFromField(
        strokeColor: getColor().underlineClearTextField,
        leftTitle: Strings.province.localize(context),
        hintText: Strings.province.localize(context),
        controller: model.provinceController,
        enabled: false,
        errorStyle: textTheme(context).text14.colorPink88,
        onValidated: (text) => !validateLength(text!)
            ? Strings.pleaseEnterProvince.localize(context)
            : null,
        suffixIcon: SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
        textStyle: textTheme(context).text18.colorPrimary,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) => DropdownAddressWidget(
                  getDropdown: model.commonRepository.getCities,
                  items: model.listProvince,
                  titleContentPopUp: Strings.province.localize(context),
                  onSelected: (value) {
                    model.provinceController?.text = value.name;
                    model.getProvince = value;
                    model.districtController?.clear();
                    model.getDistrict = null;
                    model.wardController?.clear();
                    model.getWard = null;
                    model.disableDistrictSubject.sink.add(true);
                    model.disableWardSubject.sink.add(false);
                  },
                  initValue: model.provinceController!.text,
                ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true);
      },
    );
  }

  Widget _buildDistrict() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: model.disableDistrictSubject.stream,
        builder: (context, snapshot) {
          return InkWell(
            child: DTextFromField(
              strokeColor: getColor().underlineClearTextField,
              leftTitle: Strings.district.localize(context),
              hintText: Strings.district.localize(context),
              rightTitle: snapshot.data! ? null : "(Nhập tỉnh thành)",
              controller: model.districtController,
              enabled: false,
              errorStyle: textTheme(context).text14.colorPink88,
              onValidated: (text) => !validateLength(text!)
                  ? Strings.pleaseEnterDistrict.localize(context)
                  : null,
              suffixIcon: SvgPicture.asset(
                DIcons.expand,
                height: 24,
                width: 24,
                color: getColor().colorPrimary,
              ),
              textStyle: textTheme(context).text18.colorPrimary,
            ),
            onTap: snapshot.data!
                ? () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => DropdownAddressWidget(
                              getDropdown: model.commonRepository.getDistrict,
                              items: model.listDistrict,
                              idInitial: model.getProvince.id.toString(),
                              titleContentPopUp:
                                  Strings.district.localize(context),
                              onSelected: (value) {
                                model.districtController!.text = value.name;
                                model.getDistrict = value;
                                model.wardController!.clear();
                                model.getWard = null;
                                model.disableWardSubject.sink.add(true);
                              },
                              initValue: model.districtController!.text,
                            ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true);
                  }
                : null,
          );
        });
  }

  Widget _buildWard() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: model.disableWardSubject.stream,
      builder: (context, snapshot) {
        return InkWell(
          child: DTextFromField(
            strokeColor: getColor().underlineClearTextField,
            leftTitle: Strings.ward.localize(context),
            hintText: Strings.ward.localize(context),
            controller: model.wardController,
            rightTitle: snapshot.data! ? null : "(Nhập quận huyện)",
            enabled: false,
            errorStyle: textTheme(context).text14.colorPink88,
            onValidated: (text) => !validateLength(text!)
                ? Strings.pleaseEnterWard.localize(context)
                : null,
            suffixIcon: SvgPicture.asset(
              DIcons.expand,
              height: 24,
              width: 24,
              color: getColor().colorPrimary,
            ),
            textStyle: textTheme(context).text18.colorPrimary,
          ),
          onTap: snapshot.data!
              ? () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => DropdownAddressWidget(
                            getDropdown: model.commonRepository.getWard,
                            items: model.listWard,
                            idInitial: model.getDistrict!.id.toString(),
                            titleContentPopUp: Strings.ward.localize(context),
                            onSelected: (value) {
                              model.wardController!.text = value.name;
                              model.getWard = value;
                            },
                            initValue: model.wardController!.text,
                          ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true);
                }
              : null,
        );
      },
    );
  }

  Widget _buildEmail() {
    return ClearTextField(
      hint: Strings.enterEmail.localize(context),
      leftTitle: Strings.email.localize(context),
      textStyle: textTheme(context).text18.colorViolet,
      controller: model.emailController,
      errorStyle: textTheme(context).text14.colorPink88,
      onValidated: (text) =>
          !validateEmail(text!.trim()) ? Strings.invalidEmail.localize(context) : null,
    );
  }

  Widget _rightWidget(BuildContext context) {
    return InkWell(
      child: Icon(
        Icons.close,
        size: 25,
        color: getColor().colorDart,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  _handleExchangeGift(BuildContext context, int price) async {
    if (model.progressState == ProgressState.success) {
      showLoading();
      await model.updateUserAfterExchangeSuccessful(price);
      hideLoading();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => OneButtonDialogWidget(
          title: Strings.exchangeGiftSuccess.localize(context),
          description: Strings.giftSendAfter.localize(context),
          textConfirm: Strings.done.localize(context),
        ),
      );
    } else if (model.progressState == ProgressState.error) {
      model.progressState = ProgressState.initial;
      showDialog(
        context: context,
        builder: (context) => OneButtonDialogWidget(
          title: Strings.notice.localize(context),
          description: model.errorMessage!.localize(context),
        ),
      );
    }
  }
}
