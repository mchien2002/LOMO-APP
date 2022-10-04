import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/notification_type.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';

class SelectedPopupWidget extends StatefulWidget {
  final List<NotificationType>? listItems;
  final Function(NotificationType) selectedItem;
  final NotificationType? initItem;

  const SelectedPopupWidget({Key? key, this.listItems, this.initItem, required this.selectedItem})
      : super(key: key);

  @override
  _SelectedPopupWidgetState createState() => _SelectedPopupWidgetState();
}

class _SelectedPopupWidgetState extends State<SelectedPopupWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 27),
      decoration: BoxDecoration(
        color: getColor().white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Strings.filterNotification.localize(context),
                    style: textTheme(context).text18.bold.colorDart,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                  child: InkWell(
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: getColor().colorDart,
                    ),
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: getColor().backgroundCancel,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.listItems?.length ?? 0,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
 widget.selectedItem(widget.listItems![index]);
                    Navigator.pop(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 10),
                              child: Text(
                                widget.listItems![index].name?.localize(context) ?? "",
                                style: widget.initItem == widget.listItems![index]
                                    ? textTheme(context).text16.colorViolet
                                    : textTheme(context).text16.colorDart,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: getColor().colorVioletEB,
                                image: widget.initItem == widget.listItems![index]
                                    ? DecorationImage(
                                        image: AssetImage(DImages.check), fit: BoxFit.cover)
                                    : null),
                          ),
                          SizedBox(
                            width: 25,
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        color: getColor().backgroundCancel,
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
