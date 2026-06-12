// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateY }

class CustomFadeAnimationComponent extends StatelessWidget {
  final double delay;
  final Widget child;
  late dynamic tween;

  CustomFadeAnimationComponent(this.delay, this.child, {super.key}) {
/*  tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0),
        Duration(milliseconds: 500),)
      ..add(
        AniProps.translateY,
        Tween(begin: 30.0, end: 1.0),
        Duration(milliseconds: 500),
      );*/

    tween = MovieTween()
      ..scene(begin: Duration.zero, end: const Duration(milliseconds: 500))
          .tween(AniProps.opacity, Tween(begin: 0.0, end: 1.0))
      ..scene(begin: Duration.zero, end: const Duration(milliseconds: 500))
          .tween(AniProps.translateY, Tween(begin: 30.0, end: 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<Movie>(
      tween: tween,
      duration: Duration(milliseconds: (500 * delay).round()),
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.translateY) - 1),
            child: child),
      ),
    );
    /*  return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.translateY)-1), child: child),
      ),
    );*/
  }
}
