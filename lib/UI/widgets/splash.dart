import 'dart:async';

import 'package:flutter/material.dart';

abstract class AnimationDelegate {
  void constraints(
    final Orientation orientation,
    final Size parentSize,
  );

  Widget build(BuildContext context, Animation<double> controller);

  void dispose() {}

  bool get animationMayRepeat;
  bool get animationMustComplete;
}

typedef SplashBackgroundWorker<T> = Future<T> Function();

class SplashWidget<T> extends StatefulWidget {
  SplashWidget({
    Key key,
    @required this.duration,
    this.debugLabel,
    this.animationBehavior = AnimationBehavior.normal,
    this.backgroundWorker,
    @required this.routeName,
    @required this.delegate,
  })  : assert(() {
          if (delegate.animationMayRepeat && delegate.animationMustComplete) {
            throw FlutterError.fromParts(
              <DiagnosticsNode>[
                ErrorSummary('Incompatible animation options in delegate.'),
                ErrorDescription(
                    'animationMayRepeat and animationMustComplete both return true. However, '
                    'if an animation is in repeat mode it will never complete.'),
                ErrorHint(
                    'animationMayRepeat and animationMustComplete cannot both return true.')
              ],
            );
          }
          return true;
        }()),
        super(key: key);

  final Duration duration;
  final String debugLabel, routeName;
  final AnimationBehavior animationBehavior;
  final SplashBackgroundWorker<T> backgroundWorker;
  final AnimationDelegate delegate;

  @override
  _SplashWidgetState<T> createState() => _SplashWidgetState<T>();
}

class _SplashWidgetState<T> extends State<SplashWidget<T>>
    with TickerProviderStateMixin {
  bool isAnimationCompleted, isWorkerCompleted;
  T result;
  AnimationController controller;

  @override
  void initState() {
    isAnimationCompleted = isWorkerCompleted = false;
    widget.backgroundWorker().then((dynamic v) {
      isWorkerCompleted = true;
      result = v;
      if (isAnimationCompleted ||
          widget.delegate.animationMayRepeat ||
          widget.delegate.animationMustComplete == false) {
        WidgetsBinding.instance.scheduleFrameCallback((_) async {
          Navigator.pushNamed(
            context,
            widget.routeName,
            arguments: result,
          );
        });
        setState(() {});
      }
    }).catchError((dynamic e) {
      throw FlutterError.fromParts(
        <DiagnosticsNode>[
          ErrorSummary('An error occurred in the background worker function.'),
          ErrorDescription(e.error),
        ],
      );
    });
    controller = AnimationController(
      duration: widget.duration,
      debugLabel: widget.debugLabel,
      animationBehavior: widget.animationBehavior,
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (isWorkerCompleted && isAnimationCompleted == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              Navigator.pushNamed(
                context,
                widget.routeName,
                arguments: result,
              );
            });
          }
          isAnimationCompleted = true;
        }
      });
    if (widget.delegate.animationMayRepeat) {
      controller.repeat(period: widget.duration);
    } else {
      controller.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    widget.delegate?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Size parentSize =
                Size(constraints.maxWidth, constraints.maxHeight);

            widget.delegate?.constraints(orientation, parentSize);

            return widget.delegate.build(context, controller.view);
          },
        );
      },
    );
  }
}
