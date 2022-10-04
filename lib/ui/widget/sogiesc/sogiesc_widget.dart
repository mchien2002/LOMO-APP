import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/eventbus/close_suggestion_sogiesc_widget_event.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/sogiesc/tag_custom_widget.dart';
import 'package:provider/provider.dart';

import '../text_form_field_widget.dart';

class SogiescScreen extends StatefulWidget {
  final List<Sogiesc> listData;
  final TextEditingController? textController;
  final Function(Sogiesc)? onDelete;

  SogiescScreen(this.listData, {this.textController, this.onDelete});

  @override
  _SogiescScreenState createState() => _SogiescScreenState();
}

class _SogiescScreenState extends State<SogiescScreen> {
  @override
  Widget build(BuildContext context) {
    return DTextFromField(
      strokeColor: getColor().underlineClearTextField,
      leftTitle: Strings.sogiesc.localize(context),
      hintText:
          widget.listData.length < 1 ? Strings.sogiesc.localize(context) : null,
      controller: widget.textController,
      // enabled: false,
      prefixPadding: 0,
      prefixIcon: widget.listData.length < 1
          ? null
          : Wrap(
              spacing: 5,
              children: widget.listData.map(
                (s) {
                  return Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Chip(
                      backgroundColor: getColor().violet,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: Text(
                        s.name ?? "",
                        style: textTheme(context).text14Normal.colorWhite,
                      ),
                      onDeleted: () {
                        if (widget.onDelete != null) {
                          widget.onDelete!(s);
                        }
                      },
                      deleteIconColor: getColor().backgroundCancel,
                    ),
                  );
                },
              ).toList(),
            ),
      textStyle: textTheme(context).text16.colorPrimary,
    );
  }
}

//-----------------------Custom-------------------------------------

class BuildSogiescScreen extends StatefulWidget {
  final List<String> listData;
  final TextEditingController? textController;
  final String? leftTitle;
  final String? rightTitle;
  final String? hintText;

  BuildSogiescScreen(this.listData,
      {this.textController,
      this.leftTitle,
      this.rightTitle,
      this.hintText = ""});

  @override
  _BuildSogiescScreenState createState() => _BuildSogiescScreenState();
}

class _BuildSogiescScreenState extends State<BuildSogiescScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.leftTitle != null || widget.rightTitle != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.leftTitle ?? "",
                style: textTheme(context).text14Bold.colorDart,
              ),
              Text(
                widget.rightTitle ?? "",
                style: textTheme(context).caption?.colorDart,
              )
            ],
          ),
        SizedBox(
          height: 3,
        ),
        if (widget.listData.isNotEmpty != true)
          SizedBox(
            height: 3,
          ),
        _buildContent(),
        if (widget.listData.isNotEmpty != true)
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
    return Row(
      children: [
        Expanded(
          child: widget.listData.isNotEmpty == true
              ? Container(
                  width: MediaQuery.of(context).size.width -
                      34 -
                      Dimens.padding * 2,
                  height: 50,
                  child: ListView(
                    // spacing: 5,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: widget.listData.map(
                      (s) {
                        return _buildItem(s);
                      },
                    ).toList(),
                  ),
                )
              : Text(
                  widget.hintText ?? "",
                  style: textTheme(context).subText.colorHint,
                ),
        ),
        SvgPicture.asset(
          DIcons.expand,
          height: 24,
          width: 24,
          color: getColor().colorPrimary,
        ),
      ],
    );
  }

  Widget _buildItem(String s) {
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Chip(
        backgroundColor: getColor().violet,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(
          s,
          style: textTheme(context).text14Normal.colorWhite,
        ),
        // onDeleted: () {
        //   snapshot.data.remove(s);
        //   model.sogiescSubject.sink.add(snapshot.data);
        // },
      ),
    );
  }
}

//---------------------Tag------------------------------------

class SogiescTagScreen<T> extends StatefulWidget {
  final List<T> listData;
  final List<T> listFull;
  final TextEditingController textController;
  final Function(T)? onDelete;
  final Function(T)? onSelect;
  final String Function(T) getName;
  final String? leftTitle;
  final String? rightTitle;
  final String? hintText;
  final EdgeInsets? suggestPadding;
  final EdgeInsets? suggestMargin;
  final String? centerTitle;

