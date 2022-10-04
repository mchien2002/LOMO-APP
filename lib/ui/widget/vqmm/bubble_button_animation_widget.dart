import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:lomo/res/theme/theme_manager.dart';

import '../image_widget.dart';

class BubbleAnimationWidget extends StatefulWidget {
  final bool show;
  final Alignment initialAlignment;
  final Function onTap;
  final double width;
  final Function onTapClose;
  final String imageUrl;
  Offset offset;

  BubbleAnimationWidget({
    this.show = true,
    required this.offset,
    this.initialAlignment = Alignment.bottomRight,
    required this.imageUrl,
    required this.onTap,
    required this.onTapClose,
    required this.width,
  });

  @override
  BubbleAnimationWidgetState createState() => BubbleAnimationWidgetState();
}

class BubbleAnimationWidgetState extends State<BubbleAnimationWidget> with SingleTickerProviderStateMixin {
  late double height;
  late Animation<Alignment> animation;
  late AnimationController controller;
  Alignment dragBeginAlignment = Alignment.bottomRight;
  Alignment dragEndAlignment = Alignment.bottomRight;

  @override
  void initState() {
    height = widget.width + 15;
    dragBeginAlignment = widget.initialAlignment;
    dragEndAlignment = widget.initialAlignment;

    super.initState();
    controller = AnimationController(vsync: this);

    controller.addListener(() {
      setState(() {
        dragBeginAlignment = animation.value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void runAnimation(Offset pixelsPerSecond, Size size) {
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    animation = controller.drive(
      AlignmentTween(
        begin: dragBeginAlignment,
        end: dragEndAlignment,
      ),
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    controller.animateWith(simulation);
  }

  void onPanUpdate(DragUpdateDetails details) {
    print("delta.dy: ${details.delta.dy} - ${dragBeginAlignment.y}");
    final size = MediaQuery.of(context).size;
    var dragDy = dragBeginAlignment.y;
    if (dragDy > 1)
      dragDy = 1;
    else if (dragDy < -1) dragDy = -1;

    setState(() {
      if (details.localPosition.dx > (size.width / 2)) {
        dragEndAlignment = Alignment(
          1,
          (dragDy + details.delta.dy / (size.height / 2)),
        );
        dragBeginAlignment += Alignment(
          (details.delta.dx / (size.width / 2)),
          details.delta.dy / (size.height / 2),
        );
      } else {
        dragEndAlignment = Alignment(
          -1,
          (dragDy + details.delta.dy / (size.height / 2)),
        );
        dragBeginAlignment += Alignment((details.delta.dx / (size.width / 2)), (details.delta.dy / (size.height / 2)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        controller.stop();
      },
      onPanUpdate: (details) {
        onPanUpdate(details);
      },
      onPanEnd: (details) {
        runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
          alignment: dragBeginAlignment,
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: (() {
                if (widget.show) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
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
                  );
                } else {
                  return SizedBox();
                }
              }()))),
    );
  }
}
