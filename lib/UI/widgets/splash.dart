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
    this.delegate,
  })  : assert(() {
          if (delegate?.animationMayRepeat == true &&
              delegate?.animationMustComplete == true) {
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
    with SingleTickerProviderStateMixin {
  bool isAnimationCompleted, isWorkerCompleted;
  T result;
  AnimationController controller;

  @override
  void initState() {
    isAnimationCompleted = isWorkerCompleted = false;

    if (widget.delegate == null) {
      // No animation.
      widget.backgroundWorker().then((dynamic v) {
        isWorkerCompleted = true;
        result = v;
        WidgetsBinding.instance.scheduleFrameCallback((_) async {
          await Navigator.pushReplacementNamed(
            context,
            widget.routeName,
            arguments: result,
          );
        });
        setState(() {});
      }).catchError((dynamic e) {
        throw FlutterError.fromParts(
          <DiagnosticsNode>[
            ErrorSummary(
              'An error occurred in the background worker function.',
            ),
            ErrorDescription(e.error),
          ],
        );
      });
    } else {
      widget.backgroundWorker().then((dynamic v) {
        isWorkerCompleted = true;
        result = v;
        if (isAnimationCompleted ||
            widget.delegate.animationMayRepeat == true ||
            widget.delegate.animationMustComplete == false) {
          WidgetsBinding.instance.scheduleFrameCallback((_) async {
            await Navigator.pushReplacementNamed(
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
            ErrorSummary(
              'An error occurred in the background worker function.',
            ),
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
                await Navigator.pushReplacementNamed(
                  context,
                  widget.routeName,
                  arguments: result,
                );
              });
            }
            isAnimationCompleted = true;
          }
        });
      if (widget.delegate.animationMayRepeat == true) {
        controller.repeat(period: widget.duration);
      } else {
        controller.forward();
      }
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
    if (widget.delegate == null) {
      return Container();
    }

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
