import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import 'button_widgets.dart';

class RoleWidget extends StatefulWidget {
  final Function(Role? role)? onRoleSelected;
  final Role? selectedRole;

  RoleWidget({this.onRoleSelected, this.selectedRole});

  @override
  State<StatefulWidget> createState() => _RoleWidgetState();
}

class _RoleWidgetState extends State<RoleWidget> {
  Role? selectedRole;
  final List<Role> genders = locator<CommonRepository>().roles!;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.selectedRole ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGender(genders[2]),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildGender(genders[0]),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: _buildGender(genders[1]),
        ),
      ],
    );
  }

  Widget _buildGender(Role role) {
    return selectedRole?.id == role.id
        ? _buildSelectedRole(role)
        : _buildNoneSelectedRole(role);
  }

  Widget _buildSelectedRole(Role role) {
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: DColors.shadowColor88.withOpacity(0.4),
      //       blurRadius: Dimens.size20,
      //     ),
      //   ],
      // ),
      child: SmallButton(
        height: 35,
        text: role.name!.localize(context),
        radius: 17,
        textStyle: textTheme(context).text13.bold.colorWhite,
        onPressed: () {
          setState(() {
            onSelected(role);
          });
        },
      ),
    );
  }

  Widget _buildNoneSelectedRole(Role role) {
    return BorderButton(
      height: 35,
      borderColor: getColor().textGray,
      text: role.name?.localize(context),
      radius: 17,
      textStyle: textTheme(context).text13.bold.colorDart,
      onPressed: () {
        setState(() {
          onSelected(role);
        });
      },
    );
  }

  onSelected(Role role) {
    if (selectedRole != role) {
      selectedRole = role;
    } else {
      selectedRole = null;
    }
    if (widget.onRoleSelected != null) widget.onRoleSelected!(selectedRole!);
  }
}
