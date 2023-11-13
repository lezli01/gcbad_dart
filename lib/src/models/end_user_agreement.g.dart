// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_user_agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndUserAgreement _$EndUserAgreementFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'EndUserAgreement',
      json,
      ($checkedConvert) {
        final val = EndUserAgreement(
          id: $checkedConvert('id', (v) => v as String?),
          created: $checkedConvert('created', (v) => v as String?),
          institutionId: $checkedConvert('institution_id', (v) => v as String),
          maxHistoricalDays:
              $checkedConvert('max_historical_days', (v) => v as int),
          accessValidForDays:
              $checkedConvert('access_valid_for_days', (v) => v as int),
          accessScope: $checkedConvert(
              'access_scope',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => $enumDecode(_$InformationToAccessEnumMap, e))
                  .toList()),
          accepted: $checkedConvert('accepted', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'institutionId': 'institution_id',
        'maxHistoricalDays': 'max_historical_days',
        'accessValidForDays': 'access_valid_for_days',
        'accessScope': 'access_scope'
      },
    );

Map<String, dynamic> _$EndUserAgreementToJson(EndUserAgreement instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('created', instance.created);
  val['institution_id'] = instance.institutionId;
  val['max_historical_days'] = instance.maxHistoricalDays;
  val['access_valid_for_days'] = instance.accessValidForDays;
  writeNotNull(
      'access_scope',
      instance.accessScope
          ?.map((e) => _$InformationToAccessEnumMap[e]!)
          .toList());
  writeNotNull('accepted', instance.accepted);
  return val;
}

const _$InformationToAccessEnumMap = {
  InformationToAccess.balances: 'balances',
  InformationToAccess.details: 'details',
  InformationToAccess.transactions: 'transactions',
};
