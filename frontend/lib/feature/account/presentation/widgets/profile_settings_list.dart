import 'package:flutter/material.dart';
import 'package:me_and_flora/core/theme/strings.dart';

import '../../../../core/presentation/widgets/notifications/app_notification.dart';
import '../../../../core/theme/theme.dart';

class ProfileSettingsList extends StatelessWidget {
  final String title;
  final List<String> elementList;
  final List<String> notificationTitles;
  final List<String> notificationTexts;

  const ProfileSettingsList({
    super.key,
    required this.title,
    required this.elementList,
    required this.notificationTitles,
    required this.notificationTexts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                elementList[i],
                style: Theme.of(context).textTheme.labelSmall,
              ),
              trailing: IconButton(
                onPressed: () async {
                  await _showNotification(
                      context, notificationTitles[i], notificationTexts[i]);
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: colors.lightGray,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            thickness: 1,
            color: colors.gray,
          ),
          itemCount: elementList.length,
        )
      ],
    );
  }

  Future<bool?> _showNotification(context, String title, String text) async =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AppNotification(title: title, text: text);
        },
      );
}
