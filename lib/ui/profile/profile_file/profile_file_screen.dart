import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/list_more_discovery/list_more_discovery_screen.dart';
import 'package:lomo/ui/profile/profile_file/profile_file_model.dart';
import 'package:lomo/ui/widget/user_item_widget.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';

class FileScreen extends StatefulWidget {
  final User user;

  FileScreen({required this.user});

  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends BaseState<ProfileFileModel, FileScreen>
    with AutomaticKeepAliveClientMixin<FileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildContentView(BuildContext context, ProfileFileModel model) {
    final listUserFieldDisable = List<String>.from(UserFieldDisabledListDetail);
    listUserFieldDisable.addAll(UserFieldDisabledListGender);
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: getColor().white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: !checkHasFieldNoneDisabled(listUserFieldDisable) &&
                !widget.user.isMe
            ? _buildDisableAllField()
            : _buildProfileField(),
      ),
    );
  }

  Widget _buildProfileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        _buildText(
            Strings.detail.localize(context), UserFieldDisabledListDetail),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.age))
          _buildAgeProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.birthday))
          _buildBirthDayProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.zodiac))
          _buildZodiacProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.email))
          _buildEmailProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.weight))
          _buildHeightAndWeightProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.province))
          _buildCityProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.literacy))
          _buildLiteracyProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.careers))
          _buildItemCareerProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.hobbies))
          _buildItemHobbiesProfile(widget.user),
        if (!widget.user.fieldDisabled!
            .contains(UserFieldDisabled.relationship))
          _buildRelationshipProfile(widget.user),
        SizedBox(
          height: Dimens.size10,
        ),
        _buildText(
            Strings.aboutGender.localize(context), UserFieldDisabledListGender),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.title))
          _buildNameProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.gender))
          _buildSexProfile(widget.user),
        if (!widget.user.fieldDisabled!.contains(UserFieldDisabled.sogiescs))
          _buildItemSogiescProfile(widget.user),
        SizedBox(
          height: Dimens.size30,
        ),
      ],
    );
  }

  Widget _buildDisableAllField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
        ),
        Image.asset(
          DImages.lockGray,
          height: 44,
          width: 44,
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          Strings.privateContent.localize(context),
          style: textTheme(context).text13.gray77,
        ),
      ],
    );
  }

  Widget _buildText(String content, List<String> listData) {
    return Visibility(
      visible: checkHasFieldNoneDisabled(listData),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimens.size15),
        child: Text(
          content,
          style: textTheme(context).text13.bold.colorPrimary,
        ),
      ),
    );
  }

  Widget _buildAgeProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.age.localize(context),
        "${getAgeFromDateTime(user.birthday != null ? user.birthday! : DateTime.now())}",
        DImages.birthDayGray);
  }

  Widget _buildBirthDayProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.dateOfBirth.localize(context),
        "${formatDate(user.birthday != null ? user.birthday : DateTime.now(), "dd/MM")}",
        DImages.birthDayGray);
  }

  Widget _buildZodiacProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.zodiac.localize(context),
        user.zodiac != null
            ? user.zodiac!.name!
            : Strings.notYet.localize(context),
        DImages.zodiacDart, callBack: () {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.zodiac;
      param.value = user.zodiac!.id ?? "";
      pushToHashTagScreen(user.zodiac!.name ?? "", [param]);
    });
  }

  Widget _buildEmailProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.email.localize(context),
        user.email?.isNotEmpty == true
            ? user.email!.localize(context)
            : Strings.notYet.localize(context),
        DImages.messageDart);
  }

  Widget _buildHeightAndWeightProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.heightAndWeight.localize(context),
        user.height != null &&
                user.height != 0.0 &&
                user.weight != null &&
                user.weight != 0.0
            ? "${widget.user.height} cm, "
                    "" +
                user.weight.toString() +
                "kg"
            : Strings.notYet.localize(context),
        DImages.handwDart);
  }

  Widget _buildNameProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.titleName.localize(context),
        user.title != null
            ? user.title!.name!.localize(context)
            : Strings.notYet.localize(context),
        DImages.nameDart);
  }

  Widget _buildSexProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.gender.localize(context),
        user.gender != null
            ? user.gender!.name!.localize(context)
            : Strings.notYet.localize(context),
        DImages.genderDart, callBack: () {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.gender;
      param.value = user.gender!.id ?? "";
      pushToHashTagScreen(user.gender!.name ?? "", [param]);
    });
  }

  Widget _buildCityProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.city.localize(context),
        user.province != null
            ? user.province!.name.localize(context)
            : Strings.notYet.localize(context),
        DImages.cityDart, callBack: () {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.province;
      param.value = user.province!.id;
      pushToHashTagScreen(user.province!.name, [param]);
    });
  }

  Widget _buildLiteracyProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.literacyFull.localize(context),
        user.literacy != null
            ? user.literacy!.name!.localize(context)
            : Strings.notYet.localize(context),
        DImages.educationDart, callBack: () {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.literacy;
      param.value = user.literacy!.id ?? "";
      pushToHashTagScreen(user.literacy!.name ?? "", [param]);
    });
  }

  Widget _buildCareerProfile(User user) {
    return _itemWrapBuilderProfile<KeyValue>(
        true, user.careers!, Strings.career.localize(context), (value) {
      return value.name ?? "";
    }, selectedItem: (value) {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.careers;
      param.value = value.id;
      pushToHashTagScreen(value.name ?? "", [param]);
    });
  }

  Widget _buildRelationshipProfile(User user) {
    return _itemBuilderProfile(
        true,
        Strings.relationship.localize(context),
        user.relationship != null
            ? user.relationship!.name!
            : Strings.notYet.localize(context),
        DImages.enableHeart, callBack: () {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.relationship;
      param.value = user.relationship!.id ?? "";
      pushToHashTagScreen(user.relationship!.name ?? "", [param]);
    });
  }

  Widget _buildSogiesc(User user) {
    return InkWell(
      child: _itemWrapBuilderProfile<Sogiesc>(
        user.sogiescs != null && user.sogiescs?.isNotEmpty == true,
        user.sogiescs!,
        Strings.sogiesc.localize(context),
        (value) {
          return value.name ?? "";
        },
        selectedItem: (value) {
          FilterRequestItem param = FilterRequestItem();
          param.key = UserFieldDisabled.sogiescs;
          param.value = value.id;
          pushToHashTagScreen(value.name ?? "", [param]);
        },
      ),
    );
  }

  Widget _buildHobbies(User user) {
    return _itemWrapBuilderProfile<Hobby>(
        user.hobbies != null && user.hobbies?.isNotEmpty == true,
        user.hobbies!,
        Strings.hobby.localize(context), (value) {
      return value.name ?? "";
    }, selectedItem: (value) {
      FilterRequestItem param = FilterRequestItem();
      param.key = UserFieldDisabled.hobbies;
      param.value = value.id;
      pushToHashTagScreen(value.name ?? "", [param]);
    });
  }

  Widget _buildItemCareerProfile(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: getColor().colorGrayOpacity,
            radius: Dimens.size18,
            child: Image.asset(
              DImages.careerDart,
              color: getColor().colorGray,
              width: Dimens.size25,
              height: Dimens.size25,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimens.size10),
            child: _buildCareerProfile(user),
          ),
        ),
      ],
    );
  }

  Widget _buildItemHobbiesProfile(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: getColor().colorGrayOpacity,
            radius: Dimens.size18,
            child: Image.asset(
              DImages.hobbyDart,
              color: getColor().colorGray,
              width: Dimens.size25,
              height: Dimens.size25,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimens.size10),
            child: _buildHobbies(user),
          ),
        ),
      ],
    );
  }

  Widget _buildItemSogiescProfile(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: getColor().colorGrayOpacity,
            radius: Dimens.size18,
            child: Image.asset(
              DImages.sogiescDart,
              color: getColor().colorGray,
              width: Dimens.size25,
              height: Dimens.size25,
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: Dimens.size10),
            child: _buildSogiesc(user),
          ),
        ),
      ],
    );
  }

  void pushToHashTagScreen(String name, List<FilterRequestItem> param) {
    Navigator.pushNamed(
      context,
      Routes.moreDiscovery,
      arguments: ListMoreDiscoveryArguments(name, (page, pageSize) async {
        return await model.userRepository
            .getListFilterRequest(param, page, limit: pageSize);
      }, (listData) {
        return _itemProfile(listData);
      }),
    );
  }

  Widget _itemBuilderProfile(
      bool isShow, String topTitle, String bottomTitle, String icon,
      {GestureTapCallback? callBack}) {
    return Column(
      children: [
        Visibility(
          visible: isShow,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: getColor().colorGrayOpacity,
                radius: Dimens.size18,
                child: Image.asset(
                  icon != "" ? icon : DImages.zodiacDart,
                  color: getColor().colorGray,
                  width: Dimens.size24,
                  height: Dimens.size24,
                ),
              ),
              SizedBox(
                width: Dimens.size10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topTitle,
                    style: textTheme(context).text13.bold.colorGray,
                  ),
                  SizedBox(
                    height: Dimens.spacing4,
                  ),
                  InkWell(
                    onTap: () {
                      if (callBack != null) callBack();
                    },
                    child: Text(
                      bottomTitle,
                      style: textTheme(context).text15.colorDart.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dimens.size24,
        ),
      ],
    );
  }

  Widget _itemWrapBuilderProfile<T>(bool isShow, List<T> listValue,
      String? leftTitle, String Function(T) getName,
      {Function(T)? selectedItem}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leftTitle != null)
          Text(
            leftTitle,
            style: textTheme(context).text13.bold.colorGray,
          ),
        SizedBox(
          height: Dimens.spacing5,
        ),
        listValue.length != 0
            ? Wrap(
                runSpacing: 5,
                children: List.generate(listValue.length, (index) {
                  return InkWell(
                    onTap: selectedItem == null
                        ? null
                        : () {
                            selectedItem(listValue[index]);
                          },
                    child: Text(
                      index != listValue.length - 1
                          ? "${getName(listValue[index])}, "
                          : "${getName(listValue[index])}",
                      style: textTheme(context).text15.colorDart.medium,
                    ),
                  );
                }),
              )
            : Text(
                Strings.notYet.localize(context),
                style: textTheme(context).text15.colorDart.medium,
              ),
        SizedBox(
          height: Dimens.size24,
        )
      ],
    );
  }

  Widget _itemProfile(List<User> listItems) {
    double widthList = MediaQuery.of(context).size.width - 22;
    return GridView.count(
      childAspectRatio: (widthList / 3) / (widthList / 3 / 0.65 + 50),
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      padding: EdgeInsets.all(Dimens.spacing8),
      children: List.generate(listItems.length, (index) {
        return UserRequestFilterWidget(
          width: widthList / 3,
          height: widthList / (3 * 0.65),
          user: listItems[index],
        );
      }),
    );
  }

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  checkHasFieldNoneDisabled(List<String> listData) {
    int count = listData.length;
    widget.user.fieldDisabled!.forEach((fieldDisabledItem) {
      listData.forEach((element) {
        if (element.contains(fieldDisabledItem)) count--;
      });
    });
    if (count == 0)
      return false;
    else
      return true;
  }
}
