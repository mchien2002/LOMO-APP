import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/handle_link_util.dart';

abstract class SeoIntentLinkWidget extends StatefulWidget {
  SeoIntentLinkWidget(
    this.url, {
    this.margin,
    this.padding,
  });
  final String url;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  State<StatefulWidget> createState() => _SeoIntentLinkWidgetState();

  Widget buildContent(
      BuildContext context, String? image, String? title, String? description);
}

class _SeoIntentLinkWidgetState extends State<SeoIntentLinkWidget> {
  String? image;
  String? title;
  String? description;
  @override
  void initState() {
    super.initState();
    getSeoDataFromLink(widget.url);
  }

  getSeoDataFromLink(String link) async {
    try {
      final response = await get(Uri.parse(link));
      final document = parse(response.body);
      final metas = document.getElementsByTagName("meta");
      metas.forEach((element) {
        if (element.attributes["property"] == "og:title")
          title = element.attributes["content"];
        if (element.attributes["property"] == "og:description")
          description = element.attributes["content"];
        if (element.attributes["property"] == "og:image")
          image = element.attributes["content"];
      });
    } catch (e) {}
    if ((image != null || title != null) && mounted) setState(() {});
  }

  @override
  didUpdateWidget(SeoIntentLinkWidget oldWidget) {
    if (oldWidget.url != widget.url) {
      getSeoDataFromLink(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return image != null
        ? InkWell(
            onTap: () {
              locator<HandleLinkUtil>().openLink(widget.url);
            },
            child: Container(
                margin: widget.margin ?? const EdgeInsets.only(top: 0),
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: getColor().white,
                    border: Border.all(width: 1, color: getColor().colorDivider)
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: getColor().colorDivider,
                    //     offset: Offset(2, 2),
                    //     blurRadius: 2,
                    //     spreadRadius: 0,
                    //   ),
                    //   BoxShadow(
                    //     color: getColor().colorDivider,
                    //     offset: Offset(-2, -2),
                    //     blurRadius: 2,
                    //     spreadRadius: 0,
                    //   ),
                    // ],
                    ),
                child: widget.buildContent(context, image, title, description)),
          )
        : Container();
  }
}

class HorizontalSeoIntentLinkWidget extends SeoIntentLinkWidget {
  final double? imageSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String url;
  HorizontalSeoIntentLinkWidget(this.url,
      {this.imageSize, this.margin, this.padding})
      : super(url, margin: margin, padding: padding);

  Widget buildContent(
      BuildContext context, String? image, String? title, String? description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(7)),
          child: RoundNetworkImage(
            width: imageSize ?? 70,
            height: imageSize ?? 70,
            radius: 0,
            url: image,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                title ?? "",
                style: textTheme(context).text13.bold.colorDart,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                Uri.parse(url).host,
                style: textTheme(context).text12.colorGray,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}

class VerticalSeoIntentLinkWidget extends SeoIntentLinkWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String url;

  VerticalSeoIntentLinkWidget(this.url, {this.margin, this.padding})
      : super(url, margin: margin, padding: padding);

  @override
  Widget buildContent(
      BuildContext context, String? image, String? title, String? description) {
    final height = MediaQuery.of(context).size.height * 200.0 / 812.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
          child: RoundNetworkImage(
            width: double.infinity,
            height: height,
            radius: 0,
            url: image,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: textTheme(context).text13.bold.colorDart,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                Uri.parse(url).host,
                style: textTheme(context).text12.colorGray,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
