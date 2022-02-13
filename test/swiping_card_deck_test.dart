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
      onLeftSwipe: (Card card, List<Card> cardDeck, int cardsSwiped) {
        debugPrint("Swiped left!");
        debugPrint(cardsSwiped.toString());
      },
      onRightSwipe: (Card card, List<Card> cardDeck, int cardsSwiped) {
        debugPrint("Swiped right!");
        debugPrint(cardsSwiped.toString());
      },
      cardWidth: 200,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: mockDeck,
      ),
    ));
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

  testWidgets("swipeLeft removes top card and runs callback",
      (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[1]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[0]);

    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);

    SwipingCardDeck deck = tester.widget(deckFinder);
    expectLater(() => deck.swipeLeft(), prints("Swiped left!\n1\n"));
    await tester.pumpAndSettle();
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[2]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[1]);
  });

  testWidgets("swipeRight removes top card and runs callback",
      (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);
    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[1]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[0]);

    expectLater(() => deck.swipeRight(), prints("Swiped right!\n1\n"));
    await tester.pumpAndSettle();
    expect(cardFinder, findsNWidgets(2));
    expect(tester.widget(cardFinder.first) as Card, cardDeck[2]);
    expect(tester.widget(cardFinder.last) as Card, cardDeck[1]);
  });

  testWidgets("Callback function is ran when deck is empty",
      (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);

    for (int i = 0; i < numCards - 1; ++i) {
      expectLater(() => deck.swipeLeft(), prints("Swiped left!\n${i + 1}\n"));
      await tester.pumpAndSettle();
    }

    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);
    expect(tester.widget(cardFinder.first) as Card, cardDeck[numCards - 1]);

    expectLater(() => deck.swipeLeft(),
        prints("Swiped left!\n$numCards\nCard deck empty\n"));
    await tester.pumpAndSettle();

    expect(cardFinder, findsNothing);
  });

  testWidgets("CardsSwiped is incremented correctly",
      (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);

    for (int i = 0; i < numCards - 1; ++i) {
      expectLater(() => deck.swipeLeft(), prints("Swiped left!\n${i + 1}\n"));
      await tester.pumpAndSettle();
    }

    Finder cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);
    expect(tester.widget(cardFinder.first) as Card, cardDeck[numCards - 1]);
  });

  testWidgets("CardDeck can be modified with both swipe callbacks",
      (WidgetTester tester) async {
    // Add a card to the beginning of a deck
    void addCard(List<Card> deck) {
      deck.insert(
        0,
        const Card(
            color: Colors.black, child: SizedBox(height: 300, width: 200)),
      );
    }

    // SwipingCardDeck with swipe callbacks that modify the cardDeck
    SwipingCardDeck mockDeck = SwipingCardDeck(
      cardDeck: const [
        Card(color: Colors.black, child: SizedBox(height: 300, width: 200))
      ],
      onDeckEmpty: () => debugPrint("Card deck empty"),
      onLeftSwipe: (Card card, List<Card> cardDeck, int cardsSwiped) {
        addCard(cardDeck);
        debugPrint("Cards Swiped: $cardsSwiped");
      },
      onRightSwipe: (Card card, List<Card> cardDeck, int cardsSwiped) {
        addCard(cardDeck);
        debugPrint("Cards Swiped: $cardsSwiped");
      },
      cardWidth: 200,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: mockDeck,
      ),
    ));

    Finder deckFinder = find.byType(SwipingCardDeck);
    expect(deckFinder, findsOneWidget);
    SwipingCardDeck deck = tester.widget(deckFinder);
    int cardsSwiped = 0;

    // Alternate swiping directions
    for (int i = 0; i < 100; ++i) {
      ++cardsSwiped;
      if (i % 2 == 0) {
        expectLater(
            () => deck.swipeLeft(), prints("Cards Swiped: $cardsSwiped\n"));
      } else {
        expectLater(
            () => deck.swipeRight(), prints("Cards Swiped: $cardsSwiped\n"));
      }

      await tester.pumpAndSettle();
      Finder cardFinder = find.byType(Card);
      expect(cardFinder, findsOneWidget);
    }
  });
}
