import 'package:flutter/material.dart';
import 'package:amiidex/util/theme.dart';

class ActionBarBottomSheetItem extends StatelessWidget {
  const ActionBarBottomSheetItem({
    Key key,
    @required this.displayIcon,
    @required this.leading,
    @required this.title,
    @required this.selected,
    @required this.onTap,
  }) : super(key: key);

  final bool displayIcon;
  final IconData leading;
  final String title;
  final bool selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ActionBarThemeData actionBarData =
        ActionBarThemeData(data: themeData);

    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
      child: Container(
        margin: const EdgeInsets.only(
          left: 10.0,
        ),
        decoration: selected
            ? BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100.0),
                  bottomLeft: Radius.circular(100.0),
                ),
                color: actionBarData.selectedItemBackgroundColor,
              )
            : null,
        child: ListTile(
          enabled: true,
          leading: leading != null
              ? Icon(
                  leading,
                  color: displayIcon
                      ? selected
                          ? actionBarData.selectedItemColor
                          : actionBarData.color
                      : Colors.transparent,
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              color: selected
                  ? actionBarData.selectedItemColor
                  : actionBarData.color,
            ),
          ),
          selected: selected,
          onTap: onTap,
        ),
      ),
    );
  }
}
