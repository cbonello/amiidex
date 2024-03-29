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
  final AssetsService assetsService = locator<AssetsService>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<PreferredLanguageProvider>(
          create: (_) => PreferredLanguageProvider(),
        ),
        ChangeNotifierProvider<RegionIndicatorsProvider>(
          create: (_) => RegionIndicatorsProvider(),
        ),
        ChangeNotifierProvider<SelectedRegionProvider>(
          create: (_) => SelectedRegionProvider(),
        ),
        ChangeNotifierProvider<LockProvider>(
          create: (_) => LockProvider(),
        ),
        ChangeNotifierProvider<OwnedProvider>(
          create: (_) => OwnedProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          create: (_) => ViewAsProvider(ItemsDisplayed.searches),
        ),
        ChangeNotifierProvider<SeriesFilterProvider>(
          create: (_) => SeriesFilterProvider(),
        ),
        ChangeNotifierProvider<FABVisibility>(
          create: (_) => FABVisibility(),
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
            onGenerateRoute: (RouteSettings settings) =>
                Routes.getRoute(settings),
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
      child: Scaffold(
        drawer: DrawerWidget(),
        // An IndexedStack allows us to keep the scroll positions when switching
        // from one stack item to the other.
        body: SafeArea(
          child: IndexedStack(
            index: currentIndex,
            children: _views,
          ),
        ),
        bottomNavigationBar: BottomNavbar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              final FABVisibility fabVisibility = Provider.of<FABVisibility>(
                context,
                listen: false,
              );
              fabVisibility.visible = true;
              currentIndex = index;
            });
          },
        ),
        floatingActionButton: const FABWdiget(),
      ),
    );
  }
}
