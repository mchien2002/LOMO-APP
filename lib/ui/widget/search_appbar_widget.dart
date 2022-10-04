import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:rxdart/rxdart.dart';

class SearchInputWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? placeHolder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final TextStyle hintStyle;
  final Color? backgroundColor;
  final Color? textFieldColor;
  final Widget? iconSearch;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Widget? itemRight;
  final Function(User)? onClicked;
  final bool isShowScan;
  final Function(String)? getCodeScan;

  SearchInputWidget({
    Key? key,
    this.placeHolder,
    this.isShowScan = true,
    this.getCodeScan,
    this.onChanged,
    this.onSubmitted,
    this.style,
    this.backgroundColor,
    this.hintStyle = const TextStyle(color: Color(0xffB5B5B5), fontSize: 12),
    this.iconSearch,
    this.radius = 18,
    this.padding =
        const EdgeInsets.only(left: Dimens.spacing12, right: Dimens.spacing12),
    this.itemRight,
    this.textFieldColor,
    this.onClicked,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SearchInputWidgetState();
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class SearchInputWidgetState extends State<SearchInputWidget> {
  TextEditingController _textFieldController = TextEditingController(text: "");
  BehaviorSubject<String> streamController = BehaviorSubject<String>();
  late String text;
  Uint8List bytes = Uint8List(0);

  onChanged(txt) {
    streamController.sink.add(txt);
    widget.onChanged!(txt);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _appbar();
  }

  Widget _appbar() {
    return SliverAppBar(
      toolbarHeight: 60,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: widget.backgroundColor,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      title: Row(
        children: [
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, Routes.searchUser);
                if (result != null) widget.onClicked!(result as User);
              },
              child: Material(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.textFieldColor,
                elevation: 2,
                child: Container(
                  padding: widget.padding,
                  alignment: Alignment.centerLeft,
                  height: 38,
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      widget.iconSearch ??
                          Image.asset(
                            DImages.icTabSearch,
                            width: 23,
                            height: 23,
                            color: getColor().textDart,
                          ),
                      SizedBox(
                        width: 6,
                      ),
                      _searchInputWidget(),
                      if (widget.itemRight != null)
                        SizedBox(
                          width: 12,
                        ),
                      widget.itemRight ?? Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isShowScan,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () async {},
                child: Image.asset(
                  DImages.icScan,
                  width: 34,
                  height: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchInputWidget() {
    return Flexible(
      flex: 1,
      child: StreamBuilder(
        initialData: _textFieldController.text,
        stream: streamController.stream,
        builder: (context, snapshot) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    minLines: 1,
                    style: widget.style != null
                        ? widget.style
                        : TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.search,
                    onChanged: (txt) {
                      onChanged(txt);
                    },
                    onFieldSubmitted: (txt) {
                      widget.onSubmitted!(txt);
                    },
                    controller: _textFieldController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        hintText: widget.placeHolder,
                        hintStyle: widget.hintStyle,
                        border: InputBorder.none),
                  ),
                ),
                if (_textFieldController.text != "" &&
                    _textFieldController.text.isNotEmpty)
                  GestureDetector(
                      child: Container(
                        width: 24,
                        height: 24,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.clear,
                          size: 24,
                          color: getColor().textDart,
                        ), //TODO: color
                      ),
                      onTap: () {
                        widget.onSubmitted!("");
                        _textFieldController.clear();
                        streamController.sink.add("");
                      }),
              ],
            ),
          );
        },
      ),
    );
  }
}
