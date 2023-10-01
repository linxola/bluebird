import 'package:bluebird/constants/assets_constants.dart';
import 'package:bluebird/core/enums/notification_type_enum.dart';
import 'package:bluebird/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:bluebird/models/notification_model.dart' as model;
import 'package:flutter_svg/svg.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Palette.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  colorFilter: const ColorFilter.mode(
                    Palette.redColor,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      colorFilter: const ColorFilter.mode(
                        Palette.whiteColor,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                    )
                  : notification.notificationType == NotificationType.reply
                      ? SvgPicture.asset(
                          AssetsConstants.commentIcon,
                          colorFilter: const ColorFilter.mode(
                            Palette.whiteColor,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        )
                      : null,
      title: Text(notification.text),
    );
  }
}
