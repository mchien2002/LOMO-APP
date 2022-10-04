import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';

class SearchHashTagItem extends StatelessWidget {
  final HashTag hashTag;
  final Function? onPressed;

  const SearchHashTagItem({Key? key, required this.hashTag, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
        var title = "#" + "${hashTag.name}";
        var argument = TypeDiscoverAgrument(
            title, [FilterRequestItem(key: "hashtags", value: hashTag.name)]);
        Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
      },
      child: Container(
        height: Dimens.size56,
        child: Row(
          children: [
            SizedBox(
              width: Dimens.size16,
            ),
            Container(
                width: Dimens.size32,
                height: Dimens.size32,
                child: Image.asset(DImages.hashTag)),
            SizedBox(
              width: Dimens.size10,
            ),
            Expanded(
              child: Text(
                hashTag.name!,
                style: textTheme(context).text15.medium.colorDart,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "${hashTag.numberOfPost}" + " " + Strings.posts.localize(context),
              style: textTheme(context).text13.gray77,
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: Dimens.size16,
            ),
          ],
        ),
      ),
    );
  }
}
