import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:provider/provider.dart';

class SogiescListWidget extends StatefulWidget {
  final ValueNotifier<Gender?>? selectedGender;
  final ValueNotifier<SelectAllEvent?>? setSelectAll;
  final List<Sogiesc?>? initSogiescSelected;
  final Function(List<Sogiesc>?)? onSogiescSelected;
  final int? maxItemSelected;

  SogiescListWidget(this.selectedGender,
      {this.initSogiescSelected,
      this.setSelectAll,
      this.onSogiescSelected,
      this.maxItemSelected});

  @override
  State<StatefulWidget> createState() => _SogiescListWidgetState();
}

class _SogiescListWidgetState extends State<SogiescListWidget> {
  late List<Sogiesc> sogiescOriginalList;
  List<Sogiesc> filteredSogiescList = [];
  bool isFullSelected = false;
  late int maxItemSelected;
  final int MAXIMUM_CHOOSE_SOGIESC = 999;
  ValueNotifier<Object?> rebuildItem = ValueNotifier(null);
  late ValueNotifier<SelectAllEvent?> setSelectAll;

  bool isFirstTimeBuild = true;
  Gender? currentGender;

  bool isSelectAll = false;

  @override
  void initState() {
    super.initState();
    maxItemSelected = widget.maxItemSelected ?? MAXIMUM_CHOOSE_SOGIESC;
    locator<CommonRepository>().getSogiesc();
    init();
  }

  init() {
    setSelectAll = widget.setSelectAll ?? ValueNotifier(null);
    currentGender = widget.selectedGender?.value;
    refreshSogiescOriginalList();
    if (widget.selectedGender?.value != null) {
      filterSogiescListWithGender(widget.selectedGender?.value!);
    }
  }

  refreshSogiescOriginalList() {
    sogiescOriginalList =
        List<Sogiesc>.from(locator<CommonRepository>().listSogiesc!);
  }

  setSelectedInitValue() {
    if (widget.initSogiescSelected?.isNotEmpty == true) {
      widget.initSogiescSelected?.forEach((initSelectedSogiesc) {
        filteredSogiescList.forEach((sogiesc) {
          if (initSelectedSogiesc?.id == sogiesc.id) {
            sogiesc.selected = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ValueListenableProvider.value(value: widget.selectedGender!),
          ValueListenableProvider.value(value: rebuildItem),
          ValueListenableProvider.value(value: setSelectAll),
        ],
        child: Consumer<Gender?>(
          builder: (context, gender, child) {
            filterSogiescListWithGender((widget.selectedGender?.value));
            if (currentGender == widget.selectedGender?.value) {
              setSelectedInitValue();
            } else {
              currentGender = widget.selectedGender?.value!;
            }
            return Consumer<SelectAllEvent?>(
                builder: (context, selectAllEvent, child) {
              if (selectAllEvent != null) {
                isSelectAll = !isSelectAll;
                filteredSogiescList.forEach((element) {
                  element.selected = isSelectAll;
                });
                if (widget.onSogiescSelected != null) {
                  widget.onSogiescSelected!(
                      isSelectAll ? filteredSogiescList : null);
                }
              }
              return Consumer<Object?>(
                builder: (context, rebuild, child) => Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: filteredSogiescList.isNotEmpty
                      ? filteredSogiescList
                          .map((sogiesc) => sogiesc.selected
                              ? _buildSelectedSogiesc(sogiesc)
                              : _buildNoneSelectedSogiesc(sogiesc))
                          .toList()
                      : [],
                ),
              );
            });
          },
        ));
  }

  Widget _buildSelectedSogiesc(Sogiesc sogiesc) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: getColor().colorPrimary, width: 1)),
        height: 30,
        child: Text(
          sogiesc.name?.localize(context) ?? "",
          style: textTheme(context).text13.bold.colorPrimary,
        ),
      ),
      onTap: () {
        onPressedItem(sogiesc);
      },
    );
  }

  onPressedItem(Sogiesc sogiesc) {
    if (!sogiesc.selected) {
      if (!isFullSelectedItem()) {
        sogiesc.selected = !sogiesc.selected;
        if (widget.onSogiescSelected != null) {
          widget.onSogiescSelected!(getSelectedSogiescList());
        }
        rebuildItem.value = Object();
      }
    } else {
      sogiesc.selected = !sogiesc.selected;
      if (widget.onSogiescSelected != null) {
        widget.onSogiescSelected!(getSelectedSogiescList());
      }
      rebuildItem.value = Object();
    }
  }

  bool isFullSelectedItem() {
    final selectedItems = getSelectedSogiescList();
    if (selectedItems.length == maxItemSelected) {
      showToast(
          "${Strings.chooseMax.localize(context)} $maxItemSelected ${Strings.label.localize(context)}");
      return true;
    }
    return false;
  }

  Widget _buildNoneSelectedSogiesc(Sogiesc sogiesc) {
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: getColor().b6b6cbColor, width: 1)),
        height: 30,
        child: Text(
          sogiesc.name?.localize(context) ?? "",
          style: textTheme(context).text13.bold.colorDart,
        ),
      ),
      onTap: () {
        onPressedItem(sogiesc);
      },
    );
  }

  List<Sogiesc> getSelectedSogiescList() {
    List<Sogiesc> result = [];
    filteredSogiescList.forEach((element) {
      if (element.selected) result.add(element);
    });
    return result;
  }

  filterSogiescListWithGender(Gender? gender) {
    if (gender == null) return;
    final genderFilter = GENDERS.firstWhere(
        (element) => element.id == gender.id,
        orElse: () => GENDERS[2]);
    filteredSogiescList.clear();
    if (genderFilter == GENDERS[2]) {
      // gender other
      sogiescOriginalList.forEach((element) {
        element.selected = false;
        if (element.type?.isNotEmpty == true) {
          filteredSogiescList.add(element);
        }
      });
    } else {
      sogiescOriginalList.forEach((element) {
        element.selected = false;
        if (element.type?.contains(genderFilter.key) == true) {
          filteredSogiescList.add(element);
        }
      });
    }
  }
}

class SelectAllEvent {}
