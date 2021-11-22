import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class MyCollidable extends PositionComponent
    with HasGameRef<CircleCollision>, Hitbox, Collidable {
  MyCollidable(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(100),
          anchor: Anchor.center,
        ) {
    addHitbox(HitboxCircle());
  }

  late Vector2 velocity;
  static const _defaultColor = Colors.white;
  static const _collisionColor = Colors.red;
  bool _isCollision = false;
  bool _isWallHit = false;
  int xDirection = 1;
  int yDirection = 1;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(150);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isWallHit) {
      if (toRect().left <= 0 || toRect().right >= gameRef.size.x) {
        xDirection *= -1;
      }
      if (toRect().top <= 0 || toRect().bottom >= gameRef.size.y) {
        yDirection *= -1;
      }
      // removeFromParent();
      // return;
    }
    debugColor = _isCollision ? _collisionColor : _defaultColor;
    x += xDirection * velocity.x * dt;
    y += yDirection * velocity.y * dt;
    // position.add(velocity * dt);
    _isCollision = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is ScreenCollidable) {
      _isWallHit = true;
      return;
    }
    _isCollision = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderHitboxes(canvas);
  }
}

class CircleCollision extends FlameGame with HasCollidables, TapDetector {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenCollidable());
  }

  @override
  void onTapDown(TapDownInfo info) {
    add(MyCollidable(info.eventPosition.game));
  }
}
