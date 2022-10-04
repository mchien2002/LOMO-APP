import 'package:flutter/material.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class MessageOfThemeScreen extends StatefulWidget {
  final List<String> messages;
  final Function(String)? onMessageSelected;

  MessageOfThemeScreen({required this.messages, this.onMessageSelected});

  @override
  _MessageOfThemeScreenState createState() => _MessageOfThemeScreenState();
}

class _MessageOfThemeScreenState extends State<MessageOfThemeScreen> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: widget.messages
            .map((e) => InkWell(
                  onTap: () {
                    if (this.widget.onMessageSelected != null) {
                      widget.onMessageSelected!(e);
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: getColor().gray2eaColor)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Text(
                          e,
                          style: textTheme(context).text13.ff261744Color,
                        ),
                      )),
                ))
            .toList(),
      ),
    );
  }
}
