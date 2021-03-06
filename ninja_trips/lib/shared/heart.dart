import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  Animation _curve;
  bool isFav = false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      //this will return value between 0 and 1 over the time interval
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);
    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_curve); //to show color transition we need color tween

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30, end: 50),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 50, end: 30),
        weight: 50,
      ),
    ]).animate(_curve);

    _controller.addListener(() {
      setState(() {});
    }); //evertime a new value is spitted we listen to that value and use it to animate things

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return IconButton(
          icon: Icon(
            Icons.favorite,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
          onPressed: () {
            if (isFav) {
              _controller.reverse();
            } else
              _controller.forward();
          },
        );
      },
    );
  }
}
