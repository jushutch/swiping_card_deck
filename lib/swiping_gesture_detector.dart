import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

//ignore: must_be_immutable
class SwipingGestureDetector extends StatefulWidget {
  SwipingGestureDetector({
    Key? key,
    required this.cardDeck,
    required this.onLeftSwipe,
    required this.onRightSwipe,
    required this.onDeckEmpty,
    required this.swipeLeft,
    required this.swipeRight,
    required this.cardWidth,
    this.minimumVelocity = 1000,
    this.rotationFactor = .8 / 3.14,
    required this.swipeThreshold,
  }) : super(key: key);

  final List<Card> cardDeck;
  final Function(Card) onLeftSwipe, onRightSwipe;
  final Function(Size) swipeLeft, swipeRight;
  final Function() onDeckEmpty;
  final double minimumVelocity;
  final double rotationFactor;
  final double swipeThreshold;
  final double cardWidth;

  Alignment dragAlignment = Alignment.center;

  late final AnimationController swipeController;
  late Animation<Alignment> swipe;

  @override
  State<StatefulWidget> createState() => _SwipingGestureDetector();
}

class _SwipingGestureDetector extends State<SwipingGestureDetector>
    with TickerProviderStateMixin {
  bool animationActive = false;
  late final AnimationController springController;
  late Animation<Alignment> spring;

  @override
  void initState() {
    super.initState();
    springController = AnimationController(vsync: this);
    springController.addListener(() {
      setState(() {
        widget.dragAlignment = spring.value;
      });
    });

    widget.swipeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    widget.swipeController.addListener(() {
      setState(() {
        widget.dragAlignment = widget.swipe.value;
      });
    });
  }

  @override
  void dispose() {
    springController.dispose();
    widget.swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          widget.dragAlignment += Alignment(details.delta.dx, details.delta.dy);
        });
      },
      onPanStart: (DragStartDetails details) async {
        if (animationActive) {
          springController.stop();
        }
      },
      onPanEnd: (DragEndDetails details) async {
        double vx = details.velocity.pixelsPerSecond.dx;
        if (vx > widget.minimumVelocity ||
            widget.dragAlignment.x > widget.swipeThreshold) {
          await widget.swipeRight(MediaQuery.of(context).size);
        } else if (vx < -widget.minimumVelocity ||
            widget.dragAlignment.x < -widget.swipeThreshold) {
          await widget.swipeLeft(MediaQuery.of(context).size);
        } else {
          animateBackToDeck(details.velocity.pixelsPerSecond, screenSize);
        }
        setState(() {
          widget.dragAlignment = Alignment.center;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: topTwoCards(),
      ),
    );
  }

  List<Widget> topTwoCards() {
    if (widget.cardDeck.isEmpty) {
      return [
        const SizedBox(
          height: 0,
          width: 0,
        )
      ];
    }
    List<Widget> cardDeck = [];
    int deckLength = widget.cardDeck.length;
    for (int i = max(deckLength - 2, 0); i < deckLength; ++i) {
      cardDeck.add(widget.cardDeck[i]);
    }
    Widget topCard = cardDeck.last;
    cardDeck.removeLast();
    cardDeck.add(
      Align(
          alignment: Alignment(getCardXPosition(), 0),
          child: Transform.rotate(
            angle: getCardAngle(),
            child: topCard,
          )),
    );
    return cardDeck;
  }

  double getCardAngle() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return widget.rotationFactor * (widget.dragAlignment.x / screenWidth);
  }

  double getCardXPosition() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return widget.dragAlignment.x / ((screenWidth - widget.cardWidth) / 2);
  }

  void animateBackToDeck(Offset pixelsPerSecond, Size size) async {
    spring = springController.drive(
      AlignmentTween(
        begin: widget.dragAlignment,
        end: Alignment.center,
      ),
    );

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const springProps = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(springProps, 0, 1, -unitVelocity);
    animationActive = true;
    await springController.animateWith(simulation);
    animationActive = false;
  }
}
