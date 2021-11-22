import 'package:flame/components.dart';
import 'package:flame_demo/wind_lab/harbor.dart';
import 'package:flutter/cupertino.dart';

class SailingShip extends SpriteAnimationComponent {
  SailingShip(this.type, {this.onLoadComplete});

  final ShipType type;
  final VoidCallback? onLoadComplete;
  late Component _shipInWind1;
  late Component _shipInWind2;
  late Component _shipInWind3;
  Component? _current;
  var windPower = 1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final shipNum = type.index + 1;
    _shipInWind1 = await SciAnimation.load(
      frameCount: 76,
      pathPrefix: 'wind_lab/sailing_ship${shipNum}_wind1/1级风-$shipNum号船_000',
      stepTime: 0.1,
    )
      ..size = size;
    addShip(_shipInWind1);

    _shipInWind2 = await SciAnimation.load(
      frameCount: 51,
      pathPrefix: 'wind_lab/sailing_ship${shipNum}_wind2/2级风-$shipNum号船_000',
      stepTime: 0.1,
    )
      ..size = size;

    _shipInWind3 = await SciAnimation.load(
      frameCount: 51,
      pathPrefix: 'wind_lab/sailing_ship${shipNum}_wind3/3级风-$shipNum号船_000',
      stepTime: 0.1,
    )
      ..size = size;

    onLoadComplete?.call();
  }

  void addShip(Component ship) {
    _current?.removeFromParent();
    add(ship);
    _current = ship;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (windPower == 1 && !_shipInWind1.isMounted) {
      addShip(_shipInWind1);
    } else if (windPower == 2 && !_shipInWind2.isMounted) {
      addShip(_shipInWind2);
    } else if (windPower == 3 && !_shipInWind3.isMounted) {
      addShip(_shipInWind3);
    }
  }
}
