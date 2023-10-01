import 'dart:io';

import 'package:bluebird/common/loading_page.dart';
import 'package:bluebird/common/rounded_small_button.dart';
import 'package:bluebird/constants/assets_constants.dart';
import 'package:bluebird/core/utils.dart';
import 'package:bluebird/controllers/auth_controller.dart';
import 'package:bluebird/controllers/tweets_controller.dart';
import 'package:bluebird/theme/palette.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetView());
  const CreateTweetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  void createTweet() {
    ref.read(tweetControllerProvider.notifier).createTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RoundedSmallButton(
              onTap: createTweet,
              label: 'Tweet',
              textColor: Palette.whiteColor,
            ),
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profilePic),
                            radius: 20,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: tweetTextController,
                              style: const TextStyle(fontSize: 22),
                              decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(
                                  color: Palette.greyColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                      if (images.isNotEmpty)
                        CarouselSlider(
                          items: images.map((file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.file(file),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 400,
                            enableInfiniteScroll: false,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Palette.greyColor,
              width: 0.1,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
