import 'dart:math';

import 'package:flame/input.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:forge2d/src/dynamics/body.dart';

class BlobSample extends Forge2DGame with TapDetector {
  BlobSample() : super(gravity: Vector2(0, -9.8));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final worldCenter = screenToWorld(size * camera.zoom / 2);
    final blobCenter = worldCenter + Vector2(0, 30);
    final blobRadius = Vector2.all(6);
    addAll(createBoundaries(this));
    add(Ground(worldCenter));
    final jointDef = ConstantVolumeJointDef()
      ..frequencyHz = 20
      ..dampingRatio = 1
      ..collideConnected = false;

    await Future.wait(List.generate(
      20,
      (i) => add(
        BlobPart(i, jointDef, blobRadius, blobCenter),
      ),
    ));
    world.createJoint(jointDef);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    add(FallingBox(info.eventPosition.game));
  }
}

List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft = Vector2.zero();
  final bottomRight = game.screenToWorld(game.camera.viewport.effectiveSize);
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(topLeft, topRight),
    Wall(topRight, bottomRight),
    Wall(bottomRight, bottomLeft),
    Wall(bottomLeft, topLeft),
  ];
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Ground extends BodyComponent {
  final Vector2 worldCenter;

  Ground(this.worldCenter);

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(20, 0.4);
    final bodyDef = BodyDef()..position.setFrom(worldCenter);
    final ground = world.createBody(bodyDef)..createFixtureFromShape(shape);

    shape.setAsBox(0.4, 20, Vector2(-10, 0), 0);
    ground.createFixtureFromShape(shape);
    shape.setAsBox(0.4, 20, Vector2(10, 0), 0);
    ground.createFixtureFromShape(shape);
    return ground;
  }
}

class BlobPart extends BodyComponent {
  final ConstantVolumeJointDef jointDef;
  final int bodyNumber;
  final Vector2 blobRadius;
  final Vector2 blobCenter;

  BlobPart(
    this.bodyNumber,
    this.jointDef,
    this.blobRadius,
    this.blobCenter,
  );

  @override
  Body createBody() {
    const nBodies = 20.0;
    const bodyRadius = 0.5;
    final angle = (bodyNumber / nBodies) * pi * 2;
    final x = blobCenter.x + blobRadius.x * sin(angle);
    final y = blobCenter.y + blobRadius.y * cos(angle);

    final bodyDef = BodyDef()
      ..fixedRotation = true
      ..position.setValues(x, y)
      ..type = BodyType.dynamic;
    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = bodyRadius;
    final fixtureDef = FixtureDef(shape)
      ..density = 1
      ..filter.groupIndex = -2;
    body.createFixture(fixtureDef);
    jointDef.addBody(body);
    return body;
  }
}

class FallingBox extends BodyComponent {
  final Vector2 position;

  FallingBox(this.position);

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;
    final shape = PolygonShape()..setAsBoxXY(2, 4);
    final body = world.createBody(bodyDef);
    body.createFixtureFromShape(shape, 1);
    return body;
  }
}
