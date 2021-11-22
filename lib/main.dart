import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flame_demo/animations/basic.dart';
import 'package:flame_demo/component/collision.dart';
import 'package:flame_demo/component/logo.dart';
import 'package:flame_demo/forge2d/blob_sample.dart';
import 'package:flame_demo/pause_menu.dart';
import 'package:flame_demo/plane_game.dart';
import 'package:flame_demo/test_game.dart';
import 'package:flame_demo/wind_lab/harbor.dart';
import 'package:flame_demo/wind_lab/result_map.dart';
import 'package:flame_demo/wind_lab/river.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flame Demo'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => listItems(context)[index],
        separatorBuilder: (context, index) => Divider(
          indent: 16,
          color: Colors.red,
        ),
        itemCount: listItems(context).length,
      ),
    );
  }

  List<Widget> listItems(BuildContext context) {
    Widget tile(String title) {
      return Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(16),
        child: Text(title),
      );
    }

    return [
      Center(
        child: Container(
          width: 100,
          height: 100,
          child: SpriteAnimationWidget.asset(
            path: 'bomb_ptero.png',
            data: SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.2,
              textureSize: Vector2(48, 32),
            ),
            anchor: Anchor.center,
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('test'),
                ),
                body: GameWidget(game: MyGame()),
              ),
            ),
          );
        },
        child: tile('test'),
      ),
      GestureDetector(
        onTap: () async {
          // await Flame.device.fullScreen();
          // await Flame.device.setPortraitDownOnly();
          // Flame.device
          // Size size = await Flame.util.initialDimensions();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OverlayExampleWidget(),
            ),
          );
        },
        child: tile('Pause Menu'),
      ),
      GestureDetector(
        onTap: () async {
          // await Flame.device.fullScreen();
          // await Flame.device.setPortraitDownOnly();
          // Flame.device
          // Size size = await Flame.util.initialDimensions();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlanePage(),
            ),
          );
        },
        child: tile('飞机大战'),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameWidget(
                game: BasicAnimations(),
              ),
            ),
          );
        },
        child: tile('Basic Animation'),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameWidget(
                game: DebugGame(),
              ),
            ),
          );
        },
        child: tile('Logo Moving'),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameWidget(
                game: CircleCollision(),
              ),
            ),
          );
        },
        child: tile('Collision'),
      ),
      GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameWidget(
                game: BlobSample(),
              ),
            ),
          );
        },
        child: tile('Blob'),
      ),
      // GestureDetector(
      //   onTap: () async {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => GameWidget(
      //           game: SailGame(),
      //         ),
      //       ),
      //     );
      //   },
      //   child: tile('Parallax'),
      // ),
      GestureDetector(
        onTap: () async {
          await Flame.device.setLandscape();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AspectRatio(
                  aspectRatio: 812 / 375,
                  child: GameWidget(
                    loadingBuilder: (_) => Center(child: CircularProgressIndicator()),
                    game: WindLabGame(
                      onTapReturn: Navigator.of(context).pop,
                      onConfirm: (type) => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GameWidget(
                            game: SailGame(
                              shipType: type,
                              onTapReturn: Navigator.of(context).pop,
                              onComplete: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => GameWidget(
                                    game: ResultMap(
                                        onTapReturn: Navigator.of(context).pop,
                                        onPlayAgain: () => Navigator.of(context)
                                            .popUntil((route) =>
                                                route.settings.name == '123')),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: tile('Wind Lab'),
      ),
    ];
  }
}

class PlanePage extends StatelessWidget {
  const PlanePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('飞机大战')),
      body: LayoutBuilder(builder: (context, constraints) {
        debugPrint('constraints: $constraints');
        return GameWidget(
          game: PlaneGame(
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
        );
      }),
    );
  }
}
