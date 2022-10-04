import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import 'text_form_field_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final String? hint;
  final Function(String)? onTextChanged;
  final bool autoFocus;
  final TextStyle? textStyle;
  final Widget? searchIcon;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  SearchBarWidget(
      {this.hint,
      this.onTextChanged,
      this.autoFocus = false,
      this.textStyle,
      this.searchIcon,
      this.controller,
      this.textInputAction,
      this.onFieldSubmitted});

  @override
  State<StatefulWidget> createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchQuery;
  Timer? _debounce;

  _onSearchChanged() {
    setState(() {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (widget.onTextChanged != null) {
          widget.onTextChanged!(_searchQuery.text);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.controller ?? TextEditingController();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      color: getColor().backgroundSearch,
      child: DTextFromField(
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        strokeColor: Colors.transparent,
        autoFocus: widget.autoFocus,
        controller: _searchQuery,
        hintText: widget.hint,
        textStyle: widget.textStyle ?? textTheme(context).text13.ff261744Color,
        prefixIcon: widget.searchIcon ??
            Image.asset(
              DImages.icTabSearch,
              width: Dimens.size24,
              height: Dimens.size24,
            ),
        prefixConstraints: const BoxConstraints(maxHeight: 36, minHeight: 36),
        iconContraints:
            const BoxConstraints(maxWidth: 44, maxHeight: 24, minHeight: 24),
        suffixIcon: _searchQuery.text != ""
            ? MaterialButton(
                height: Dimens.size24,
                minWidth: Dimens.size24,
                padding: EdgeInsets.all(0),
                onPressed: () => _searchQuery.clear(),
                child: Image.asset(
                  DImages.clearText,
                  height: Dimens.size24,
                  width: Dimens.size24,
                ),
                shape: CircleBorder(),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
