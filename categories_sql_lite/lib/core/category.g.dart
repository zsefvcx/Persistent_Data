// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int?,
      gid: json['gid'] as int? ?? 0,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'gid': instance.gid,
      'category': instance.category,
      'description': instance.description,
      'image': instance.image,
    };
