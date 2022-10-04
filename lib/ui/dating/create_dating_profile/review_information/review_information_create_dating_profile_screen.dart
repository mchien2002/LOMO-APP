import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/create_dating_profile/review_information/review_information_create_dating_profile_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/step_tabbar_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:provider/provider.dart';

class ReviewInformationCreateDatingProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _ReviewInformationCreateDatingProfileScreenState();
}

class _ReviewInformationCreateDatingProfileScreenState extends BaseState<
    ReviewInformationCreateDatingProfileModel,
    ReviewInformationCreateDatingProfileScreen> {
  @override
  Widget buildContentView(
      BuildContext context, ReviewInformationCreateDatingProfileModel model) {
    return Scaffold(
      appBar: StepAppBar(
        totalStep: 3,
        currentStep: 1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ChangeNotifierProvider.value(
            value: locator<UserModel>(),
            child: Consumer<UserModel>(
                builder: (context, userModel, child) => Stack(
                      children: [
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              Strings.reviewInformation.localize(context),
                              style: textTheme(context).text22.colorDart.bold,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              Strings.reviewInformationHint.localize(context),
                              style: textTheme(context).text17.colorGray77,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            _buildInformationItem(
                                DImages.nameDart,
                                Strings.titleName.localize(context),
                                userModel.user?.title?.name),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.persionDark,
                                Strings.visibleName.localize(context),
                                userModel.user?.name),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.ageDark,
                                Strings.age.localize(context),
                                userModel.user?.birthday != null
                                    ? "${getAgeFromDateTime(userModel.user!.birthday!)}"
                                    : null),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.zodiacDart,
                                Strings.zodiac.localize(context),
                                userModel.user?.zodiac?.name
                                    ?.localize(context)),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.handwDart,
                                Strings.heightAndWeight.localize(context),
                                userModel.user?.height != null
                                    ? "${userModel.user?.height} cm, "
                                            "" +
                                        userModel.user!.weight.toString() +
                                        "kg".localize(context)
                                    : Strings.notYet.localize(context)),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.cityDart,
                                Strings.city.localize(context),
                                userModel.user?.province?.name),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.educationDart,
                                Strings.literacyFull.localize(context),
                                userModel.user?.literacy?.name),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(DImages.careerDart,
                                Strings.career.localize(context), null,
                                itemList: userModel.user?.careers
                                    ?.map((e) => e.name!)
                                    .toList()),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(DImages.hobbyDart,
                                Strings.hobby.localize(context), null,
                                itemList: userModel.user?.hobbies
                                    ?.map((e) => e.name!)
                                    .toList()),
                            SizedBox(
                              height: 24,
                            ),
                            _buildInformationItem(
                                DImages.enableHeart,
                                Strings.relationship.localize(context),
                                userModel.user?.relationship?.name),
                            SizedBox(
                              height: Dimens.size100,
                            ),
                          ],
                        )),
                        _buildBottomButton(userModel.user)
                      ],
                    ))),
      ),
    );
  }

  Widget _buildInformationItem(String image, String title, String? content,
      {List<String>? itemList}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: getColor().colorGrayOpacity,
            radius: Dimens.size20,
            child: Image.asset(
              image,
              color: getColor().colorGray,
              width: Dimens.size25,
              height: Dimens.size25,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme(context).text13.bold.colorGray77,
              ),
              SizedBox(
                height: 4,
              ),
              itemList?.isNotEmpty == true
                  ? _buildInformationItemList(itemList!)
                  : content?.isNotEmpty == true
                      ? Text(
                          content!,
                          style: textTheme(context).text15.medium.colorDart,
                        )
                      : Text(
                          Strings.notYet.localize(context),
                          style: textTheme(context).text15.colorGrayBorder,
                        ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInformationItemList(List<String> items) {
    return Wrap(
      runSpacing: 5,
      children: items
          .map(
            (item) => Text(
              items.indexOf(item) != items.length - 1 ? "$item, " : item,
              style: textTheme(context).text15.medium.colorDart,
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomButton(User? user) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: getColor().white,
        height: Dimens.size90,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: BorderButton(
                    text: Strings.edit.localize(context),
                    radius: Dimens.cornerRadius6,
                    color: getColor().white,
                    borderColor: getColor().colorPrimary,
                    textStyle: textTheme(context).text17.bold.colorPrimary,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.profileDetail,
                          arguments: true);
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: PrimaryButton(
                    text: Strings.next.localize(context),
                    radius: Dimens.cornerRadius6,
                    textStyle: textTheme(context).text17.bold.colorWhite,
                    onPressed: () {
                      Navigator.pushNamed(
                          context, Routes.addInformationCreateDatingProfile);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
