import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class BottomSheetModal extends StatefulWidget {
  final String? title;
  final Widget? left;
  final Widget? right;
  final double? height;
  final bool isFull;
  final Color? color;
  final Widget contentWidget;
  final bool isVisibilityAppbar;

  const BottomSheetModal({
    required this.isFull,
    required this.contentWidget,
    this.title,
    this.left,
    this.right,
    this.color,
    this.isVisibilityAppbar = false,
    this.height = 280,
  });

  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isFull
          ? (MediaQuery.of(context).size.height * 14 / 16)
          : widget.height,
      decoration: BoxDecoration(
        color: widget.color ?? Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Visibility(
              visible: widget.isVisibilityAppbar,
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                  color: widget.color ?? Colors.white,
                ),
              )),
          Visibility(
            visible: !widget.isVisibilityAppbar,
            child: Material(
              color: widget.color ?? Colors.white,
              child: Container(
                height: 75,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimens.padding_left_right,
                    right: Dimens.padding_left_right,
                    top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (widget.left != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: widget.left,
                      ),
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style: textTheme(context).text18Bold.colorDart,
                      ),
                    if (widget.right != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: widget.right,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: widget.contentWidget,
          ),
        ],
      ),
    );
  }
}

class GenderBottomSheet extends StatefulWidget {
  final String? title;
  final List<String>? items;
  final String? initialValue;
  final double? height;
  final bool isVisibility;
  final Function(String)? selectedItem;

  const GenderBottomSheet(
      {this.title = "",
      this.items,
      this.initialValue,
      this.selectedItem,
      this.height,
      this.isVisibility = false});

  @override
  _GenderBottomState createState() => _GenderBottomState();
}

class _GenderBottomState extends State<GenderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      isFull: false,
      isVisibilityAppbar: widget.isVisibility,
      contentWidget: _content(),
      title: widget.title,
      height: widget.height ?? 180,
    );
  }

  _content() {
    return Container(
      color: Colors.white,
      child: widget.items?.isNotEmpty == true
          ? Container()
          : ListView.builder(
              itemCount: widget.items!.length,
              itemBuilder: (BuildContext context, int index) {
                return SupBottomItem(
                  item: widget.items![index].localize(context),
                  callBack: _onTapButton,
                  index: index,
                  initialValue: widget.initialValue,
                  lastIndex: widget.items!.length - 1,
                );
              },
            ),
    );
  }

  void _onTapButton(String value) {
    if (widget.selectedItem != null) widget.selectedItem!(value);
    Navigator.pop(context);
  }
}

class SupBottomItem extends StatefulWidget {
  final String item;
  final int index;
  final String? initialValue;
  final int lastIndex;
  final Function(String)? callBack;

  const SupBottomItem(
      {required this.item,
      this.callBack,
      required this.index,
      this.initialValue,
      required this.lastIndex});

  @override
  _SupBottomItemState createState() => _SupBottomItemState();
}

class _SupBottomItemState extends State<SupBottomItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.callBack != null) widget.callBack!(widget.item);
      },
      child: Container(
          color: Colors.white,
          height: 50,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    widget.item,
                    style: widget.item == "Xóa"
                        ? textTheme(context).text18.colorError
                        : textTheme(context).text18.colorDart,
                  ),
                ),
              ),
              if (widget.index != widget.lastIndex)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 1,
                    color: getColor().colorDivider,
                  ),
                ),
            ],
          )),
    );
  }
}
