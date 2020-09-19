import 'package:amiidex/main.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key key, this.config}) : super(key: key);

  final ConfigModel config;

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  final List<String> _assets = <String>[
    'assets/images/onboarding/whats_new.png',
    'assets/images/onboarding/series_filter.png',
    'assets/images/onboarding/lock.png',
    'assets/images/onboarding/long_press.png',
    'assets/images/onboarding/double_tap.png',
    'assets/images/onboarding/swipe.png',
    'assets/images/onboarding/barcode_scan.png',
  ];

  final List<String> _titles = <String>[
    'onboarding-whats-new-title',
    'onboarding-series-filter-title',
    'onboarding-lock-title',
    'onboarding-long-press-title',
    'onboarding-double-tap-title',
    'onboarding-swipe-title',
    'onboarding-barcode-scan-title',
  ];

  final List<String> _descriptions = <String>[
    'onboarding-whats-new',
    'onboarding-series-filter',
    'onboarding-lock',
    'onboarding-long-press',
    'onboarding-double-tap',
    'onboarding-swipe',
    'onboarding-barcode-scan',
  ];

  Future<void> _onSkipEnd(BuildContext context) async {
    final LocalStorageService storageService = locator<LocalStorageService>();
    await storageService.setDisplayOnboarding(false);
    await Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: widget.config,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        onDone: () async => _onSkipEnd(context),
        onSkip: () => _onSkipEnd(context),
        onChange: (int pageIndex) => setState(() => _currentPage = pageIndex),
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text(I18n.of(context).text('onboarding-skip')),
        next: _currentPage == 0
            ? Text(I18n.of(context).text('onboarding-tutorial'))
            : const Icon(Icons.arrow_forward),
        done: Text(
          I18n.of(context).text('onboarding-done'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        pages: <PageViewModel>[
          for (int index = 0; index < _assets.length; index++)
            PageViewModel(
              title: I18n.of(context).text(_titles[index]),
              body: I18n.of(context).text(_descriptions[index]),
              image: Image.asset(
                _assets[index],
                fit: BoxFit.fill,
              ),
            ),
        ],
      ),
    );
  }
}
