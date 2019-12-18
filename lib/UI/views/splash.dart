import 'package:amiidex/UI/widgets/splash.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final LocalStorageService storageService = locator<LocalStorageService>();
    final bool onboarding = storageService.getDisplayOnboarding();

    return SafeArea(
      child: Scaffold(
        backgroundColor: brightness == Brightness.light ? Colors.white : Colors.black,
        body: SplashWidget<ConfigModel>(
          duration: const Duration(seconds: 8),
          backgroundWorker: loadConfig,
          routeName: onboarding ? '/onboarding' : '/home',
          delegate:
              storageService.getDisplaySplashScreen() ? MyAnimationDelegate() : null,
        ),
      ),
    );
  }
}

const double MARIO_TRANSLATE_START = 0.0;
const double MARIO_TRANSLATE_END = 0.2;
const double MARIO_SCALE_OUT_START = MARIO_TRANSLATE_END;
const double MARIO_SCALE_OUT_END = MARIO_SCALE_OUT_START + 0.1;
const double MARIO_SCALE_VALUE = 0.05;
const double MARIO_SCALE_IN_START = MARIO_SCALE_OUT_END;
const double MARIO_SCALE_IN_END = MARIO_SCALE_IN_START + 0.1;
const double LOOT_BOX_TRANSLATE_START = MARIO_SCALE_OUT_START + 0.2;
const double LOOT_BOX_TRANSLATE_END = LOOT_BOX_TRANSLATE_START + 0.35;
const double LOOT_BOX_VISIBILITY_START = LOOT_BOX_TRANSLATE_START;
const double LOOT_BOX_VISIBILITY_END = LOOT_BOX_TRANSLATE_END - 0.3;
const double LOOT_BOX_TRANSPARENCY_START = LOOT_BOX_TRANSLATE_END + 0.1;
const double LOOT_BOX_TRANSPARENCY_END = LOOT_BOX_TRANSPARENCY_START + 0.15;
const double LOADING_OPACITY_START = LOOT_BOX_VISIBILITY_START;
const double LOADING_WIDTH_START = LOOT_BOX_TRANSPARENCY_START;
const double LOADING_WIDTH_END = 1.0;

class MyAnimationDelegate implements AnimationDelegate {
  Size _parentSize;
  String asset;

  @override
  void constraints(
    Orientation orientation,
    Size parentSize,
  ) {
    _parentSize = parentSize;
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context, Animation<double> controller) {
    final Brightness brightness = Theme.of(context).brightness;
    asset = (brightness == Brightness.light)
        ? 'assets/images/splash/controller_light.png'
        : 'assets/images/splash/controller_dark.png';

    return SingleChildScrollView(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: _parentSize.height * 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Image.asset(
                  asset,
                  semanticLabel: I18n.of(context).text('sm-splash-controller'),
                  fit: BoxFit.cover,
                ))
              ],
            ),
          ),
          Mario(
            parentSize: _parentSize,
            controller: controller,
          ),
          LootBox(
            parentSize: _parentSize,
            controller: controller,
          ),
        ],
      ),
    );
  }

  @override
  bool get animationMayRepeat => false;

  @override
  bool get animationMustComplete => true;
}

class Mario extends StatefulWidget {
  const Mario({
    Key key,
    @required this.parentSize,
    @required this.controller,
  }) : super(key: key);

  final Size parentSize;
  final AnimationController controller;

  @override
  _MarioState createState() => _MarioState();
}

class _MarioState extends State<Mario> with SingleTickerProviderStateMixin {
  Animation<double> _translation, _scaleOut, _scaleIn;

