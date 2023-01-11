// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_data_structs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionData _$PositionDataFromJson(Map<String, dynamic> json) =>
    PositionData._(
      json['companyName'] as String,
      json['title'] as String,
      json['description'] as String,
      json['location'] as String,
      json['startedOn'] == null
          ? null
          : DateTime.parse(json['startedOn'] as String),
      json['finishedOn'] == null
          ? null
          : DateTime.parse(json['finishedOn'] as String),
    );

Map<String, dynamic> _$PositionDataToJson(PositionData instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'startedOn': instance.startedOn?.toIso8601String(),
      'finishedOn': instance.finishedOn?.toIso8601String(),
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      json['firstName'] as String,
      json['secondName'] as String,
      json['headline'] as String,
      json['industry'] as String,
      json['location'] as String,
      json['email'] as String,
      json['summary'] as String,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'secondName': instance.secondName,
      'headline': instance.headline,
      'industry': instance.industry,
      'location': instance.location,
      'email': instance.email,
      'summary': instance.summary,
    };

EducationData _$EducationDataFromJson(Map<String, dynamic> json) =>
    EducationData._(
      json['schoolName'] as String,
      json['startedOn'] == null
          ? null
          : DateTime.parse(json['startedOn'] as String),
      json['finishedOn'] == null
          ? null
          : DateTime.parse(json['finishedOn'] as String),
      json['degree'] as String,
      json['course'] as String,
    );

Map<String, dynamic> _$EducationDataToJson(EducationData instance) =>
    <String, dynamic>{
      'schoolName': instance.schoolName,
      'startedOn': instance.startedOn?.toIso8601String(),
      'finishedOn': instance.finishedOn?.toIso8601String(),
      'degree': instance.degree,
      'course': instance.course,
    };

SkillData _$SkillDataFromJson(Map<String, dynamic> json) => SkillData(
      json['skill'] as String,
    );

Map<String, dynamic> _$SkillDataToJson(SkillData instance) => <String, dynamic>{
      'skill': instance.skill,
    };

CvData _$CvDataFromJson(Map<String, dynamic> json) => CvData._(
      (json['positions'] as List<dynamic>)
          .map((e) => PositionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['education'] as List<dynamic>)
          .map((e) => EducationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['skills'] as List<dynamic>)
          .map((e) => SkillData.fromJson(e as Map<String, dynamic>))
          .toList(),
      ProfileData.fromJson(json['profileData'] as Map<String, dynamic>),
      DateTime.parse(json['timeOfCreation'] as String),
    );

Map<String, dynamic> _$CvDataToJson(CvData instance) => <String, dynamic>{
      'positions': instance.positions.map((e) => e.toJson()).toList(),
      'education': instance.education.map((e) => e.toJson()).toList(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'profileData': instance.profileData.toJson(),
      'timeOfCreation': instance.timeOfCreation.toIso8601String(),
    };
