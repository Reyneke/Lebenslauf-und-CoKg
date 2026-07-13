// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cv_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CvData _$CvDataFromJson(Map<String, dynamic> json) => CvData(
  person: Person.fromJson(json['person'] as Map<String, dynamic>),
  entries: (json['entries'] as List<dynamic>)
      .map((e) => CvEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  skills: (json['skills'] as List<dynamic>)
      .map((e) => Skill.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CvDataToJson(CvData instance) => <String, dynamic>{
  'person': instance.person,
  'entries': instance.entries,
  'skills': instance.skills,
};

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  name: json['name'] as String,
  photo: json['photo'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  github: json['github'] as String?,
  address: json['address'] as String?,
  birthDate: json['birthDate'] as String?,
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'name': instance.name,
  'photo': instance.photo,
  'email': instance.email,
  'phone': instance.phone,
  'github': instance.github,
  'address': instance.address,
  'birthDate': instance.birthDate,
};

CvEntry _$CvEntryFromJson(Map<String, dynamic> json) => CvEntry(
  type: json['type'] as String,
  title: json['title'] as String,
  organization: json['organization'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  description: json['description'] as String?,
  issuer: json['issuer'] as String?,
  file: json['file'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CvEntryToJson(CvEntry instance) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'organization': instance.organization,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'description': instance.description,
  'issuer': instance.issuer,
  'file': instance.file,
  'tags': instance.tags,
};

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
  name: json['name'] as String,
  category: json['category'] as String,
  level: (json['level'] as num).toInt(),
);

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
  'name': instance.name,
  'category': instance.category,
  'level': instance.level,
};