  @override
  void initState() {
    _translation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          MARIO_TRANSLATE_START,
          MARIO_TRANSLATE_END,
          curve: Curves.easeIn,
        ),
      ),
    );
    _scaleOut = Tween<double>(
      begin: 1.0,
      end: 1.0 + MARIO_SCALE_VALUE,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          MARIO_SCALE_OUT_START,
          MARIO_SCALE_OUT_END,
          curve: Curves.linear,
        ),
      ),
    );
    _scaleIn = Tween<double>(
      begin: 1.0 + MARIO_SCALE_VALUE,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          MARIO_SCALE_IN_START,
          MARIO_SCALE_IN_END,
          curve: Curves.linear,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size of Switch-controller image in assets is 590x400.
    final double controllerHeight = 400.0 * widget.parentSize.width / 590.0;
    // Location of NFC reader is about 87 pixels from top of image.
    final double nfcOffsetFromTop = controllerHeight * 87.0 / 400.0;

    // Size of Amiibo image in assets is 199x123.
    final double marioWidth = widget.parentSize.width / 2.5;
    final double marioHeight = marioWidth * 123.0 / 199.0;

    final double marioX = (widget.parentSize.width / 2.0) - (marioWidth / 2.0);
    final double marioY = _translation.value *
        ((widget.parentSize.height * 0.3) - marioHeight + nfcOffsetFromTop);

    return Transform.translate(
      offset: Offset(marioX, marioY),
      child: ScaleTransition(
        scale: _scaleOut,
        alignment: Alignment.bottomCenter,
        child: ScaleTransition(
          scale: _scaleIn,
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/images/splash/mario.png',
            semanticLabel: I18n.of(context).text('ssb_mario'),
            width: marioWidth,
            height: marioHeight,
          ),
        ),
      ),
    );
  }
}

class LootBox extends StatefulWidget {
  const LootBox({
    Key key,
    @required this.parentSize,
    @required this.controller,
  }) : super(key: key);

  final Size parentSize;
  final AnimationController controller;

  @override
  _LootBoxState createState() => _LootBoxState();
}

class _LootBoxState extends State<LootBox> {
  Animation<double> _translation, _visibility, _transparency, _textWidth;

  @override
  void initState() {
    _translation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          LOOT_BOX_TRANSLATE_START,
          LOOT_BOX_TRANSLATE_END,
          curve: Curves.bounceOut,
        ),
      ),
    );
    _visibility = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          LOOT_BOX_VISIBILITY_START,
          LOOT_BOX_VISIBILITY_END,
          curve: Curves.easeInCirc,
        ),
      ),
    );
    _transparency = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          LOOT_BOX_TRANSPARENCY_START,
          LOOT_BOX_TRANSPARENCY_END,
          curve: Curves.easeOut,
        ),
      ),
    );
    _textWidth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          LOADING_WIDTH_START,
          LOADING_WIDTH_END,
          curve: Curves.linear,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size of Amiibo image in assets is 232x168.
    final double boxWidth = (widget.parentSize.width / 3) * 0.8;
    final double boxHeight = boxWidth * 168.0 / 232.0;

    final double boxX = (2.7) * (widget.parentSize.width / 3) - (boxWidth / 2.0);
    final double boxY =
        _translation.value * ((widget.parentSize.height * 0.6) - boxHeight / 2.0);

    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(boxX, boxY),
          child: Opacity(
            opacity: _visibility.value,
            child: Opacity(
              opacity: _transparency.value,
              child: Image.asset(
                'assets/images/ssb/box_mario.png',
                semanticLabel: I18n.of(context).text('sm-splash-loot-box'),
                width: boxWidth,
                height: boxHeight,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.parentSize.height * 0.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: boxWidth * 0.3),
                child: Opacity(
                  opacity: widget.controller.value >= LOADING_OPACITY_START ? 1.0 : 0.0,
                  child: Container(
                    width: _textWidth.value * 200,
                    child: Text(
                      I18n.of(context).text('splash_loading'),
                      style: TextStyle(
                        color: const Color(0xFF4E7CD2),
                        backgroundColor: Colors.transparent,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      semanticsLabel: I18n.of(context).text(
                        'sm-splash-loading',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
