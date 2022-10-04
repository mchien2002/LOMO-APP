import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/dropdown_api_widget_model.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/ui/widget/search_bar_widget.dart';
import 'package:lomo/ui/widget/wheel_list_picker_widget.dart';

import 'bottom_sheet_widgets.dart';

class DropdownZodiacWidget extends StatefulWidget {
  final Future<List<Zodiac>?> Function() getDropdown;
  final List<Zodiac>? items;
  final Function(Zodiac)? onSelected;
  final String? initValue;
  final String? titleContentPopUp;
  DropdownZodiacWidget(
      {this.initValue,
      this.onSelected,
      this.titleContentPopUp,
      required this.getDropdown,
      this.items});
  @override
  _DropdownZodiacWidgetState createState() => _DropdownZodiacWidgetState();
}

class _DropdownZodiacWidgetState
    extends BaseState<DropdownApiWidgetModel, DropdownZodiacWidget> {
  TextEditingController _controller = TextEditingController();
  int selectedIndex = 0; // 160 cm

  @override
  void initState() {
    super.initState();
    if (widget.items?.isEmpty == true || widget.items == null) {
      model.getListItems();
    } else {
      model.listItemsSubject.sink.add(widget.items!);
    }
  }

  @override
  Widget buildContentView(BuildContext context, DropdownApiWidgetModel model) {
    return StreamBuilder<List<Zodiac>>(
        stream: model.listItemsSubject.stream,
        builder: (context, snapshot) {
          return BottomSheetPickerModel(
            height: 300,
            onDone: () {
              if (widget.onSelected != null && snapshot.data != null)
                widget.onSelected!(snapshot.data![selectedIndex]);
              _controller.text = snapshot.data![selectedIndex].name!;
            },
            isFull: false,
            contentWidget: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
              child: snapshot.hasData
                  ? snapshot.data?.isNotEmpty == true
                      ? WheelListPickerWidget(
                          initItemIndex: widget.initValue != null
                              ? snapshot.data!
                                  .map((e) => e.name)
                                  .toList()
                                  .indexOf(widget.initValue)
                              : selectedIndex,
                          items: snapshot.data!.map((e) => e.name!).toList(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        )
                      : Center(
                          child: EmptyWidget(),
                        )
                  : Center(
                      child: LoadingWidget(
                        radius: 15,
                      ),
                    ),
            ),
            title: widget.titleContentPopUp,
          );
        });
  }

  @override
  DropdownApiWidgetModel createModel() {
    return DropdownApiWidgetModel(widget.getDropdown);
  }
}

class DropdownSogiescWidget extends StatefulWidget {
  final Future<List<Sogiesc>> Function() getDropdown;
  final List<Sogiesc>? items;
  final Function(List<Sogiesc>)? onSelected;
  final List<Sogiesc>? initItems;
  final List<int>? initSort;
  final String? titleContentPopUp;
  DropdownSogiescWidget(
      {this.initItems,
      this.initSort,
      this.onSelected,
      this.titleContentPopUp,
      required this.getDropdown,
      this.items});
  @override
  _DropdownSogiescWidgetState createState() => _DropdownSogiescWidgetState();
}

