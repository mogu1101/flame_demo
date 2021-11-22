import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_demo/wind_lab/button.dart';
import 'package:flame_demo/wind_lab/harbor.dart';
import 'package:flame_demo/wind_lab/sailing_ship.dart';
import 'package:flame_demo/wind_lab/wind.dart';
import 'package:flutter/cupertino.dart';

class SailGame extends FlameGame
    with HasGameRef, TapDetector, VerticalDragDetector {
  final ShipType shipType;
  final VoidCallback? onTapReturn;
  final VoidCallback? onComplete;

  SpriteAnimationComponent? _background;
  late Progress _progress;

  // late SpriteComponent _backButton;
  late SailingShip _ship;
  late Wind _wind;
  final windowSize = MediaQueryData.fromWindow(window).size;
  double _velocityX = 1.6;
  double _velocityY = 0;
  double _currentX = 0;
  double _currentY = 0;
  bool _shipLoadCompleted = false;
  bool _isCompleted = false;

  SailGame({required this.shipType, this.onTapReturn, this.onComplete});

  double get mapHeight => windowSize.height * 2;

  double get mapWidth => mapHeight * 5.8;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _currentX = 0;
    _currentY = -mapHeight / 2;

    _background = await SciAnimation.load(
      frameCount: 1,
      pathPrefix: 'wind_lab/river_back_1/pic000',
      extension: 'webp',
      stepTime: 0.1,
    )
      ..size = Vector2(mapWidth, mapHeight)
      ..position = Vector2(_currentX, _currentY);

    _progress = Progress()
      ..size = Vector2(windowSize.width * 0.7, 30)
      ..position = Vector2(windowSize.width / 2, 50)
      ..anchor = Anchor.center;

    final backButton = MyButton(
      path: 'wind_lab/back_button.png',
      onPressed: () => onTapReturn?.call(),
    )
      ..position = Vector2(
        32 + MediaQueryData.fromWindow(window).padding.left,
        32,
      )
      ..size = Vector2(48, 48);

    _ship = SailingShip(
      shipType,
      onLoadComplete: () => _shipLoadCompleted = true,
    )
      ..size = Vector2(408, 282)
      ..position = Vector2(
        windowSize.width / 2,
        windowSize.height / 2,
      )
      ..anchor = Anchor.center;
    // _ship = await SciAnimation.load(
    //   frameCount: 38,
    //   pathPrefix: 'wind_lab/sailing_ship1_wind1/pic_',
    //   extension: 'webp',
    //   stepTime: 0.2,
    // )..size = Vector2(408, 282)
    //   ..position = Vector2(
    //     windowSize.width / 2,
    //     windowSize.height / 2,
    //   )
    //   ..anchor = Anchor.center;

    _wind = Wind()
      ..size = Vector2(161, 74)
      ..position = Vector2(windowSize.width * 0.3, windowSize.height / 2)
      ..anchor = Anchor.center;

    add(_background!);
    add(backButton);
    add(_ship);
    add(_wind);
    add(_progress);
  }

  double get upperBoundary {
    final width = mapWidth - windowSize.width;
    final height = mapHeight - windowSize.height;
    return 0.22 * height * sin(3 * pi / width * (_currentX - width / 12)) -
        height * 0.72;
  }

  double get lowerBoundary => upperBoundary - 50;

  double speed(double actuallySpeed, double dt) {
    return (mapWidth - windowSize.width) * actuallySpeed * dt / 200;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_shipLoadCompleted ||
        _background == null ||
        _currentX >= mapWidth - windowSize.width - 30) {
      _ship.windPower = 1;
      _wind.power = 1;
      if (_currentX >= mapWidth - windowSize.width - 30) {
        if (!_isCompleted) {
          _isCompleted = true;
          Future.delayed(Duration(seconds: 1), onComplete);
        }
      }
      return;
    }
    _currentX += speed(_velocityX, dt);
    _currentY -= _velocityY;
    debugPrint('_currentX = $_currentX, currentY = $_currentY');
    if (_currentY > 0) {
      _currentY = 0;
    }
    if (_currentY < windowSize.height - mapHeight) {
      _currentY = windowSize.height - mapHeight;
    }
    if (_currentY > upperBoundary) {
      _currentY = upperBoundary;
    }
    if (_currentY < lowerBoundary) {
      _currentY = lowerBoundary;
    }
    _progress.progress = _currentX / (mapWidth - windowSize.width);
    _background?.position = Vector2(-_currentX, _currentY);
    debugPrint('Speed: ----------------- $_velocityX');
    if (_velocityX < 3.4) {
      _ship.windPower = 1;
      _wind.power = 1;
    } else if (_velocityX < 5.5) {
      _ship.windPower = 2;
      _wind.power = 2;
    } else {
      _ship.windPower = 3;
      _wind.power = 3;
    }
    _velocityX = (_velocityX - 0.01).clamp(1.6, 7.9);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // if (_backButton.containsPoint(info.eventPosition.game)) {
    //   onTapReturn?.call();
    // } else {
    _velocityX = (_velocityX + 0.2).clamp(1.6, 7.9);
    // }
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    _velocityY += info.delta.game.y * 0.02;
  }

  @override
  void onVerticalDragEnd(DragEndInfo info) {
    _velocityY = 0;
  }
}

class Progress extends SpriteComponent with HasGameRef<SailGame> {
  SpriteComponent? _indicator;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final progress = SpriteComponent(
      sprite: await gameRef.loadSprite('wind_lab/progress.png'),
    )..size = size;
    _indicator = SpriteComponent(
      sprite: await gameRef.loadSprite('wind_lab/progress_indicator.png'),
    )
      ..size = Vector2(30, 40)
      ..position = Vector2(0, -10);
    add(progress);
    add(_indicator!);
  }

  set progress(double p) {
    if (p > 1) return;
    _indicator?.position = Vector2(
      p * 0.95 * size.x,
      -20 - 5 * sin(3.1 * pi * (p - 1.72 * pi)),
    );
  }
}
