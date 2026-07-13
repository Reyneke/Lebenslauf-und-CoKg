import 'package:json_annotation/json_annotation.dart';

part 'cv_data.g.dart';

@JsonSerializable()
class CvData {
  final Person person;
  final List<CvEntry> entries;
  final List<Skill> skills;

  CvData({
    required this.person,
    required this.entries,
    required this.skills,
  });

  factory CvData.fromJson(Map<String, dynamic> json) => _$CvDataFromJson(json);
  Map<String, dynamic> toJson() => _$CvDataToJson(this);
}

@JsonSerializable()
class Person {
  final String name;
  final String? photo;

  Person({required this.name, this.photo});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class CvEntry {
  final String type; // "experience" | "certificate" | "education"
  final String title;
  final String? organization;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? issuer;
  final String? file;
  final List<String>? tags;

  CvEntry({
    required this.type,
    required this.title,
    this.organization,
    this.startDate,
    this.endDate,
    this.description,
    this.issuer,
    this.file,
    this.tags,
  });

  factory CvEntry.fromJson(Map<String, dynamic> json) =>
      _$CvEntryFromJson(json);
  Map<String, dynamic> toJson() => _$CvEntryToJson(this);
}

@JsonSerializable()
class Skill {
  final String name;
  final String category;
  final int level;

  Skill({
    required this.name,
    required this.category,
    required this.level,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}