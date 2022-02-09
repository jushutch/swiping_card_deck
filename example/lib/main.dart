import 'package:flutter/material.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'dart:math' as math;

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
        body: Center(
      child: ExamplePage(),
    )),
    title: 'SwipingCardDeck',
  ));
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SwipingCardDeck deck = SwipingCardDeck(
      cardDeck: getCardDeck(),
      onDeckEmpty: () => debugPrint("Card deck empty"),
      onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
      onRightSwipe: (Card card) => debugPrint("Swiped right!"),
      cardWidth: 200,
      swipeThreshold: MediaQuery.of(context).size.width / 3,
      minimumVelocity: 1000,
      rotationFactor: 0.8 / 3.14,
      swipeAnimationDuration: const Duration(milliseconds: 500),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        deck,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.clear),
              iconSize: 30,
              color: Colors.red,
              onPressed: deck.animationActive ? null : () => deck.swipeLeft(),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.check),
              iconSize: 30,
              color: Colors.green,
              onPressed: deck.animationActive ? null : () => deck.swipeRight(),
            ),
          ],
        ),
      ],
    );
  }

  List<Card> getCardDeck() {
    List<Card> cardDeck = [];
    for (int i = 0; i < 500; ++i) {
      cardDeck.add(
        Card(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            child: const SizedBox(height: 300, width: 200)),
      );
    }
    return cardDeck;
  }
}
