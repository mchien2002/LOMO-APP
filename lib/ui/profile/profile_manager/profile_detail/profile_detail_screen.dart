import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/eventbus/close_suggest_tag_cloud_event.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/profile/profile_manager/profile_detail/profile_detail_model.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/dropdown_button_widget.dart';
import 'package:lomo/ui/widget/dropdown_city_widget.dart';
import 'package:lomo/ui/widget/dropdown_height_weight_widget.dart';
import 'package:lomo/ui/widget/sogiesc/sogiesc_widget.dart';
import 'package:lomo/ui/widget/tag_cloud_widget.dart';
import 'package:lomo/util/common_utils.dart';

class ProfileDetailScreen extends StatefulWidget {
  final bool useForDatingEdit;

  ProfileDetailScreen({this.useForDatingEdit = false});

  @override
  State<StatefulWidget> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState
    extends BaseState<ProfileDetailModel, ProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    model.init();
    model.tecCaption.addListener(() {
      model.isValidateData();
    });
  }

  @override
  Widget buildContentView(BuildContext context, ProfileDetailModel model) {
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        final hitTargetIsEditable =
            result.path.any((entry) => entry.target is SogiescSuggestion);

        if (!hitTargetIsEditable) {
          eventBus.fire(CloseSuggestTagCloudEvent());
        }
      },
      child: Scaffold(
        backgroundColor: getColor().white,
        appBar: _buildAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(
                    height: 2,
                    color: getColor().grayBorder,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.paddingBodyContent),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!widget.useForDatingEdit)
                              SizedBox(
                                height: 20,
                              ),
                            if (!widget.useForDatingEdit) _buildStory(),
                            if (!widget.useForDatingEdit) _buildZodiac(),
                            _buildName(),
                            SizedBox(
                              height: Dimens.spacing20,
                            ),
                            _buildHeightWeight(),
                            SizedBox(
                              height: Dimens.spacing20,
                            ),
                            _buildCity(),
                            SizedBox(
                              height: Dimens.spacing20,
                            ),
                            _buildLiteracy(),
                            SizedBox(
                              height: Dimens.spacing20,
                            ),
                            _buildCareer(),
                            SizedBox(
                              height: Dimens.spacing20,
                            ),
                            _buildHobby(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildButtonSave()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: getColor().white,
      elevation: 0,
      leading: InkWell(
        onTap: () async {
          Navigator.of(context).maybePop();
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: getColor().colorDart,
          ),
        ),
      ),
      title: Text(
        widget.useForDatingEdit
            ? Strings.personalInfo.localize(context)
            : Strings.profileDetail.localize(context),
        style: textTheme(context).text19.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.personalIntroduce.localize(context),
          style: textTheme(context).text13.bold.colorDart,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: getColor().backgroundSearch),
          child: TextField(
            controller: model.tecCaption,
            autofocus: false,
            style: textTheme(context).text14Normal.colorDart,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              hintText: Strings.introduceYourself.localize(context),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildZodiac() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimens.spacing20,
        ),
        Text(
          Strings.zodiac.localize(context),
          style: textTheme(context).text13.bold.colorDart,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.user.zodiac?.name ?? Strings.notYet.localize(context),
              style: textTheme(context).text19.light.colorDart,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          height: 2,
          color: getColor().grayBorder,
        ),
      ],
    );
  }

  Widget _buildName() {
    return Visibility(
        visible: widget.useForDatingEdit,
        child: Column(
          children: [
            SizedBox(
              height: Dimens.spacing20,
            ),
            DropDownListWidget(
                titleDropdown: Strings.titleName.localize(context),
                titleContentPopUp: Strings.titleName.localize(context),
                initValue: model.user.title?.name?.localize(context) ?? null,
                items: model.commonRepository.listTitle
                    .map((e) => e.name!)
                    .toList(),
                onSelected: (index) {
                  model.user.title = model.commonRepository.listTitle[index];
                  model.isValidateData();
                }),
          ],
        ));
  }

  Widget _buildHeightWeight() {
    return DropDownHeightWeightWidget(
      initHeight: model.user.height!,
      initWeight: model.user.weight!,
      onSelected: (height, weight) {
        model.user.height = height;
        model.user.weight = weight;
        model.isValidateData();
      },
    );
  }

  Widget _buildCity() {
    return DropDownCityWidget(
      initCity: model.user.province,
      onItemSelected: (city) {
        model.user.province = city;
        model.isValidateData();
      },
    );
  }

  Widget _buildLiteracy() {
    return DropDownListWidget(
      titleDropdown: Strings.literacy.localize(context),
      titleContentPopUp: Strings.literacy.localize(context),
      initValue: model.user.literacy?.name?.localize(context) ?? "",
      items:
          model.commonRepository.listLiteracy?.map((e) => e.name!).toList() ??
              [],
      onSelected: (index) {
        model.user.literacy = model.commonRepository.listLiteracy![index];
        model.isValidateData();
      },
    );
  }

  Widget _buildCareer() {
    return TagCloudScreen<KeyValue>(
      model.user.careers!,
      model.careerController,
      model.commonRepository.listCareer!,
      (value) {
        return value.name!;
      },
      maxItemSelect: 3,
      leftTitle: Strings.career.localize(context),
      rightTitle: null,
      centerTitle: Strings.max3.localize(context),
      hintText: Strings.input.localize(context) +
          " " +
          Strings.career.localize(context).toLowerCase(),
      onValueChanged: (careers) {
        model.user.careers?.clear();
        if (careers.isNotEmpty == true) model.user.careers!.addAll(careers);
        model.isValidateData();
      },
      suffixIcon: Image.asset(
        DImages.icTabSearch,
        width: 24,
        height: 24,
        color: getColor().b6b6cbColor,
      ),
    );
  }

  Widget _buildHobby() {
    return TagCloudScreen<Hobby>(
      model.user.hobbies!,
      model.hobbyController,
      model.commonRepository.listHobby,
      (value) {
        return value.name!;
      },
      maxItemSelect: 3,
      leftTitle: Strings.hobby.localize(context),
      rightTitle: null,
      centerTitle: Strings.max3.localize(context),
      hintText: Strings.input.localize(context) +
          " " +
          Strings.hobby.localize(context).toLowerCase(),
      onValueChanged: (hobbies) {
        model.user.hobbies?.clear();
        if (hobbies.isNotEmpty == true) model.user.hobbies!.addAll(hobbies);
        model.isValidateData();
      },
      suffixIcon: Image.asset(
        DImages.icTabSearch,
        width: 24,
        height: 24,
        color: getColor().b6b6cbColor,
      ),
    );
  }

  Widget _buildButtonSave() {
    return BottomOneButton(
      text: Strings.save.localize(context),
      enable: model.validateData,
      onPressed: () async {
        callApi(
            callApiTask: model.updateProfile,
            onSuccess: () {
              showToast(Strings.updateProfileSuccess.localize(context));
              Navigator.pop(context);
            });
      },
    );
  }
}
