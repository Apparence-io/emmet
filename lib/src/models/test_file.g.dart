// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestFile _$TestFileFromJson(Map<String, dynamic> json) {
  return TestFile(
    path: json['path'] as String,
    tests: (json['tests'])
        .map((e) => TestMethod.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TestFileToJson(TestFile instance) => <String, dynamic>{
      'path': instance.path,
      'tests': instance.tests,
    };

TestMethod _$TestMethodFromJson(Map<String, dynamic> json) {
  return TestMethod(
    name: json['name'] as String?,
    type: _$enumDecode(_$TestTypeEnumMap, json['type']),
    assertions: (json['assertions'])
        .map((e) => AssertionCall.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TestMethodToJson(TestMethod instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TestTypeEnumMap[instance.type],
      'assertions': instance.assertions,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$TestTypeEnumMap = {
  TestType.DART: 'DART',
  TestType.WIDGET: 'WIDGET',
};

AssertionCall _$AssertionCallFromJson(Map<String, dynamic> json) {
  return AssertionCall(
    reason: json['reason'] as String?,
    expectedExpr: json['expectedExpr'] as String,
    actualExpr: json['actualExpr'] as String,
  );
}

Map<String, dynamic> _$AssertionCallToJson(AssertionCall instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'expectedExpr': instance.expectedExpr,
      'actualExpr': instance.actualExpr,
    };
