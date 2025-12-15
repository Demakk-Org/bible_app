//
// ignore_for_file: lines_longer_than_80_chars

import 'dart:math';

import 'package:bible_app/features/bible/data/model/verse.dart';

class VerseLibrary {
  static final List<Verse> verses = [
    Verse(
      bookName: "Genesis",
      book: 1,
      chapter: 1,
      verse: 1,
      text: "In the beginning God created the heavens and the earth.",
    ),
    Verse(
      bookName: "Exodus",
      book: 2,
      chapter: 14,
      verse: 14,
      text: "The Lord will fight for you; you need only to be still.",
    ),
    Verse(
      bookName: "Psalms",
      book: 19,
      chapter: 23,
      verse: 1,
      text: "The Lord is my shepherd, I lack nothing.",
    ),
    Verse(
      bookName: "Proverbs",
      book: 20,
      chapter: 3,
      verse: 5,
      text:
          "Trust in the Lord with all your heart and lean not on your own understanding.",
    ),
    Verse(
      bookName: "Isaiah",
      book: 23,
      chapter: 40,
      verse: 31,
      text:
          "But those who hope in the Lord will renew their strength. They will soar on wings like eagles.",
    ),
    Verse(
      bookName: "John",
      book: 43,
      chapter: 3,
      verse: 16,
      text:
          "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
    ),
    Verse(
      bookName: "Romans",
      book: 45,
      chapter: 8,
      verse: 28,
      text:
          "And we know that in all things God works for the good of those who love him.",
    ),
    Verse(
      bookName: "1 Corinthians",
      book: 46,
      chapter: 13,
      verse: 4,
      text:
          "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.",
    ),
    Verse(
      bookName: "Philippians",
      book: 50,
      chapter: 4,
      verse: 13,
      text: "I can do all this through him who gives me strength.",
    ),
    Verse(
      bookName: "Revelation",
      book: 66,
      chapter: 21,
      verse: 4,
      text:
          "‘He will wipe every tear from their eyes. There will be no more death or mourning or crying or pain.’",
    ),
  ];

  static Verse getRandomVerse() {
    final random = Random().nextInt(verses.length);
    final randomVerse = verses[random];
    return randomVerse;
  }
}
