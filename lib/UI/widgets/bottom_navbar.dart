import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key key,
    @required this.currentIndex,
    @required this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final Function onTap;

  // See https://medium.com/@uxmovement/solid-vs-outline-icons-which-are-faster-to-recognize-9bb0fc24821f
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final BottomNavBarThemeData navBarData =
        BottomNavBarThemeData(data: themeData);

    return BottomNavigationBar(
      selectedItemColor: navBarData.selectedItemColor,
      unselectedItemColor: navBarData.unselectedItemColor,
      currentIndex: currentIndex,
      showUnselectedLabels: true,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          title: Text(I18n.of(context).text('bottom-navbar-collection')),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.thumb_up),
          title: Text(I18n.of(context).text('bottom-navbar-owned')),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.thumb_down),
          title: Text(I18n.of(context).text('bottom-navbar-missing')),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.insert_chart),
          title: Text(I18n.of(context).text('bottom-navbar-statistics')),
        ),
      ],
      onTap: onTap,
    );
  }
}
