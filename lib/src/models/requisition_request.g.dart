// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requisition_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequisitionRequest _$RequisitionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RequisitionRequest',
      json,
      ($checkedConvert) {
        final val = RequisitionRequest(
          redirectUrl: $checkedConvert('redirect', (v) => v as String?),
          institutionId: $checkedConvert('institution_id', (v) => v as String),
          agreementId: $checkedConvert('agreement', (v) => v as String?),
          reference: $checkedConvert('reference', (v) => v as String?),
          userLanguage: $checkedConvert('user_language', (v) => v as String?),
          ssn: $checkedConvert('ssn', (v) => v as String?),
          accountSelection: $checkedConvert(
            'account_selection',
            (v) => v as bool?,
          ),
          redirectImmediate: $checkedConvert(
            'redirect_immediate',
            (v) => v as bool?,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'redirectUrl': 'redirect',
        'institutionId': 'institution_id',
        'agreementId': 'agreement',
        'userLanguage': 'user_language',
        'accountSelection': 'account_selection',
        'redirectImmediate': 'redirect_immediate',
      },
    );

Map<String, dynamic> _$RequisitionRequestToJson(RequisitionRequest instance) =>
    <String, dynamic>{
      'redirect': instance.redirectUrl,
      'institution_id': instance.institutionId,
      'agreement': ?instance.agreementId,
      'reference': ?instance.reference,
      'user_language': ?instance.userLanguage,
      'ssn': ?instance.ssn,
      'account_selection': ?instance.accountSelection,
      'redirect_immediate': ?instance.redirectImmediate,
    };
