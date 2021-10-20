import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'dart:math' as math;

void main() {
  const int numCards = 5;
  List<Card> getMockCards() {
    List<Card> cardDeck = [];
    for (int i = 0; i < numCards; ++i) {
      cardDeck.add(
        Card(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          child: const SizedBox(height: 300, width: 200)),
      );
    }
    return cardDeck;
  }

  final cardDeck = getMockCards();

  Future<void> _mountWidget(WidgetTester tester) async {
    SwipingCardDeck mockDeck = SwipingCardDeck(
      cardDeck: cardDeck,
      onDeckEmpty: () => debugPrint("Card deck empty"),
      onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
      onRightSwipe: (Card card) => debugPrint("Swiped right!"),
      cardWidth: 200,
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: mockDeck,),));
  }

  testWidgets("SwipingCardDeck widget is created", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
  });

  testWidgets("Only two cards are rendered", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsNWidgets(2));
  });

  testWidgets("swipeLeft removes top card and runs callback", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[1]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[0]);
    
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);

    SwipingCardDeck deck = tester.widget(deckFinder);
    expectLater(() => deck.swipeLeft(), prints("Swiped left!\n"));
    await tester.pumpAndSettle();
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[2]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[1]);
  });

  testWidgets("swipeRight removes top card and runs callback", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);
    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[1]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[0]);

    expectLater(() => deck.swipeRight(), prints("Swiped right!\n"));
    await tester.pumpAndSettle();
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[2]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[1]);
  });

  testWidgets("Callback function is ran when deck is empty", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);

    for (int i = 0; i < numCards - 1; ++i) {
      deck.swipeLeft();
      await tester.pumpAndSettle();
    }

    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);
    expect(tester.widget(cardFinder.first) as Card, cardDeck[numCards - 1]);

    expectLater(() => deck.swipeLeft(), prints("Swiped left!\nCard deck empty\n"));
    await tester.pumpAndSettle();

    expect(cardFinder, findsNothing);
  });
}
