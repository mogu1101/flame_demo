import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class ParallaxGame extends FlameGame with TapDetector, VerticalDragDetector {
  late Parallax _parallax;
  double _velocityX = 20;
  double _velocityY = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final bgLayer = await loadParallaxLayer(
      ParallaxImageData('parallax/bg.png'),
      repeat: ImageRepeat.repeat,
    );
    final mountainLayer = await loadParallaxLayer(
      ParallaxImageData('parallax/mountain-far.png'),
      velocityMultiplier: Vector2(1.8, 0),
    );
    final airplaneLayer = await loadParallaxLayer(
      ParallaxAnimationData(
        'parallax/airplane.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.2,
          textureSize: Vector2(320, 160),
        ),
      ),
      repeat: ImageRepeat.noRepeat,
      velocityMultiplier: Vector2.zero(),
      fill: LayerFill.none,
      alignment: Alignment.center,
    );
    _parallax = Parallax(
      [
        bgLayer,
        // mountainLayer,
        airplaneLayer,
      ],
      baseVelocity: Vector2(_velocityX, _velocityY),
    );
    add(ParallaxComponent.fromParallax(_parallax));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _velocityX = (_velocityX - 0.5).clamp(100, 600);
    _parallax.baseVelocity = Vector2(_velocityX, _velocityY);
  }

  @override
  void onTapDown(TapDownInfo info) {
    _velocityX = (_velocityX + 20).clamp(100, 600);
    print('onTapDown ------- ${_velocityX}');
    _parallax.baseVelocity = Vector2(_velocityX, _velocityY);
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    print('onVerticalDragUpdate --------- ${info.delta.game}, ${info.eventPosition.game}');
    _velocityY = (_velocityY + info.delta.game.y);
    _parallax.baseVelocity = Vector2(_velocityX, _velocityY);
  }

  @override
  void onVerticalDragEnd(DragEndInfo info) {
    _velocityY = 0;
    _parallax.baseVelocity = Vector2(_velocityX, _velocityY);
  }
}
