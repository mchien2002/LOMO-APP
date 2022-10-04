import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import '../image_widget.dart';

class BubbleButtonWidget extends StatefulWidget {
  BubbleButtonWidget({
    Key? key,
    required this.imageUrl,
    required this.offset,
    required this.onTap,
    required this.onTapClose,
    required this.width,
  }) : super(key: key);
  Offset offset;
  final Function onTap;
  final double width;
  final Function onTapClose;
  final String imageUrl;

  @override
  _BubbleButtonWidgetState createState() => _BubbleButtonWidgetState();
}

class _BubbleButtonWidgetState extends State<BubbleButtonWidget> {
  late double height;

  @override
  void initState() {
    super.initState();
    height = widget.width + 15;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          Size size = MediaQuery.of(context).size;
          double moveX = 0;
          double moveY = 0;
          final double halfWidth = size.width / 2 - widget.width;
          if (widget.offset.dx + widget.width + details.delta.dx <
                  size.width - 20 &&
              widget.offset.dx + details.delta.dx > 20) {
            moveX = details.delta.dx;
          }
          if (widget.offset.dy + height + details.delta.dy < size.height - 20 &&
              widget.offset.dy + details.delta.dy > 20) {
            moveY = details.delta.dy;
          }

          setState(() {
            widget.offset += Offset(moveX, moveY);
          });
        },
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                widget.onTap();
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                margin: EdgeInsets.only(top: 13.0, right: 8.0),
                width: widget.width,
                height: height,
                child: RoundNetworkImage(
                  url: widget.imageUrl,
                  width: widget.width,
                  height: widget.width,
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  widget.onTapClose();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: getColor().colorPrimary,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // FloatingActionButton(
        //   onPressed: () {
        //     widget.onTap();
        //   },
        //   backgroundColor: Colors.red,
        //   child: Icon(Icons.add, color: Colors.white),
        // ),
      ),
    );
  }
}
