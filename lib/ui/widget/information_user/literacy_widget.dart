import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:rxdart/rxdart.dart';

import '../bottom_sheet_widgets.dart';
import '../empty_widget.dart';
import '../loading_widget.dart';
import '../wheel_list_picker_widget.dart';

class DropdownLiteracyWidget extends StatefulWidget {
  final Future<List<Literacy>?> Function()? getDropdown;
  final List<Literacy>? items;
  final Function(Literacy)? onSelected;
  final String? initValue;
  final String? titleContentPopUp;

  DropdownLiteracyWidget(
      {this.initValue,
      this.onSelected,
      this.titleContentPopUp,
      this.getDropdown,
      this.items});

  @override
  _DropdownLiteracyWidgetState createState() => _DropdownLiteracyWidgetState();
}

class _DropdownLiteracyWidgetState
    extends BaseState<LiteracyWidgetModel, DropdownLiteracyWidget> {
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
  Widget buildContentView(BuildContext context, LiteracyWidgetModel model) {
    return StreamBuilder<List<Literacy>>(
        stream: model.listItemsSubject.stream,
        builder: (context, snapshot) {
          return BottomSheetPickerModel(
            height: 300,
            onDone: () {
              if (widget.onSelected != null)
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
            title: widget.titleContentPopUp!,
          );
        });
  }

  @override
  LiteracyWidgetModel createModel() {
    return LiteracyWidgetModel(widget.getDropdown!);
  }
}

class LiteracyWidgetModel extends BaseModel {
  LiteracyWidgetModel(this.getDropdown);

  Future<List<Literacy>?> Function() getDropdown;

  @override
  ViewState get viewState => ViewState.loaded;

  final listItemsSubject = BehaviorSubject<List<Literacy>>();

  getListItems() async {
    await callApi(doSomething: () async {
      var response = await getDropdown();
      print(response!.length);
      listItemsSubject.sink.add(response);
    });
  }

  @override
  void dispose() {
    super.dispose();
    listItemsSubject.close();
  }
}
