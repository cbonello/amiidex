import 'package:amiidex/providers/series_filter.dart';
import 'package:amiidex/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/UI/views/missing.dart';
import 'package:amiidex/UI/views/owned.dart';
import 'package:amiidex/UI/views/series.dart';
import 'package:amiidex/UI/views/statistics.dart';
import 'package:amiidex/UI/widgets/bottom_navbar.dart';
import 'package:amiidex/UI/widgets/drawer.dart';
import 'package:amiidex/UI/widgets/fab.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/providers/region_indicators.dart';
import 'package:amiidex/providers/selected_region.dart';
import 'package:amiidex/services/assets.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/preferred_language.dart';
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
        ChangeNotifierProvider<RegionIndicatorsProvider>(
          builder: (_) => RegionIndicatorsProvider(),
        ),
        ChangeNotifierProvider<SelectedRegionProvider>(
          builder: (_) => SelectedRegionProvider(),
        ),
        ChangeNotifierProvider<LockProvider>(
          builder: (_) => LockProvider(),
        ),
        ChangeNotifierProvider<OwnedProvider>(
          builder: (_) => OwnedProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.searches),
        ),
        ChangeNotifierProvider<SeriesFilterProvider>(
          builder: (_) => SeriesFilterProvider(),
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
          return GestureDetector(
            // See https://flutter360.dev/dismiss-keyboard-form-lose-focus/
            onTap: () {
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: MaterialApp(
              title: 'AmiiDex',
              // showSemanticsDebugger: true,
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
              onGenerateRoute: (RouteSettings settings) =>
                  Routes.getRoute(settings),
            ),
          );
        },
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key key, @required this.config}) : super(key: key);

  final ConfigModel config;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex;
  final List<Widget> _views = <Widget>[
    SeriesView(),
    OwnedView(),
    MissingView(),
    StatisticsView(),
  ];

  @override
  void initState() {
    final AssetsService assetsService = locator<AssetsService>();
    if (widget.config != null) {
      if (assetsService.isLineupLoaded == false) {
        assetsService.config = widget.config;
      }
    }
    currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          drawer: DrawerWidget(),
          body: IndexedStack(
            index: currentIndex,
            children: _views,
          ),
          bottomNavigationBar: BottomNavbar(
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                final FABVisibility fabVisibility =
                    Provider.of<FABVisibility>(context, listen: false);
                fabVisibility.visible = true;
                currentIndex = index;
              });
            },
          ),
          floatingActionButton: const FABWdiget(),
        ),
      ),
    );
  }
}
