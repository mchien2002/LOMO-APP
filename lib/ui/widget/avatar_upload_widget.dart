import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/res/icons.dart';

class AvatarUpload extends StatefulWidget {
  final bool? isUpload;
  final String? avatar;

  AvatarUpload(this.avatar, {this.isUpload});

  _AvatarUpload createState() => _AvatarUpload();
}

class _AvatarUpload extends State<AvatarUpload> {
  late String _avatar;

  @override
  void initState() {
    super.initState();
    _avatar = widget.avatar ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            GestureDetector(
                onTap: null, //view image here
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_avatar),
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                )),
            if (widget.isUpload == true)
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  //view image here _viewImage([widget.avatar]),
                  child: SvgPicture.asset(
                    DIcons.account,
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
