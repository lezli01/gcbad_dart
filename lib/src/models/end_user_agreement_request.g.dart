// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_user_agreement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndUserAgreementRequest _$EndUserAgreementRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'EndUserAgreementRequest',
      json,
      ($checkedConvert) {
        final val = EndUserAgreementRequest(
          institutionId: $checkedConvert('institution_id', (v) => v as String),
          maxHistoricalDays:
              $checkedConvert('max_historical_days', (v) => v as int?),
          accessValidForDays:
              $checkedConvert('access_valid_for_days', (v) => v as int?),
          accessScope: $checkedConvert(
              'access_scope',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => $enumDecode(_$InformationToAccessEnumMap, e))
                  .toList()),
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

Map<String, dynamic> _$EndUserAgreementRequestToJson(
    EndUserAgreementRequest instance) {
  final val = <String, dynamic>{
    'institution_id': instance.institutionId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('max_historical_days', instance.maxHistoricalDays);
  writeNotNull('access_valid_for_days', instance.accessValidForDays);
  writeNotNull(
      'access_scope',
      instance.accessScope
          ?.map((e) => _$InformationToAccessEnumMap[e]!)
          .toList());
  return val;
}

const _$InformationToAccessEnumMap = {
  InformationToAccess.balances: 'balances',
  InformationToAccess.details: 'details',
  InformationToAccess.transactions: 'transactions',
};
