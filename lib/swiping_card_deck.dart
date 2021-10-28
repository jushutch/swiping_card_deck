/// The swiping_card_deck library contains the [SwipingCardDeck] widget
/// which allows a user to swipe through a deck of [Card] widgets.
library swiping_card_deck;

import 'package:flutter/material.dart';
import './src/swiping_gesture_detector.dart';

/// A deck of [Card] widgets that can be swiped to the left or right
/// using a gesture or a button.
//ignore: must_be_immutable
class SwipingCardDeck extends StatelessWidget {
  SwipingCardDeck({
    Key? key,
    required this.cardDeck,
    required this.onLeftSwipe,
    required this.onRightSwipe,
    required this.onDeckEmpty,
    required this.cardWidth,
    this.minimumVelocity = 1000,
    this.rotationFactor = .8 / 3.14,
    this.swipeThreshold,
  }) : super(key: key) {
    cardDeck = cardDeck.reversed.toList();
  }

  /// The list of [Card] widgets to be swiped.
  List<Card> cardDeck;

  /// Callback function ran when a [Card] is swiped left.
  final Function(Card) onLeftSwipe;

  /// Callback function ran when a [Card] is swiped right.
  final Function(Card) onRightSwipe;

  /// Callback function when the last [Card] in the [cardDeck] is swiped.
  final Function() onDeckEmpty;

  /// The minimum horizontal velocity required to trigger a swipe.
  final double minimumVelocity;

  /// The amount each [Card] rotates as it is swiped.
  final double rotationFactor;

  /// The width of all [Card] widgets in the [cardDeck].
  final double cardWidth;

  /// The distance in pixels that a [Card] must be dragged before it is swiped.
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

  /// Swipe the top [Card] to the left.
  ///
  /// If there is no animation already in progress, trigger the animation
  /// to swipe the top [Card] to the left, call the function [onLeftSwipe],
  /// and remove the [Card] from the deck. If the deck is empty, call the
  /// function [onDeckEmpty].
  Future<void> swipeLeft() async {
    if (animationActive || cardDeck.isEmpty) return;
    await _swipeCard(left, screenSize);
    onLeftSwipe(cardDeck.last);
    cardDeck.removeLast();
    if (cardDeck.isEmpty) onDeckEmpty();
  }

  /// Swipe the top [Card] to the right.
  ///
  /// If there is no animation already in progress, trigger the animation
  /// to swipe the top [Card] to the right, call the function [onRightSwipe],
  /// and remove the [Card] from the deck. If the deck is empty, call the
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
