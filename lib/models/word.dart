import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  String english;

  @HiveField(1)
  String japanese;

  @HiveField(2)
  String? example;

  @HiveField(3)
  bool isMemorized;

  @HiveField(4)
  int reviewCount;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? lastReviewedAt;

  Word({
    required this.english,
    required this.japanese,
    this.example,
    this.isMemorized = false,
    this.reviewCount = 0,
    required this.createdAt,
    this.lastReviewedAt,
  });
}
