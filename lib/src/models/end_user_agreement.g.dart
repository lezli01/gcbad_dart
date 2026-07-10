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
          maxHistoricalDays: $checkedConvert(
            'max_historical_days',
            (v) => (v as num).toInt(),
          ),
          accessValidForDays: $checkedConvert(
            'access_valid_for_days',
            (v) => (v as num).toInt(),
          ),
          accessScope: $checkedConvert(
            'access_scope',
            (v) => (v as List<dynamic>?)
                ?.map((e) => $enumDecode(_$InformationToAccessEnumMap, e))
                .toList(),
          ),
          accepted: $checkedConvert('accepted', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'institutionId': 'institution_id',
        'maxHistoricalDays': 'max_historical_days',
        'accessValidForDays': 'access_valid_for_days',
        'accessScope': 'access_scope',
      },
    );

Map<String, dynamic> _$EndUserAgreementToJson(EndUserAgreement instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'created': ?instance.created,
      'institution_id': instance.institutionId,
      'max_historical_days': instance.maxHistoricalDays,
      'access_valid_for_days': instance.accessValidForDays,
      'access_scope': ?instance.accessScope
          ?.map((e) => _$InformationToAccessEnumMap[e]!)
          .toList(),
      'accepted': ?instance.accepted,
    };

const _$InformationToAccessEnumMap = {
  InformationToAccess.balances: 'balances',
  InformationToAccess.details: 'details',
  InformationToAccess.transactions: 'transactions',
};
