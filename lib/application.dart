import 'package:amiidex/UI/views/collection.dart';
import 'package:amiidex/UI/views/missing.dart';
import 'package:amiidex/UI/views/owned.dart';
import 'package:amiidex/UI/views/privacy.dart';
import 'package:amiidex/UI/views/settings.dart';
import 'package:amiidex/UI/views/statistics.dart';
import 'package:amiidex/UI/widgets/bottom_navbar.dart';
import 'package:amiidex/UI/widgets/drawer.dart';
import 'package:amiidex/UI/widgets/fab.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/preferred_language.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/theme.dart';
import 'package:provider/provider.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<PreferredLanguageProvider>(
          builder: (_) => PreferredLanguageProvider(),
        ),
        ChangeNotifierProvider<RegionProvider>(
          builder: (_) => RegionProvider(),
        ),
        ChangeNotifierProvider<LockProvider>(
          builder: (_) => LockProvider(),
        ),
        ChangeNotifierProvider<OwnedProvider>(
          builder: (_) => OwnedProvider(),
        ),
        ChangeNotifierProvider<AmiiboSortProvider>(
          builder: (_) => AmiiboSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.searches),
        ),
        ChangeNotifierProvider<FABVisibility>(
          builder: (_) => FABVisibility(),
        ),
      ],
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (Brightness brightness) => buildTheme(brightness),
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          final PreferredLanguageProvider languageProvider =
              Provider.of<PreferredLanguageProvider>(context);
          return MaterialApp(
            title: 'AmiiDex',
            locale: languageProvider.locale,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              languageProvider.i18n,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: languageProvider.i18n.supportedLocales,
            localeResolutionCallback: languageProvider.i18n
                .resolution(fallback: languageProvider.locale),
            theme: theme,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/':
                  return _buildRoute(settings, HomePage());
                case '/settings':
                  return _buildRoute(settings, const SettingsView());
                case '/privacy':
                  return _buildRoute(settings, PrivacyView());
                default:
                  assert(false);
                  return null;
              }
            },
          );
        },
      ),
    );
  }

  MaterialPageRoute<void> _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFAB = true;
  int _currentIndex = 0;
  final List<Widget> _views = <Widget>[
    CollectionView(),
    OwnedView(),
    MissingView(),
    StatisticsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerWidget(),
        body: IndexedStack(
          index: _currentIndex,
          children: _views,
        ),
        bottomNavigationBar: BottomNavbar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              final FABVisibility fabVisibility =
                  Provider.of<FABVisibility>(context);
              fabVisibility.visible = true;
              _currentIndex = index;
            });
          },
        ),
        floatingActionButton: const FABScan(),
      ),
    );
  }
}
