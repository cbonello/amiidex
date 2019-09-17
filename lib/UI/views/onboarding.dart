import 'package:amiidex/main.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({Key key, this.config}) : super(key: key);

  final ConfigModel config;

  final List<String> _assets = <String>[
    'assets/images/onboarding/series_filter.png',
    'assets/images/onboarding/lock.png',
    'assets/images/onboarding/long_press.png',
    'assets/images/onboarding/double_tap.png',
  ];

  final List<String> _titles = <String>[
    'onboarding-series-filter-title',
    'onboarding-lock-title',
    'onboarding-long-press-title',
    'onboarding-double-tap-title',
  ];

  final List<String> _descriptions = <String>[
    'onboarding-series-filter',
    'onboarding-lock',
    'onboarding-long-press',
    'onboarding-double-tap',
  ];

  Future<void> _onSkipEnd(BuildContext context) async {
    final LocalStorageService storageService = locator<LocalStorageService>();
    await storageService.setDisplayOnboarding(false);
    await Navigator.pushReplacementNamed(context, '/home', arguments: config);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        onDone: () async => _onSkipEnd(context),
        onSkip: () => _onSkipEnd(context),
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
