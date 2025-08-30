import 'package:hive/hive.dart';

part 'dream.g.dart';

@HiveType(typeId: 0)
class Dream extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String? summary;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? dreamDate;

  @HiveField(7)
  List<String> tags;

  @HiveField(8)
  String? emotion;

  @HiveField(9)
  bool isLucid;

  @HiveField(10)
  double? lucidityLevel;

  @HiveField(11)
  String? audioPath;

  @HiveField(12)
  Map<String, dynamic>? aiAnalysis;

  @HiveField(13)
  bool isPremium;

  Dream({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    this.imagePath,
    required this.createdAt,
    this.dreamDate,
    this.tags = const [],
    this.emotion,
    this.isLucid = false,
    this.lucidityLevel,
    this.audioPath,
    this.aiAnalysis,
    this.isPremium = false,
  });

  Dream copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? imagePath,
    DateTime? createdAt,
    DateTime? dreamDate,
    List<String>? tags,
    String? emotion,
    bool? isLucid,
    double? lucidityLevel,
    String? audioPath,
    Map<String, dynamic>? aiAnalysis,
    bool? isPremium,
  }) {
    return Dream(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      dreamDate: dreamDate ?? this.dreamDate,
      tags: tags ?? this.tags,
      emotion: emotion ?? this.emotion,
      isLucid: isLucid ?? this.isLucid,
      lucidityLevel: lucidityLevel ?? this.lucidityLevel,
      audioPath: audioPath ?? this.audioPath,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'dreamDate': dreamDate?.toIso8601String(),
      'tags': tags,
      'emotion': emotion,
      'isLucid': isLucid,
      'lucidityLevel': lucidityLevel,
      'audioPath': audioPath,
      'aiAnalysis': aiAnalysis,
      'isPremium': isPremium,
    };
  }

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
      dreamDate: json['dreamDate'] != null ? DateTime.parse(json['dreamDate']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      emotion: json['emotion'],
      isLucid: json['isLucid'] ?? false,
      lucidityLevel: json['lucidityLevel']?.toDouble(),
      audioPath: json['audioPath'],
      aiAnalysis: json['aiAnalysis'],
      isPremium: json['isPremium'] ?? false,
    );
  }
}
