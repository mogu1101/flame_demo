import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class OverlayExampleWidget extends StatefulWidget {
  const OverlayExampleWidget({Key? key}) : super(key: key);

  @override
  _OverlayExampleWidgetState createState() => _OverlayExampleWidgetState();
}

class _OverlayExampleWidgetState extends State<OverlayExampleWidget> {
  ExampleGame? _myGame;

  Widget pauseMenuBuilder(BuildContext context, ExampleGame game) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        color: const Color(0xFFFF0000),
        child: const Center(
          child: Text('Paused'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myGame = _myGame;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing addingOverlay'),
      ),
      body: myGame == null
          ? const Text('Wait')
          : GameWidget(
              game: myGame,
              overlayBuilderMap: {'PauseMenu': pauseMenuBuilder},
              initialActiveOverlays: const ['PauseMenu'],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _myGame = ExampleGame()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExampleGame extends FlameGame with TapDetector {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      const Offset(200, 200),
      100,
      Paint()..color = BasicPalette.white.color,
    );
  }

  @override
  void onTap() {
    if (overlays.isActive('PauseMenu')) {
      overlays.remove('PauseMenu');
    } else {
      overlays.add('PauseMenu');
    }
  }
}
