import 'package:flutter/material.dart';

class OptionList extends StatelessWidget {
  OptionList(
      {this.data,
      this.onTap,
      this.suggestionListHeight,
      this.suggestionBuilder,
      this.suggestionListDecoration,
      this.suggestionMargin = const EdgeInsets.all(0),
      this.suggestionPadding = const EdgeInsets.all(0)});

  final EdgeInsets? suggestionPadding;

  final EdgeInsets? suggestionMargin;

  final Widget Function(Map<String, dynamic>)? suggestionBuilder;

  final List<Map<String, dynamic>>? data;

  final Function(Map<String, dynamic>)? onTap;

  final double? suggestionListHeight;

  final BoxDecoration? suggestionListDecoration;

  @override
  Widget build(BuildContext context) {
    return data!.isNotEmpty
        ? Container(
            decoration:
                suggestionListDecoration ?? BoxDecoration(color: Colors.white),
            margin: suggestionMargin,
            padding: suggestionPadding,
            constraints: BoxConstraints(
              maxHeight: suggestionListHeight!,
              minHeight: 0,
            ),
            child: ListView.builder(
              itemCount: data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onTap!(data![index]);
                  },
                  child: suggestionBuilder != null
                      ? suggestionBuilder!(data![index])
                      : Container(
                          color: Colors.blue,
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            data![index]['display'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                );
              },
            ),
          )
        : Container();
  }
}