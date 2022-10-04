import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        locator<PlatformChannel>()
            .openChatConversation(locator<UserModel>().user!);
      },
      child: SizedBox(
        height: 40,
        width: 40,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.asset(
              DImages.chatv2,
              width: 40,
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 5),
              child: ValueListenableProvider.value(
                value: locator<NotificationRepository>().badgeChatNotification,
                child: Consumer<int>(
                  builder: (context, numBadge, child) => numBadge > 0
                      ? Container(
                          height: 6,
                          width: 6,
                          margin: EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: getColor().colorRedE5597a),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
