import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/data/eventbus/reset_suggest_tag_clound_event.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/filter/dating_filter_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dating_filter/filter_age_widget.dart';
import 'package:lomo/ui/widget/dating_filter/filter_literacy_widget.dart';
import 'package:lomo/ui/widget/dating_filter/filter_range_widget.dart';
import 'package:lomo/ui/widget/dating_filter/filter_verify_account_widget.dart';
import 'package:lomo/ui/widget/dating_filter/filter_zodiac_widget.dart';
import 'package:lomo/ui/widget/dropdown_city_widget.dart';
import 'package:lomo/ui/widget/tag_cloud_widget.dart';

class DatingFilterScreen extends StatefulWidget {
  final List<FilterRequestItem>? filters;

  DatingFilterScreen({this.filters});

  @override
  State<StatefulWidget> createState() => _DatingFilterScreenState();
}

class _DatingFilterScreenState
    extends BaseState<DatingFilterModel, DatingFilterScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.filters);
  }

  List<Literacy> selectedReportList = [];
  List<Zodiac> selectedReportZodiacList = [];

  @override
  Widget buildContentView(BuildContext context, DatingFilterModel model) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          backgroundColor: getColor().white,
          elevation: 0,
          leading: InkWell(
            onTap: () async {
              Navigator.of(context).maybePop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: getColor().colorDart,
            ),
          ),
          title: Text(
            Strings.filterSearch.localize(context),
            style: textTheme(context).text18.bold.colorDart,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _buildContent(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: _buildButtonFooter(),
        ));
  }

  Widget _buildAge() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                Strings.ageFull.localize(context),
                style: textTheme(context).text13.bold.colorDart,
              ),
              Spacer(),
              Text(
                Strings.ageLimit.localize(context),
                style: textTheme(context).text13.captionNormal.colorDart,
              ),
            ],
          ),
          SizedBox(
            height: Dimens.size5,
          ),
          FilterAgeWidget((minData) {
            model.setValueMinAge(minData);
          }, (maxData) {
            model.setValueMaxAge(maxData);
          }, model.resetFilter, model.getValueMinAge(), model.getValueMaxAge()),
        ],
      ),
    );
  }

  Widget _buildRange() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                Strings.range.localize(context),
                style: textTheme(context).text13.bold.colorDart,
              ),
              Spacer(),
              Text(
                Strings.rangeLimit.localize(context),
                style: textTheme(context).text13.captionNormal.colorDart,
              ),
            ],
          ),
          SizedBox(
            height: Dimens.size5,
          ),
          FilterRangeWidget((data) {
            model.setValueRange(data);
          }, model.resetFilter, model.getValueRange()),
        ],
      ),
    );
  }

  Widget _buildLiteracy() {
    return FilterLiteracyWidget(model.listLiteracy, (selectedList) {
      model.setValueListLiteracy(selectedList);
    }, model.resetFilter, model.selectedChoicesLiteracy);
  }

  Widget _buildCareer() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
      child: TagCloudScreen<KeyValue>(
        model.careerValue,
        model.careerController,
        model.listCareerFilter ?? [],
        (value) {
          return value.name ?? "";
        },
        leftTitle: Strings.career.localize(context),
        rightTitle: null,
        centerTitle: Strings.max3.localize(context),
        hintText: Strings.input.localize(context) +
            " " +
            Strings.career.localize(context).toLowerCase(),
        onValueChanged: (careers) {
          model.careerValue.clear();
          if (careers.isNotEmpty == true) model.careerValue.addAll(careers);
          FocusScope.of(context).unfocus();
        },
        suffixIcon: Image.asset(
          DImages.icTabSearch,
          width: 24,
          height: 24,
        ),
        maxItemSelect: 3,
      ),
    );
  }

  Widget _buildZodiac() {
    return FilterZodiacWidget(model.listZodiac, (selectedZodiacList) {
      model.setValueListZodiac(selectedZodiacList);
    }, model.resetFilter, model.selectedChoicesZodiac);
  }

  Widget _buildCity() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
      child: DropDownCityWidget(
        initCity: model.getValueCity(),
        resetData: model.resetFilter,
        onItemSelected: (city) {
          model.setValueCity(city);
          // isValidatedInfo();
        },
      ),
    );
  }

  Widget _buildButtonFooter() {
    return SizedBox(
      height: Dimens.size100,
      child: Container(
        height: Dimens.size100,
        color: getColor().white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: Dimens.size5, left: Dimens.size20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: BorderButton(
                  text: Strings.reset.localize(context),
                  radius: Dimens.cornerRadius6,
                  color: getColor().white,
                  borderColor: getColor().colorPrimary,
                  textStyle: textTheme(context).text17.bold.colorPrimary,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    eventBus.fire(ResetSuggestTagCloudEvent());
                    model.reset();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: Dimens.size5, right: Dimens.size20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: BorderButton(
                    text: Strings.filterNow.localize(context),
                    radius: Dimens.cornerRadius6,
                    color: getColor().violet,
                    borderColor: getColor().colorPrimary,
                    textStyle: textTheme(context).text17.bold.colorWhite,
                    onPressed: () async {
                      locator<TrackingManager>().trackDatingFilter();
                      Navigator.pop(context, model.getResultFilter());
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        Divider(
          height: 2,
        ),
        SizedBox(
          height: Dimens.spacing15,
        ),
        _buildAge(),
        SizedBox(
          height: Dimens.size10,
        ),
        _buildRange(),
        SizedBox(
          height: Dimens.size10,
        ),
        _buildVerifyAccount(),
        SizedBox(
          height: Dimens.size20,
        ),
        _buildLiteracy(),
        SizedBox(
          height: Dimens.size30,
        ),
        _buildCareer(),
        SizedBox(
          height: Dimens.size20,
        ),
        _buildZodiac(),
        SizedBox(
          height: Dimens.size30,
        ),
        _buildCity(),
        SizedBox(
          height: Dimens.size15,
        ),
      ],
    );
  }

  Widget _buildVerifyAccount() {
    return FilterVerifyAccountWidget(
        text: Strings.accountVerification.localize(context),
        initSwitch: model.getValueVerifyAccount() ?? false,
        resetData: model.resetFilter,
        selectedSwitch: (data) {
          model.setValueVerifyAccount(data);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
