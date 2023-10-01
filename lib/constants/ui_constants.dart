import 'package:bluebird/constants/assets_constants.dart';
import 'package:bluebird/views/explore/explore_view.dart';
import 'package:bluebird/views/notifications/notification_view.dart';
import 'package:bluebird/widgets/tweets/tweets_list.dart';
import 'package:bluebird/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: const ColorFilter.mode(Palette.blueColor, BlendMode.srcIn),
        height: 30,
      ),
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetsList(),
    ExploreView(),
    NotificationView(),
  ];
}
