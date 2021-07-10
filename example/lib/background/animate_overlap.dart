import 'package:flutter/cupertino.dart';

typedef PositionedBuilder = Widget Function(
    BuildContext context, Animation<double>? value);

///Using for children in stack update behavior by parent animation
class AnimateOverlay extends StatefulWidget {
  const AnimateOverlay(
      {Key? key,
      required this.overlapController,
      this.duration = const Duration(milliseconds: 1000),
      required this.children})
      : super(key: key);

  @override
  _AnimateOverlayState createState() => _AnimateOverlayState();
  final OverlapController overlapController;
  final Duration duration;
  final List<Widget> children;
}

class _AnimateOverlayState extends State<AnimateOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;
  late VoidCallback _listener;
  late VoidCallback _animationListener;

  @override
  void initState() {
    _listener = () {
      if (widget.overlapController.play) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    };
    _animationListener = () {
      _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
      _animation = Tween(begin: 0.0, end: 1.0).animate(_animation);
      widget.overlapController.update(_animation);
    };
    widget.overlapController.addListener(_listener);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(_animationListener);

    super.initState();
  }

  @override
  void dispose() {
    widget.overlapController.removeListener(_listener);
    _controller.removeListener(_animationListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.children,
    );
  }
}

class AnimateOverlayListener extends StatefulWidget {
  const AnimateOverlayListener(
      {Key? key, required this.overlapController, required this.builder})
      : super(key: key);

  @override
  _AnimateOverlayListenerState createState() => _AnimateOverlayListenerState();
  final OverlapController overlapController;
  final PositionedBuilder builder;
}

class _AnimateOverlayListenerState extends State<AnimateOverlayListener> {
  Animation<double>? _animation;
  late VoidCallback _listener;

  @override
  void initState() {
    _listener = () {
      setState(() {
        _animation = widget.overlapController.value;
      });
    };
    widget.overlapController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.overlapController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animation);
  }
}

class OverlapController extends ChangeNotifier {
  bool play = false;
  Animation<double>? value;

  void open() {
    if (!play) {
      play = true;
      notifyListeners();
    }
  }

  void close() {
    if (play) {
      play = false;
      notifyListeners();
    }
  }

  void update(Animation<double> value) {
    this.value = value;
    notifyListeners();
  }
}
