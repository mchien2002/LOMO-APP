import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/close_suggest_tag_cloud_event.dart';
import 'package:lomo/data/eventbus/reset_suggest_tag_clound_event.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/sogiesc/tag_custom_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:provider/provider.dart';

class TagCloudScreen<T> extends StatefulWidget {
  final List<T> initialValue;
  final List<T> listFull;
  final TextEditingController textController;
  final Function(List<T>)? onValueChanged;
  final String Function(T) getName;
  final String? leftTitle;
  final String? rightTitle;
  final String? hintText;
  final EdgeInsets suggestPadding;
  final EdgeInsets suggestMargin;
  final String? centerTitle;
  final Widget? suffixIcon;
  final int maxItemSelect;

  TagCloudScreen(this.initialValue, this.textController, this.listFull, this.getName,
      {this.onValueChanged,
      this.hintText,
      this.leftTitle,
      this.rightTitle,
      this.centerTitle,
      this.suffixIcon,
      this.suggestPadding = const EdgeInsets.symmetric(horizontal: 20),
      this.suggestMargin = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      this.maxItemSelect = 999});

  @override
  _TagCloudScreenState<T> createState() => _TagCloudScreenState<T>();
}

class _TagCloudScreenState<T> extends State<TagCloudScreen<T>> {
  Timer? _debounce;
  ValueNotifier<List<T>> data = ValueNotifier([]);
  FocusNode focusNode = new FocusNode();
  bool isShowPopup = false;

  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNotEmpty == true) {
      selectedItems = List<T>.from(widget.initialValue);
    } else {
      selectedItems = [];
    }

    eventBus.on<CloseSuggestTagCloudEvent>().listen((event) async {
      data.value = [];
    });

    //reset data (filter dating screen)
    eventBus.on<ResetSuggestTagCloudEvent>().listen((event) async {
      selectedItems = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.leftTitle != null || widget.rightTitle != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.leftTitle ?? "",
                    style: textTheme(context).text13.bold.colorDart,
                  ),
                  SizedBox(
                    width: Dimens.size10,
                  ),
                  Text(
                    widget.centerTitle ?? "",
                    style: textTheme(context).text13.colorGray,
                  ),
                ],
              ),
              Text(
                widget.rightTitle ?? "",
                style: textTheme(context).caption!.colorDart,
              )
            ],
          ),
        SizedBox(
          height: 3,
        ),
        if (selectedItems.isNotEmpty != true)
          SizedBox(
            height: 3,
          ),
        _buildContent(),
        if (selectedItems.isNotEmpty != true)
          SizedBox(
            height: 2,
          ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: getColor().underlineClearTextField,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return PortalEntry(
      portalAnchor: Alignment.bottomCenter,
      childAnchor: Alignment.topCenter,
      child: _buildEditor(),
      portal: ValueListenableProvider.value(
        value: data,
        child: Consumer<List<T>>(
          builder: (context, itemsSuggest, child) =>
              itemsSuggest.isNotEmpty == true ? _buildMenuSuggest() : Container(),
        ),
      ),
    );
  }

  Widget _buildMenuSuggest() {
    return TagCloudSuggestion(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: getColor().white,
        boxShadow: [
          BoxShadow(color: getColor().shadowMainTabBar, blurRadius: 2.0, offset: Offset(0, 2)),
          BoxShadow(color: getColor().shadowMainTabBar, blurRadius: 2.0, offset: Offset(0, -2))
        ],
      ),
      padding: widget.suggestPadding,
      margin: widget.suggestMargin,
      height: data.value.length > 4 ? 200.0 : data.value.length * 50.0,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: data.value.length,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  bool check = true;
                  for (int i = 0; i < selectedItems.length; i++) {
                    if (data.value[index] == selectedItems[i]) {
                      check = false;
                      break;
                    }
                  }
                  if (!check) {
                    showToast(Strings.selected.localize(context));
                  } else if (selectedItems.length == widget.maxItemSelect) {
                    showToast("${Strings.chooseMax3Item.localize(context)}");
                    data.value = [];
                  } else {
                    selectedItems.add(data.value[index]);
                    if (widget.onValueChanged != null) {
                      widget.onValueChanged!(selectedItems);
                    }
                    widget.textController.text = "";
                    data.value = [];
                    setState(() {});
                  }
                },
                child: SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.getName(data.value[index]),
                          style: textTheme(context).text14Normal.colorDart,
                        ),
                      )),
                      if (index != data.value.length - 1)
                        Divider(
                          height: 1,
                          color: getColor().colorDivider,
                        )
                    ],
                  ),
                ),
              )),
    );
  }

  Widget _buildEditor() {
    return selectedItems.isNotEmpty == true
        ? TagEditor(
            textController: widget.textController,
            length: selectedItems.length,
            focusNode: focusNode,
            textStyle: textTheme(context).text19.light.colorDart,
            onTextChange: (value) async {
              if (_debounce?.isActive == true) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                // FocusScope.of(context).unfocus();
                await searchSogiesc(value.trim());
              });
            },
            delimiters: [',', ' '],
            hasAddButton: false,
            inputDecoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: textTheme(context).text19.light.colorHint,
              suffixIcon: widget.suffixIcon,
              suffixIconConstraints:
                  const BoxConstraints(maxWidth: 24, maxHeight: 24, minHeight: 24),
            ),
            tagBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17), color: getColor().colorGrayOpacity),
                margin: EdgeInsets.only(top: 8, right: 9),
                height: 32,
                child: Chip(
                  padding: EdgeInsets.only(left: 10),
                  labelPadding: EdgeInsets.only(right: 0, left: 0),
                  backgroundColor: getColor().colorGrayOpacity,
                  label: Text(
                    widget.getName(selectedItems[index]),
                    style: textTheme(context).text13.bold.colorDart,
                  ),
                  onDeleted: () {
                    selectedItems.removeAt(index);
                    if (widget.onValueChanged != null) {
                      widget.onValueChanged!(selectedItems);
                    }
                    setState(() {});
                  },
                  deleteIcon: Container(
                    alignment: Alignment.center,
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: getColor().white),
                    child: Icon(
                      Icons.close,
                      color: getColor().grayBorder,
                      size: 12,
                    ),
                  ),
                ),
              );
            },
          )
        : TextField(
            controller: widget.textController,
            focusNode: focusNode,
            style: textTheme(context).text19.light.colorDart,
            onChanged: (value) async {
              if (_debounce?.isActive == true) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                await searchSogiesc(value.trim());
              });
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 3, top: 3),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: textTheme(context).text19.light.colorHint,
              suffixIcon: widget.suffixIcon,
              suffixIconConstraints:
                  const BoxConstraints(maxWidth: 24, maxHeight: 24, minHeight: 24),
            ),
          );
  }

  searchSogiesc(String? keySearch) async {
    if (keySearch == "" || keySearch == null) {
      data.value = [];
    } else {
      data.value = widget.listFull
          .where((element) => removeDiacritics(widget.getName(element).toLowerCase())
              .contains(removeDiacritics(keySearch.toLowerCase())))
          .toList();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }
}

class TagCloudSuggestion extends Container {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final Clip clipBehavior;

  TagCloudSuggestion({
    Key? key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.child,
    this.clipBehavior = Clip.none,
  }) : super(
            key: key,
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            child: child,
            clipBehavior: clipBehavior);
}
