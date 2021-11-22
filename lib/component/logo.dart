import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LogoComponent extends SpriteComponent with HasGameRef<DebugGame> {
  static const int speed = 150;

  int xDirection = 1;
  int yDirection = 1;

  LogoComponent(Sprite sprite) : super(sprite: sprite, size: sprite.srcSize);

  @override
  void update(double dt) {
    super.update(dt);

    x += xDirection * speed * dt;

    final rect = toRect();

    if ((x <= 0 && xDirection == -1) ||
        rect.right > gameRef.size.x && xDirection == 1) {
      xDirection *= -1;
    }

    y += yDirection * speed * dt;

    if ((y <= 0 && yDirection == -1) ||
        (rect.bottom > gameRef.size.y && yDirection == 1)) {
      yDirection *= -1;
    }
  }
}

class DebugGame extends FlameGame with FPSCounter {
  static final fpsTextPaint = TextPaint(
    config: const TextPaintConfig(color: Colors.white),
  );

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final flameLogo = await loadSprite('flame.png');

    final flame1 = LogoComponent(flameLogo)
      ..x = 100
      ..y = 400;

    final flame2 = LogoComponent(flameLogo)
      ..x = 100
      ..y = 400
      ..xDirection = -1;

    final flame3 = LogoComponent(flameLogo)
      ..x = 100
      ..y = 400
      ..yDirection = -1;

    add(flame1);
    add(flame2);
    add(flame3);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (debugMode) {
      fpsTextPaint.render(canvas, fps(120).toString(), Vector2(20, 80));
    }
  }
}
