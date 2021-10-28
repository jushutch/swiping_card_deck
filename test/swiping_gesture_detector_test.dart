import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swiping_card_deck/src/swiping_gesture_detector.dart';
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

  Future<void> _mountWidget(WidgetTester tester) async {
    final List<Card> cardDeck = getMockCards();
    SwipingGestureDetector mockDetector = SwipingGestureDetector(
      cardDeck: cardDeck,
      swipeLeft: () {
        debugPrint("Swiped left!");
        cardDeck.removeLast();
      }, 
      swipeRight: () {
        debugPrint("Swiped right!");
        cardDeck.removeLast();
      }, 
      cardWidth: 200,
      swipeThreshold: 200,
      minimumVelocity: 1000,
      rotationFactor: 0,
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: mockDetector,),));
  }

  testWidgets("SwipingCardDeck widget is created", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder gestureFinder = find.byType(SwipingGestureDetector);
    expect(gestureFinder, findsOneWidget);
  });

  testWidgets("Card is swiped at correct thresholds", (WidgetTester tester) async {
    await _mountWidget(tester);
    Finder gestureFinder = find.byType(SwipingGestureDetector);
    expect(gestureFinder, findsOneWidget);
    SwipingGestureDetector detector = tester.widget(gestureFinder);
    
    // Test the right swipe threshold
    await expectLater(
      () async => await tester.drag(gestureFinder, const Offset(200, 0)), 
      prints("Swiped right!\n")
    );
    expect(detector.cardDeck.length, numCards - 1);
    await expectLater(
      () async => await tester.drag(gestureFinder, const Offset(199, 0)), 
      prints("")
    );
    expect(detector.cardDeck.length, numCards - 1);

    // Test the left swipe threshold
    await expectLater(
      () async => await tester.drag(gestureFinder, const Offset(-200, 0)), 
      prints("Swiped left!\n")
    );
    expect(detector.cardDeck.length, numCards - 2);
    await expectLater(
      () async => await tester.drag(gestureFinder, const Offset(-199, 0)), 
      prints("")
    );
    expect(detector.cardDeck.length, numCards - 2);
  });

  testWidgets("Card springs back to center", (WidgetTester tester) async {
    // NOTE: The Offset values for the drag gesture are rounded because
    // the dragAlignment is converted from pixels to a percentage which
    // is imprecise.
    await _mountWidget(tester);
    Finder gestureFinder = find.byType(SwipingGestureDetector);
    expect(gestureFinder, findsOneWidget);
    SwipingGestureDetector detector = tester.widget(gestureFinder);
    Finder topCardFinder = find.byWidget(detector.cardDeck.last);
    expect(topCardFinder, findsOneWidget);
    Offset initial = tester.getCenter(topCardFinder);

    // Run drag gesture that moves to the right 30, holds, and then releases
    TestGesture gesture = await tester.startGesture(initial);
    await gesture.moveBy(const Offset(30, 0));
    await tester.pumpAndSettle();

    Offset newCenter = tester.getCenter(topCardFinder);
    newCenter = Offset(newCenter.dx.round().toDouble(), newCenter.dy.round().toDouble());
    expect(newCenter, initial + const Offset(30, 0));

    // Assert that the top card is animated after the drag is released
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 2));
    expect(tester.getCenter(topCardFinder), isNot(newCenter));
    expect(tester.getCenter(topCardFinder), isNot(initial));

    // Assert that the top card returns to the initial position
    await tester.pumpAndSettle();
    newCenter = tester.getCenter(topCardFinder);
    newCenter = Offset(newCenter.dx.round().toDouble(), newCenter.dy.round().toDouble());
    expect(newCenter, initial);
  });

  testWidgets("Card is swiped at minimum velocity", (WidgetTester tester) async {
    // NOTE: The fling velocity values are slightly generous due to the
    // imprecision of the drag details velocity.
    await _mountWidget(tester);
    Finder gestureFinder = find.byType(SwipingGestureDetector);
    expect(gestureFinder, findsOneWidget);
    SwipingGestureDetector detector = tester.widget(gestureFinder);
    
    // Test the right swipe velocity
    await expectLater(
      () async => await tester.fling(gestureFinder, const Offset(199, 0), 1001), 
      prints("Swiped right!\n")
    );
    //await tester.flingFrom(tester.getCenter(gestureFinder), const Offset(199, 0), 1000);
    expect(detector.cardDeck.length, numCards - 1);
    await expectLater(
      () async => await tester.fling(gestureFinder, const Offset(199, 0), 999), 
      prints("")
    );
    expect(detector.cardDeck.length, numCards - 1);
    await tester.pumpAndSettle();

    // Test the left swipe velocity
    await expectLater(
      () async => await tester.fling(gestureFinder, const Offset(-199, 0), 1001), 
      prints("Swiped left!\n")
    );
    expect(detector.cardDeck.length, numCards - 2);
    await expectLater(
      () async => await tester.fling(gestureFinder, const Offset(-199, 0), 999), 
      prints("")
    );
    expect(detector.cardDeck.length, numCards - 2);
  });
}
