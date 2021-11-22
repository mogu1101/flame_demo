import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PlaneGame extends FlameGame {
  double tileSize = 0;

  PlaneGame(Size size) {
    onGameResize(Vector2(size.width, size.height));
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    tileSize = canvasSize.length / 9;
    super.onGameResize(canvasSize);
  }

  @override
  Color backgroundColor() => Colors.redAccent;
      // Color(0xffc3c8c9);
}