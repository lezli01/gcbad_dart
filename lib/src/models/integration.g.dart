// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Integration _$IntegrationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Integration',
      json,
      ($checkedConvert) {
        final val = Integration(
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

Map<String, dynamic> _$IntegrationToJson(Integration instance) {
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
