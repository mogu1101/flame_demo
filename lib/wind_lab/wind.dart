import 'package:flame/components.dart';
import 'package:flame_demo/wind_lab/harbor.dart';
import 'package:flutter/cupertino.dart';

class Wind extends SpriteAnimationComponent {
  Wind({this.onLoadComplete});

  final VoidCallback? onLoadComplete;
  late Component _wind1;
  late Component _wind2;
  late Component _wind3;
  Component? _current;
  var power = 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _wind1 = await SciAnimation.load(
      frameCount: 14,
      pathPrefix: 'wind_lab/wind_power1/合成 1_000',
      stepTime: 0.1,
    )
      ..size = size;
    addComponent(_wind1);

    _wind2 = await SciAnimation.load(
      frameCount: 13,
      pathPrefix: 'wind_lab/wind_power2/合成 1_000',
      stepTime: 0.1,
    )
      ..size = size;

    _wind3 = await SciAnimation.load(
      frameCount: 15,
      pathPrefix: 'wind_lab/wind_power3/合成 1_000',
      stepTime: 0.1,
    )
      ..size = size;

    onLoadComplete?.call();
  }

  void addComponent(Component component) {
    _current?.removeFromParent();
    add(component);
    _current = component;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (power == 1 && !_wind1.isMounted) {
      addComponent(_wind1);
    } else if (power == 2 && !_wind2.isMounted) {
      addComponent(_wind2);
    } else if (power == 3 && !_wind3.isMounted) {
      addComponent(_wind3);
    }
  }
}
