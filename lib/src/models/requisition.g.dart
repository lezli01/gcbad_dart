// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requisition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Requisition _$RequisitionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Requisition',
      json,
      ($checkedConvert) {
        final val = Requisition(
          id: $checkedConvert('id', (v) => v as String),
          created: $checkedConvert('created', (v) => v as String?),
          redirect: $checkedConvert('redirect', (v) => v as String),
          status: $checkedConvert('status',
              (v) => $enumDecodeNullable(_$RequisitionStatusEnumMap, v)),
          institutionId: $checkedConvert('institution_id', (v) => v as String),
          agreement: $checkedConvert('agreement', (v) => v as String?),
          reference: $checkedConvert('reference', (v) => v as String?),
          accounts: $checkedConvert('accounts',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          userLanguage: $checkedConvert('user_language', (v) => v as String?),
          link: $checkedConvert('link', (v) => v as String),
          ssn: $checkedConvert('ssn', (v) => v as String?),
          accountSelection:
              $checkedConvert('account_selection', (v) => v as bool?),
          redirectImmediate:
              $checkedConvert('redirect_immediate', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'institutionId': 'institution_id',
        'userLanguage': 'user_language',
        'accountSelection': 'account_selection',
        'redirectImmediate': 'redirect_immediate'
      },
    );

Map<String, dynamic> _$RequisitionToJson(Requisition instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('created', instance.created);
  val['redirect'] = instance.redirect;
  writeNotNull('status', _$RequisitionStatusEnumMap[instance.status]);
  val['institution_id'] = instance.institutionId;
  writeNotNull('agreement', instance.agreement);
  writeNotNull('reference', instance.reference);
  writeNotNull('accounts', instance.accounts);
  writeNotNull('user_language', instance.userLanguage);
  val['link'] = instance.link;
  writeNotNull('ssn', instance.ssn);
  writeNotNull('account_selection', instance.accountSelection);
  writeNotNull('redirect_immediate', instance.redirectImmediate);
  return val;
}

const _$RequisitionStatusEnumMap = {
  RequisitionStatus.created: 'CR',
  RequisitionStatus.givingConsent: 'GC',
  RequisitionStatus.undergoingAuthentication: 'UA',
  RequisitionStatus.rejected: 'RJ',
  RequisitionStatus.selectingAccounts: 'SA',
  RequisitionStatus.grantingAccess: 'GA',
  RequisitionStatus.linked: 'LN',
  RequisitionStatus.expired: 'EX',
};
