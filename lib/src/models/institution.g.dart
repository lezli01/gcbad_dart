// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Institution _$InstitutionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Institution',
      json,
      ($checkedConvert) {
        final val = Institution(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          bic: $checkedConvert('bic', (v) => v as String?),
          transactionTotalDays:
              $checkedConvert('transaction_total_days', (v) => v as String?),
          countries: $checkedConvert('countries',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          logo: $checkedConvert('logo', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'transactionTotalDays': 'transaction_total_days'},
    );

Map<String, dynamic> _$InstitutionToJson(Institution instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bic', instance.bic);
  writeNotNull('transaction_total_days', instance.transactionTotalDays);
  val['countries'] = instance.countries;
  val['logo'] = instance.logo;
  return val;
}
