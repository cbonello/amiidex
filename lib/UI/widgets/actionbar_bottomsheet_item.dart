import 'package:flutter/material.dart';
import 'package:amiidex/util/theme.dart';

class ActionBarBottomSheetItem extends StatelessWidget {
  const ActionBarBottomSheetItem({
    Key key,
    @required this.displayIcon,
    this.leading,
    @required this.title,
    this.titleIcon,
    this.semanticLabel,
    @required this.selected,
    @required this.onTap,
  }) : super(key: key);

  final bool displayIcon;
  final IconData leading;
  final Widget titleIcon;
  final String title, semanticLabel;
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
          left: 20.0,
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
          title: Row(
            children: <Widget>[
              titleIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: titleIcon,
                    )
                  : Container(),
              // To prevent text overflow and allow wrapping.
              Expanded(
                child: Text(
                  title,
                  semanticsLabel: semanticLabel,
                  style: TextStyle(
                    color: selected
                        ? actionBarData.selectedItemColor
                        : actionBarData.color,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          selected: selected,
          onTap: onTap,
        ),
      ),
    );
  }
}
