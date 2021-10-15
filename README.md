<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A widget for swiping through a deck of cards with gestures or buttons.

This package was inspired when I was trying to develop a Tinder-like app
that involved swiping options to the left or right. I assumed that a package
existed for such a popular functionality, but I searched the internet and could
only find bits and pieces of different implementations that were confusing, 
complicated, and down right bad. This package aims to be an easy-to-use and
customizable way to implement that functionality, and will hopefully save you
a great amount of time!

![SwipingCardDeck Demonstration](https://github.com/jushutch/swiping_card_deck/raw/de09811abff593784df72d9c7c1be00f5f60f2db/gif/swiping_card_deck.gif)

## Features

The SwipingCardDeck widget offers a variety of unique features:

- Swipe through cards by dragging or using buttons to hook into the public
swipeLeft and swipeRight functions.
- Provide custom callback functions for when the deck is empty and for each 
swiping direction, which also pass in the original Card object.
- Use custom Cards of any shape, size, or content.
- Optimized performance by rendering top two cards at a time, allowing for large
decks with no decrease in user experience.
- A variety of exposed properties allow for a swiping experience that can be
designed for any need.
- Great for any Tinder-like decision making application.

The current limitations of the package:

- Only accepts a list of Card widgets.
- Only supports horizontal swiping, not vertical.

## Usage

Constructing a SwipingCardDeck with two cards and two buttons that can be used
for swiping. Callback functions print out debugging information. The parameters
minimumVelocity, rotationFactor, and swipeThreshold are all optional, but are set
to the default values which work well for most use cases.

```dart
SwipingCardDeck(
    cardDeck: <Card>[
        Card(
            color: Colors.red,
            child: const SizedBox(height: 300, width: 200,)
        ),
        Card(
            color: Colors.green,
            child: const SizedBox(height: 300, width: 200,)
        ),
    ],
    onDeckEmpty: () => debugPrint("Card deck empty"),
    onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
    onRightSwipe: (Card card) => debugPrint("Swiped right!"),
    swipeThreshold: MediaQuery.of(context).size.width / 4,
    minimumVelocity: 1000,
    cardWidth: 200,
    rotationFactor: 0.8 / 3.14;
);
```

## Additional information
### Issues and suggestions
This package is being actively maintained and developed. To submit ideas,
issues, or suggestions, create an issue in the
[GitHub repository](https://github.com/jushutch/swiping_card_deck). 

### Contributing
Thank you for your interest in contributing! To get started, read through 
the documentation in [CONTRIBUTING](https://github.com/jushutch/swiping_card_deck/blob/main/CONTRIBUTING.md).
There are always new issues coming so be sure to check back often, and if there's
something you want to work on but there's no issue, just open one yourself!

