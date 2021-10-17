import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'dart:math' as math;

void main() {
  List<Card> getMockCards() {
    List<Card> cardDeck = [];
    for (int i = 0; i < 5; ++i) {
      cardDeck.add(
        Card(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          child: const SizedBox(height: 300, width: 200)),
      );
    }
    return cardDeck;
  }

  final SwipingCardDeck mockDeck = SwipingCardDeck(
    cardDeck: getMockCards(),
    onDeckEmpty: () => debugPrint("Card deck empty"),
    onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
    onRightSwipe: (Card card) => debugPrint("Swiped right!"),
    cardWidth: 200,
  );

  testWidgets("SwipingCardDeck widget is created", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: mockDeck,),));
    Finder deckFinder = find.byWidget(mockDeck);
    expect(deckFinder, findsOneWidget);
  });
}