import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lomo/data/api/models/new_feed.dart';

import '../../../../../data/api/models/user.dart';

class MyTimeLineItemView extends StatefulWidget {
  const MyTimeLineItemView(
      {Key? key,
      required this.newFeed,
      this.user,
      this.onDeleteAction,
      this.onViewFavoriteAction,
      this.onBlockUser,
      required this.isWathching})
      : super(key: key);
  final NewFeed newFeed;
  final User? user;
  final Function()? onDeleteAction;
  final Function()? onViewFavoriteAction;
  final Function(User)? onBlockUser;
  final bool isWathching;
  @override
  State<MyTimeLineItemView> createState() => _MyTimeLineItemViewState();
}

class _MyTimeLineItemViewState extends State<MyTimeLineItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
