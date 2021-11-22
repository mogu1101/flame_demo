import 'package:flame/components.dart';
import 'package:flame/input.dart';

enum ButtonState { unpressed, pressed }

class MyButton extends SpriteGroupComponent<ButtonState>
    with HasGameRef, Tappable {
  final String path;
  final void Function()? onPressed;

  MyButton({
    required this.path,
    required this.onPressed,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final unpressedSprite = await gameRef.loadSprite(path);
    final pressedSprite = await gameRef.loadSprite(path);
    sprites = {
      ButtonState.unpressed: unpressedSprite,
      ButtonState.pressed: pressedSprite,
    };
    current = ButtonState.unpressed;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.pressed;
    onPressed?.call();
    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = ButtonState.unpressed;
    return true;
  }

  @override
  bool onTapCancel() {
    current = ButtonState.unpressed;
    return true;
  }
}