  SogiescTagScreen(
      this.listData, this.textController, this.listFull, this.getName,
      {this.onDelete,
      this.hintText,
      this.leftTitle,
      this.rightTitle,
      this.onSelect,
      this.centerTitle,
      this.suggestPadding = const EdgeInsets.symmetric(horizontal: 20),
      this.suggestMargin =
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10)});

  @override
  _SogiescTagScreenState<T> createState() => _SogiescTagScreenState<T>();
}

class _SogiescTagScreenState<T> extends State<SogiescTagScreen<T>> {
  Timer? _debounce;
  ValueNotifier<List<T>?> data = ValueNotifier(null);
  FocusNode focusNode = new FocusNode();
  bool isShowPopup = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<CloseSuggestSogiescWidgetEvent>().listen((event) async {
      data.value = [];
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
                    style: textTheme(context).text14Bold.colorDart,
                  ),
                  SizedBox(
                    width: Dimens.size10,
                  ),
                  Text(
                    widget.centerTitle ?? "",
                    style: textTheme(context).text14Normal.colorGray,
                  ),
                ],
              ),
              Text(
                widget.rightTitle ?? "",
                style: textTheme(context).caption?.colorDart,
              )
            ],
          ),
        SizedBox(
          height: 3,
        ),
        if (widget.listData.isNotEmpty != true)
          SizedBox(
            height: 3,
          ),
        _buildContent(),
        if (widget.listData.isNotEmpty != true)
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
              itemsSuggest.isNotEmpty == true
                  ? _buildMenuSuggest()
                  : Container(),
        ),
      ),
    );
  }

  Widget _buildMenuSuggest() {
    return SogiescSuggestion(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: getColor().white,
        boxShadow: [
          BoxShadow(
              color: getColor().shadowMainTabBar,
              blurRadius: 2.0,
              offset: Offset(0, 2)),
          BoxShadow(
              color: getColor().shadowMainTabBar,
              blurRadius: 2.0,
              offset: Offset(0, -2))
        ],
      ),
      padding: widget.suggestPadding!,
      margin: widget.suggestMargin!,
      height: data.value!.length > 4 ? 200.0 : data.value!.length * 50.0,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: data.value?.length ?? 0,
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (widget.onSelect != null)
                    widget.onSelect!(data.value![index]);
                  widget.textController.text = "";
                  data.value = [];
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
                          widget.getName(data.value![index]),
                          style: textTheme(context).text14Normal.colorDart,
                        ),
                      )),
                      if (index != data.value!.length - 1)
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
    return widget.listData.isNotEmpty == true
        ? TagEditor(
            textController: widget.textController,
            length: widget.listData.length,
            focusNode: focusNode,
            textStyle: textTheme(context).text14Normal.colorDart,
            onTextChange: (value) async {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
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
              hintStyle: textTheme(context).subText.colorHint,
            ),
            tagBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: getColor().colorGrayC1),
                  ),
                  margin: EdgeInsets.only(top: 8),
                  height: 32,
                  child: Chip(
                    padding: EdgeInsets.all(0),
                    backgroundColor: getColor().white,
                    label: Text(
                      widget.getName(widget.listData[index]),
                      style: textTheme(context).text14Normal.colorDart,
                    ),
                    onDeleted: () {
                      if (widget.onDelete != null) {
                        widget.onDelete!(widget.listData[index]);
                      }
                      widget.listData.removeAt(index);
                    },
                    deleteIconColor: getColor().colorGrayC1,
                  ),
                ),
              );
            },
          )
        : TextField(
            controller: widget.textController,
            focusNode: focusNode,
            style: textTheme(context).text14Normal.colorDart,
            onChanged: (value) async {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                await searchSogiesc(value.trim());
              });
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 3, top: 3),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: textTheme(context).subText.colorHint,
            ),
          );
  }

  searchSogiesc(String keySearch) async {
    if (keySearch == "") {
      data.value = [];
    } else {
      data.value = widget.listFull
          .where((element) =>
              removeDiacritics(widget.getName(element).toLowerCase())
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

class SogiescSuggestion extends Container {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final Clip clipBehavior;

  SogiescSuggestion({
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
