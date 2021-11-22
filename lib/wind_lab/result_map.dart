import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_demo/wind_lab/button.dart';
import 'package:flame_demo/wind_lab/harbor.dart';
import 'package:flutter/cupertino.dart';

class ResultMap extends FlameGame with HasTappableComponents {
  final void Function()? onTapReturn;
  final void Function()? onPlayAgain;
  final void Function()? onShare;

  ResultMap({this.onTapReturn, this.onPlayAgain, this.onShare});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final windowSize = Vector2(
      MediaQueryData.fromWindow(window).size.width,
      MediaQueryData.fromWindow(window).size.height,
    );
    final mapBack = SpriteComponent(
      sprite: await loadSprite('wind_lab/result_map_back.png'),
      size: windowSize,
    );
    final mapFront = SpriteComponent(
      sprite: await loadSprite('wind_lab/result_map_front.png'),
      size: windowSize,
    );
    final scoreBox = ScoreBox(onPlayAgain: onPlayAgain, onShare: onShare)
      ..anchor = Anchor.center
      ..position = Vector2(windowSize.x * 0.8, windowSize.y * 0.4)
      ..size = Vector2(250, 284);

    final backButton = MyButton(
      path: 'wind_lab/back_button.png',
      onPressed: () => onTapReturn?.call(),
    )
      ..position = Vector2(
        32 + MediaQueryData.fromWindow(window).padding.left,
        32,
      )
      ..size = Vector2(48, 48);

    add(mapBack);
    add(mapFront);
    add(scoreBox);
    add(backButton);
  }
}

class ScoreBox extends PositionComponent with HasGameRef<ResultMap> {
  final VoidCallback? onPlayAgain;
  final VoidCallback? onShare;

  ScoreBox({this.onPlayAgain, this.onShare});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final scoreBox = await SciAnimation.load(
      frameCount: 16,
      pathPrefix: 'wind_lab/result_score/成绩页_000',
      stepTime: 0.1,
      loop: false,
    )
      ..size = size;

    // TextComponent()

    final playAgainButton = MyButton(
      path: 'wind_lab/play_again.png',
      onPressed: onPlayAgain,
    )
      ..size = Vector2(84, 49)
      ..anchor = Anchor.center
      ..position = Vector2(size.x * 0.32, size.y * 0.8);

    final shareButton = MyButton(
      path: 'wind_lab/share.png',
      onPressed: onShare,
    )
      ..size = Vector2(84, 49)
      ..anchor = Anchor.center
      ..position = Vector2(size.x * 0.68, size.y * 0.8);

    add(scoreBox);
    add(playAgainButton);
    add(shareButton);
  }
}
