
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/models/user.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:kcpm/providers/user_provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../models/notification_model.dart';
import '../models/recipe.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final String userOwner;
  final String userGuest;
  final String idRecipe;
  const NotificationItem(
      {super.key,
        required this.notification,
        required this.userOwner,
        required this.userGuest,
        required this.idRecipe});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {

  UserInformation? userInformationOwner;
  UserInformation? userInformationGuest;
  Recipe? recipe;

  @override
  Future<void> initState() async {
    super.initState();
    userInformationOwner = await UserProvider().getUserFuture(widget.userOwner);
    userInformationGuest = await UserProvider().getUserFuture(widget.userGuest);
    recipe = await RecipeProvider().getRecipe(widget.idRecipe);
  }

  @override
  Widget build(BuildContext context) {
    String? contextTitle;
    String? contextDescription;
    String? title;
    String iconData;




    iconData = 'assets/icon_svg/user-follow.svg';
    if (widget.notification.type == 'newFollower') {
      title = 'New Follower';
      contextTitle = 'Yeay you got new follower!';
      contextDescription = '${userInformationGuest!.name} has follow you';
      iconData = 'assets/icon_svg/user-follow.svg';
    }
    // if (notification.type == 'Bookmarked') {
    //   title = 'Bookmarked';
    //   iconData = 'assets/icon_svg/bookmark.svg';
    // }
    else if (widget.notification.type == 'liked') {
      title = 'Liked';
      contextTitle = '${userInformationGuest!.name} like your recipe';
      contextDescription = "";
      iconData = 'assets/icon_svg/heart.svg';
    } else if (widget.notification.type == 'newReview') {
      title = 'New Review';
      contextTitle = 'New review on ${recipe!.name} recipe';
      contextDescription =
      '${userInformationGuest!.name} write a review "${widget.notification.title}" to your recipe';
      iconData = 'assets/icon_svg/comment-square.svg';
    }
    // if (type == 'ReviewLiked') {
    //   title = 'Review Liked';
    //   iconData = 'assets/icon_svg/thumb-up.svg';
    // }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: widget.notification.read ? Colors.white12 : AppColors.oldLace,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          iconData,
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(
                              AppColors.orangeCrusta, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title!,
                            style: kLabelTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            contextTitle!,
                            style: kLabelTextStyleBigDark,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            contextDescription!,
                            style: kLabelTextStyleBig,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              calculateTimeAgo(widget.notification.time.toDate()),
              textAlign: TextAlign.end,
              style: kLabelTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

String calculateTimeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  return timeago.format(now.subtract(now.difference(dateTime)));
}
