import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/word.dart';

class WordProvider extends ChangeNotifier {
  late Box<Word> _box;

  WordProvider() {
    _box = Hive.box<Word>('words');
  }

  List<Word> get allWords => _box.values.toList();

  List<Word> get memorizedWords =>
      _box.values.where((w) => w.isMemorized).toList();

  List<Word> get unstudiedWords =>
      _box.values.where((w) => !w.isMemorized).toList();

  int get totalCount => _box.length;
  int get memorizedCount => memorizedWords.length;

  Future<void> addWord(String english, String japanese, {String? example}) async {
    final word = Word(
      english: english,
      japanese: japanese,
      example: example,
      createdAt: DateTime.now(),
    );
    await _box.add(word);
    notifyListeners();
  }

  Future<void> deleteWord(Word word) async {
    await word.delete();
    notifyListeners();
  }

  Future<void> toggleMemorized(Word word) async {
    word.isMemorized = !word.isMemorized;
    word.lastReviewedAt = DateTime.now();
    await word.save();
    notifyListeners();
  }

  Future<void> recordReview(Word word) async {
    word.reviewCount++;
    word.lastReviewedAt = DateTime.now();
    await word.save();
    notifyListeners();
  }

  Future<void> updateWord(Word word, String english, String japanese,
      {String? example}) async {
    word.english = english;
    word.japanese = japanese;
    word.example = example;
    await word.save();
    notifyListeners();
  }
}
