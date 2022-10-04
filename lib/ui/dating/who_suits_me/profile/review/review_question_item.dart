import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/my_question/my_question_view.dart';

class ReviewQuestionItem extends StatefulWidget {
  final WhoSuitsMeQuestion item;
  final int index;
  final TextEditingController controller;

  ReviewQuestionItem(this.item, this.index, this.controller);

  @override
  State<StatefulWidget> createState() => _ReviewQuestionItemState();
}

class _ReviewQuestionItemState extends State<ReviewQuestionItem> {
  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: Column(
        children: [
          MyQuestionView(
            whoSuitsMeQuestion: widget.item,
            index: widget.index,
            isEdit: false,
            controller: widget.controller,
          ),
          SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: widget.item.answers[index].isSelected
                        ? widget.item.answers[index].isTrue
                            ? getColor().colorBlue2cd1
                            : getColor().colorRedFf6388
                        : getColor().gray6ebColor,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.only(left: 19, right: 4, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.answers[index].name!,
                        style: widget.item.answers[index].isSelected
                            ? textTheme(context).text15.colorWhite
                            : textTheme(context).text15.colorDart,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      height: 32,
                      width: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getColor().white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: widget.item.answers[index].isSelected
                          ? widget.item.answers[index].isTrue
                              ? Image.asset(
                                  DImages.check,
                                  color: getColor().colorBlue2cd1,
                                  width: 24,
                                  height: 24,
                                )
                              : Image.asset(
                                  DImages.closex,
                                  color: getColor().colorRedFf6388,
                                  width: 24,
                                  height: 24,
                                )
                          : Container(),
                    ),
                  ],
                ),
              );
            },
            itemCount: widget.item.answers.length,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: getColor().white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: getColor().f3eefcColor.withOpacity(0.3),
            spreadRadius: 6,
            blurRadius: 6,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
