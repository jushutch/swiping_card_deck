/// The swiping_card_deck library contains the [SwipingCardDeck] widget
/// which allows a user to swipe through a deck of [Card] widgets. To
/// swipe through any [Widget], use the generic [SwipingDeck] class.
library swiping_card_deck;

import 'package:flutter/material.dart';
import './src/swiping_gesture_detector.dart';

/// A [SwipingDeck] of [Card] widgets
typedef SwipingCardDeck = SwipingDeck<Card>;

/// A deck of [Widget] objects that can be swiped to the left or right
/// using a gesture or a button.
// ignore: must_be_immutable
class SwipingDeck<T extends Widget> extends StatelessWidget {
  SwipingDeck(
      {Key? key,
      required this.cardDeck,
      required this.onLeftSwipe,
      required this.onRightSwipe,
      required this.onDeckEmpty,
      required this.cardWidth,
      this.minimumVelocity = 1000,
      this.rotationFactor = .8 / 3.14,
      this.swipeThreshold,
      this.swipeAnimationDuration = const Duration(milliseconds: 500)})
      : super(key: key) {
    cardDeck = cardDeck.reversed.toList();
  }

  /// The list of [Widget] objects to be swiped.
  List<T> cardDeck;

  /// Callback function ran when a [Widget] is swiped left.
  final Function(T) onLeftSwipe;

  /// Callback function ran when a [Widget] is swiped right.
  final Function(T) onRightSwipe;

  /// Callback function when the last [Widget] in the [cardDeck] is swiped.
  final Function() onDeckEmpty;

  /// The minimum horizontal velocity required to trigger a swipe.
  final double minimumVelocity;

  /// The amount each [Widget] rotates as it is swiped.
  final double rotationFactor;

  /// The width of all [Widget] objects in the [cardDeck].
  final double cardWidth;

  /// The [Duration] of the swiping [AnimationController]
  final Duration swipeAnimationDuration;

  /// The distance in pixels that a [Widget] must be dragged before it is swiped.
  late final double? swipeThreshold;

  /// The [SwipingGestureDetector] used to control swipe animations.
  late final SwipingGestureDetector swipeDetector;

  /// The [Size] of the screen.
  late final Size screenSize;

  bool animationActive = false;
  static const String left = "left";
  static const String right = "right";

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    swipeDetector = SwipingGestureDetector(
      cardDeck: cardDeck,
      swipeLeft: swipeLeft,
      swipeRight: swipeRight,
      swipeThreshold: swipeThreshold ?? screenSize.width / 4,
      cardWidth: cardWidth,
      rotationFactor: rotationFactor,
      minimumVelocity: minimumVelocity,
      swipeAnimationDuration: swipeAnimationDuration,
    );
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: swipeDetector,
          ),
        ],
      ),
    );
  }

  /// Swipe the top [Widget] to the left.
  ///
  /// If there is no animation already in progress, trigger the animation
  /// to swipe the top [Widget] to the left, call the function [onLeftSwipe],
  /// and remove the [Widget] from the deck. If the deck is empty, call the
  /// function [onDeckEmpty].
  Future<void> swipeLeft() async {
    if (animationActive || cardDeck.isEmpty) return;
    await _swipeCard(left, screenSize);
    onLeftSwipe(cardDeck.last);
    cardDeck.removeLast();
    if (cardDeck.isEmpty) onDeckEmpty();
  }

  /// Swipe the top [Widget] to the right.
  ///
  /// If there is no animation already in progress, trigger the animation
  /// to swipe the top [Widget] to the right, call the function [onRightSwipe],
  /// and remove the [Widget] from the deck. If the deck is empty, call the
  /// function [onDeckEmpty].
  Future<void> swipeRight() async {
    if (animationActive || cardDeck.isEmpty) return;
    await _swipeCard(right, screenSize);
    onRightSwipe(cardDeck.last);
    cardDeck.removeLast();
    if (cardDeck.isEmpty) onDeckEmpty();
  }

  Future<void> _swipeCard(String direction, Size screenSize) async {
    double swipeEnd = screenSize.width / 2 + cardWidth;
    swipeDetector.swipe = AlignmentTween(
      begin: swipeDetector.dragAlignment,
      end: Alignment(direction == left ? -swipeEnd : swipeEnd,
          swipeDetector.dragAlignment.x),
    ).animate(
      CurvedAnimation(
        parent: swipeDetector.swipeController,
        curve: Curves.ease,
      ),
    );
    animationActive = true;
    await swipeDetector.swipeController.forward();
    swipeDetector.swipeController.reset();
    animationActive = false;
  }
}
