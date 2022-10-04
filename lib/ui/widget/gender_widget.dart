import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/res/strings.dart';

class GenderWidget extends StatefulWidget {
  final Function(Gender gender)? onGenderSelected;
  final Gender? selectedGender;
  final String? textMale;
  final String? textFemale;
  final String? textOther;

  GenderWidget(
      {this.onGenderSelected,
      this.selectedGender,
      this.textMale,
      this.textFemale,
      this.textOther});

  @override
  State<StatefulWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  Gender? selectedGender;
  final List<Gender> genders = [GENDERS[1], GENDERS[0], GENDERS[2]];

  @override
  void initState() {
    super.initState();
    selectedGender = widget.selectedGender;
    if (widget.textMale != null) genders[0].name = widget.textMale;
    if (widget.textFemale != null) genders[1].name = widget.textFemale;
    if (widget.textOther != null) genders[2].name = widget.textOther;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGender(genders[0]),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildGender(genders[1]),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildGender(genders[2]),
        ),
      ],
    );
  }

  Widget _buildGender(Gender gender) {
    return selectedGender?.id == gender.id
        ? _buildSelectedGender(gender)
        : _buildNoneSelectedGender(gender);
  }

  Widget _buildSelectedGender(Gender gender) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: getColor().colorShadow88,
          blurRadius: 1,
          spreadRadius: 1,
        )
      ], borderRadius: BorderRadius.all(Radius.circular(17))),
      child: SmallButton(
        height: 35,
        text: gender.name?.localize(context),
        radius: 17,
        textStyle: textTheme(context).text13.bold.colorWhite,
      ),
    );
  }

  Widget _buildNoneSelectedGender(Gender gender) {
    return BorderButton(
      height: 35,
      borderColor: getColor().grayBorder,
      text: gender.name?.localize(context),
      radius: 17,
      textStyle: textTheme(context).text13.bold.colorDart,
      onPressed: () {
        setState(() {
          selectedGender = gender;
          if (widget.onGenderSelected != null) widget.onGenderSelected!(gender);
        });
      },
    );
  }
}