class _DropdownSogiescWidgetState
    extends BaseState<DropdownSogiescWidgetModel, DropdownSogiescWidget> {
  int selectedIndex = 0; // 160 cm

  @override
  void initState() {
    super.initState();
    if (widget.items?.isEmpty == true || widget.items == null) {
      model.getListItems();
    } else {
      model.listSogiescs = List.from(widget.items!);
      model.listItemsSubject.sink.add(widget.items!);
    }
    if (widget.initItems?.isNotEmpty == true) {
      model.listSelected = List.from(widget.initItems!);
    }
  }

  @override
  Widget buildContentView(
      BuildContext context, DropdownSogiescWidgetModel model) {
    return StreamBuilder<List<Sogiesc>>(
        stream: model.listItemsSubject.stream,
        builder: (context, snapshot) {
          //------init index item -------------------------
          model.initIndexForItem(snapshot.data);
          return BottomSheetPickerModel(
            isHideRightWidget: false,
            height: MediaQuery.of(context).size.height * 14 / 16,
            onDone: () {
              if (widget.onSelected != null)
                widget.onSelected!(model.listSelected);
              // if (model.listSelected?.isEmpty == true) {
              //   showToast(Strings.noData.localize(context));
              // }
            },
            isFull: false,
            contentWidget: Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 23),
                    child: SearchBarWidget(
                      hint: Strings.sogiesc.localize(context),
                      onTextChanged: (text) {
                        model.searchSogiesc(text);
                      },
                    ),
                  ),
                  Expanded(
                    child: snapshot.hasData
                        ? snapshot.data?.isNotEmpty == true
                            ? SogiescsListPickerWidget(
                                initItemIndex:
                                    widget.initItems?.isNotEmpty == true
                                        ? widget.initItems!
                                            .map((e) => e.name!)
                                            .toList()
                                        : [],
                                items:
                                    snapshot.data!.map((e) => e.name!).toList(),
                                onSelectedItemChanged: (index) {
                                  model.selectedAction(snapshot.data, index);
                                },
                              )
                            : Center(
                                child: EmptyWidget(),
                              )
                        : Center(
                            child: LoadingWidget(
                              radius: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            title: widget.titleContentPopUp,
          );
        });
  }

  @override
  DropdownSogiescWidgetModel createModel() {
    return DropdownSogiescWidgetModel(widget.getDropdown);
  }
}

class DropdownRelationshipWidget extends StatefulWidget {
  final Future<List<Relationship>?> Function() getDropdown;
  final List<Relationship>? items;
  final Function(Relationship)? onSelected;
  final String? initValue;
  final String? titleContentPopUp;
  DropdownRelationshipWidget(
      {this.initValue,
      this.onSelected,
      this.titleContentPopUp,
      required this.getDropdown,
      this.items});
  @override
  _DropdownRelationshipWidgetState createState() =>
      _DropdownRelationshipWidgetState();
}

class _DropdownRelationshipWidgetState extends BaseState<
    DropdownRelationshipWidgetModel, DropdownRelationshipWidget> {
  TextEditingController _controller = TextEditingController();
  int selectedIndex = 0; // 160 cm

  @override
  void initState() {
    super.initState();
    if (widget.items?.isEmpty == true || widget.items == null) {
      model.getListItems();
    } else {
      model.listItemsSubject.sink.add(widget.items!);
    }
  }

  @override
  Widget buildContentView(
      BuildContext context, DropdownRelationshipWidgetModel model) {
    return StreamBuilder<List<Relationship>>(
        stream: model.listItemsSubject.stream,
        builder: (context, snapshot) {
          return BottomSheetPickerModel(
            height: 300,
            onDone: () {
              if (widget.onSelected != null && snapshot.data != null)
                widget.onSelected!(snapshot.data![selectedIndex]);
              _controller.text = snapshot.data![selectedIndex].name!;
            },
            isFull: false,
            contentWidget: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
              child: snapshot.hasData
                  ? snapshot.data?.isNotEmpty == true
                      ? WheelListPickerWidget(
                          initItemIndex: widget.initValue != null
                              ? snapshot.data!
                                  .map((e) => e.name)
                                  .toList()
                                  .indexOf(widget.initValue)
                              : selectedIndex,
                          items: snapshot.data!.map((e) => e.name!).toList(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        )
                      : Center(
                          child: EmptyWidget(),
                        )
                  : Center(
                      child: LoadingWidget(
                        radius: 15,
                      ),
                    ),
            ),
            title: widget.titleContentPopUp,
          );
        });
  }

  @override
  DropdownRelationshipWidgetModel createModel() {
    return DropdownRelationshipWidgetModel(widget.getDropdown);
  }
}

class DropdownAddressWidget extends StatefulWidget {
  final Future<List<City>> Function({required String id}) getDropdown;
  final List<City>? items;
  final Function(City)? onSelected;
  final String? initValue;
  final String? titleContentPopUp;
  final String? idInitial;
  DropdownAddressWidget(
      {this.initValue,
      this.onSelected,
      this.titleContentPopUp,
      required this.getDropdown,
      this.items,
      this.idInitial});
  @override
  _DropdownAddressWidgetState createState() => _DropdownAddressWidgetState();
}

class _DropdownAddressWidgetState
    extends BaseState<DropdownAddressWidgetModel, DropdownAddressWidget> {
  TextEditingController _controller = TextEditingController();
  late int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.items?.isEmpty == true || widget.items == null) {
      model.getListItems(id: widget.idInitial ?? "0");
    } else {
      model.listItemsSubject.sink.add(widget.items!);
    }
  }

  @override
  Widget buildContentView(
      BuildContext context, DropdownAddressWidgetModel model) {
    return StreamBuilder<List<City>>(
        stream: model.listItemsSubject.stream,
        builder: (context, snapshot) {
          return BottomSheetPickerModel(
            isHideRightWidget: true,
            height: MediaQuery.of(context).size.height * 3 / 4,
            onDone: () {
              if (widget.onSelected != null && snapshot.data != null)
                widget.onSelected!(snapshot.data![selectedIndex]);
              _controller.text = snapshot.data![selectedIndex].name;
            },
            isFull: false,
            contentWidget: snapshot.hasData
                ? snapshot.data?.isNotEmpty == true
                    ? NormalListPickerWidget(
                        initItemIndex:
                            widget.initValue != null && widget.initValue != ""
                                ? snapshot.data!
                                    .map((e) => e.name)
                                    .toList()
                                    .indexOf(widget.initValue!)
                                : selectedIndex,
                        items: snapshot.data!.map((e) => e.name).toList(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                            if (widget.onSelected != null)
                              widget.onSelected!(snapshot.data![selectedIndex]);
                            _controller.text =
                                snapshot.data![selectedIndex].name;
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    : Center(
                        child: EmptyWidget(),
                      )
                : Center(
                    child: LoadingWidget(
                      radius: 15,
                    ),
                  ),
            title: widget.titleContentPopUp,
          );
        });
  }

  @override
  DropdownAddressWidgetModel createModel() {
    return DropdownAddressWidgetModel(widget.getDropdown);
  }
}
