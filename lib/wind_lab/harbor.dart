import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/layers.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flame_demo/wind_lab/button.dart';
import 'package:flutter/cupertino.dart';

enum ShipType { first, second, third }

class SciAnimation {
  static Future<SpriteAnimationComponent> load({
    required int frameCount,
    required String pathPrefix,
    String extension = 'png',
    required double stepTime,
    Vector2? position,
    Vector2? size,
    bool loop = true,
  }) async {
    final sprites = await Future.wait(List.generate(
      frameCount,
      (index) =>
          Sprite.load('$pathPrefix${index < 10 ? '0' : ''}$index.$extension'),
    ));

    return SpriteAnimationComponent(
      position: position,
      size: size,
      animation: SpriteAnimation.spriteList(
        sprites,
        stepTime: stepTime,
        loop: loop,
      ),
    );
  }
}

class WindLabGame extends FlameGame with HasTappableComponents {
  final void Function()? onTapReturn;
  final void Function(ShipType)? onConfirm;

  WindLabGame({
    this.onTapReturn,
    this.onConfirm,
  });

  ShipType? _chosenShipType;
  late Component _confirmButton;

  // @override
  // Vector2 get size {
  //   final size = super.size;
  //   final aspectRatio = 812 / 375;
  //   debugPrint('WindGame super size: --------------- $size');
  //   if (size.x / size.y > aspectRatio) {
  //     debugPrint('WindGame size: --------------- ${Vector2(size.y * aspectRatio, size.y)}');
  //     return Vector2(size.y * aspectRatio, size.y);
  //   } else {
  //     debugPrint('WindGame size: --------------- ${Vector2(size.x, size.x / aspectRatio)}');
  //     return Vector2(size.x, size.x / aspectRatio);
  //   }
  // }

  @override
  void onGameResize(Vector2 canvasSize) {
    debugPrint('onGameResize: ----------- $canvasSize');
    super.onGameResize(canvasSize);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final windowSize = Size(size.x, size.y);



    final background = (await SciAnimation.load(
      frameCount: 51,
      pathPrefix: 'wind_lab/harbor_bg1/始发站场景_000',
      extension: 'webp',
      stepTime: 0.1,
      size: Vector2(windowSize.width, windowSize.height),
    ));

    final shipSize = Vector2(220, 220);
    final shipPosition = Vector2(
      (windowSize.width - shipSize.x) / 2,
      (windowSize.height - shipSize.y) / 4,
    );
    final ship1 = await SciAnimation.load(
      frameCount: 76,
      pathPrefix: 'wind_lab/ship1/1号船_000',
      stepTime: 0.1,
      size: shipSize,
      position: shipPosition,
    );
    final ship2 = await SciAnimation.load(
      frameCount: 76,
      pathPrefix: 'wind_lab/ship2/2号船_000',
      stepTime: 0.1,
      size: shipSize,
      position: shipPosition,
    );
    final ship3 = await SciAnimation.load(
      frameCount: 76,
      pathPrefix: 'wind_lab/ship3/3号船_000',
      stepTime: 0.1,
      size: shipSize,
      position: shipPosition,
    );

    Component? chosenShip(ShipType? type) {
      if (type == null) return null;
      switch (type) {
        case ShipType.first:
          return ship1;
        case ShipType.second:
          return ship2;
        case ShipType.third:
          return ship3;
      }
    }

    final choiceContainerSize = Vector2(394, 146);
    final choiceContainer = ShipsScroll(
      onFirstChosen: () {
        chosenShip(_chosenShipType)?.removeFromParent();
        _chosenShipType = ShipType.first;
        add(ship1);
      },
      onSecondChosen: () {
        chosenShip(_chosenShipType)?.removeFromParent();
        _chosenShipType = ShipType.second;
        add(ship2);
      },
      onThirdChosen: () {
        chosenShip(_chosenShipType)?.removeFromParent();
        _chosenShipType = ShipType.third;
        add(ship3);
      },
    )
      ..position = Vector2(
        (windowSize.width - choiceContainerSize.x) / 2,
        windowSize.height - choiceContainerSize.y - 10,
      )
      ..size = choiceContainerSize;

    final backButton = MyButton(
      path: 'wind_lab/back_button.png',
      onPressed: () => onTapReturn?.call(),
    )
      ..position = Vector2(
        32 + MediaQueryData.fromWindow(window).padding.left,
        32,
      )
      ..size = Vector2(48, 48);

    _confirmButton = MyButton(
      path: 'wind_lab/confirm_button.png',
      onPressed: () => onConfirm?.call(_chosenShipType!),
    )
      ..position = Vector2(windowSize.width * 0.88, windowSize.height * 0.5)
      ..size = Vector2(71, 71)
      ..anchor = Anchor.center;

    // final bb = Image.asset('wind_lab/1234.webp');
    // flame.Image img = await Flame.images.load('wind_lab/1234.webp');
    // final a = SpriteComponent(
    //     sprite: Sprite(img),
    //     position: Vector2(100, 100),
    //     size: Vector2(900, 200));

    add(background);
    add(choiceContainer);
    add(backButton);
    // add(a);
  }

  @override
  void render(Canvas canvas) {
    if (_chosenShipType != null && !_confirmButton.isMounted) {
      debugPrint('confirmbutton add');
      add(_confirmButton);
    }
    super.render(canvas);
  }
}

class BackgroundLayer extends PreRenderedLayer {
  final Sprite sprite;
  final Vector2 position;
  final Vector2 size;

  BackgroundLayer(
    this.sprite, {
    required this.position,
    required this.size,
  });

  @override
  void drawLayer() {
    sprite.render(
      canvas,
      position: position,
      size: size,
    );
  }
}

enum ShipsScrollState { open, inChoice, close }

class ShipsScroll extends SpriteAnimationComponent
    with HasGameRef<WindLabGame> {
  final void Function()? onFirstChosen;
  final void Function()? onSecondChosen;
  final void Function()? onThirdChosen;

  ShipsScroll({
    this.onFirstChosen,
    this.onSecondChosen,
    this.onThirdChosen,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final container = await SciAnimation.load(
      frameCount: 16,
      pathPrefix: 'wind_lab/scroll_open/卷轴打开_000',
      stepTime: 0.1,
      size: size,
      loop: false,
    );
    final ship1Size = Vector2(68, 86);
    final ship1 = MyButton(
      path: 'wind_lab/ship1_icon.png',
      onPressed: onFirstChosen,
    )
      ..position = Vector2(size.x * 0.285, size.y * 0.47)
      ..anchor = Anchor.center
      ..size = ship1Size;

    final ship2Size = Vector2(79, 78);
    final ship2 = MyButton(
      path: 'wind_lab/ship2_icon.png',
      onPressed: onSecondChosen,
    )
      ..position = Vector2(size.x * 0.51, size.y * 0.44)
      ..anchor = Anchor.center
      ..size = ship2Size;

    final ship3Size = Vector2(74, 79);
    final ship3 = MyButton(
      path: 'wind_lab/ship3_icon.png',
      onPressed: onThirdChosen,
    )
      ..position = Vector2(size.x * 0.722, size.y * 0.43)
      ..anchor = Anchor.center
      ..size = ship3Size;

    add(container);
    Future.delayed(Duration(seconds: 1), () {
      add(ship1);
      add(ship2);
      add(ship3);
    });
  }
}
