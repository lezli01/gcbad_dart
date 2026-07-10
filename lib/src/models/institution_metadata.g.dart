// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstitutionMetadata _$InstitutionMetadataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstitutionMetadata',
      json,
      ($checkedConvert) {
        final val = InstitutionMetadata(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          bic: $checkedConvert('bic', (v) => v as String?),
          transactionTotalDays: $checkedConvert(
            'transaction_total_days',
            (v) => v as String?,
          ),
          countries: $checkedConvert(
            'countries',
            (v) => (v as List<dynamic>)
                .map(
                  (e) => $enumDecode(
                    _$GoCardlessCountryCodeEnumMap,
                    e,
                    unknownValue: GoCardlessCountryCode.invalid,
                  ),
                )
                .toList(),
          ),
          logo: $checkedConvert('logo', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'transactionTotalDays': 'transaction_total_days'},
    );

Map<String, dynamic> _$InstitutionMetadataToJson(
  InstitutionMetadata instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'bic': ?instance.bic,
  'transaction_total_days': ?instance.transactionTotalDays,
  'countries': instance.countries
      .map((e) => _$GoCardlessCountryCodeEnumMap[e]!)
      .toList(),
  'logo': instance.logo,
};

const _$GoCardlessCountryCodeEnumMap = {
  GoCardlessCountryCode.invalid: 'XX',
  GoCardlessCountryCode.austria: 'AT',
  GoCardlessCountryCode.belgium: 'BE',
  GoCardlessCountryCode.bulgaria: 'BG',
  GoCardlessCountryCode.croatia: 'HR',
  GoCardlessCountryCode.cyprus: 'CY',
  GoCardlessCountryCode.czechia: 'CZ',
  GoCardlessCountryCode.denmark: 'DK',
  GoCardlessCountryCode.estonia: 'EE',
  GoCardlessCountryCode.finland: 'FI',
  GoCardlessCountryCode.france: 'FR',
  GoCardlessCountryCode.germany: 'DE',
  GoCardlessCountryCode.greece: 'GR',
  GoCardlessCountryCode.hungary: 'HU',
  GoCardlessCountryCode.iceland: 'IS',
  GoCardlessCountryCode.ireland: 'IE',
  GoCardlessCountryCode.italy: 'IT',
  GoCardlessCountryCode.latvia: 'LV',
  GoCardlessCountryCode.liechtenstein: 'LI',
  GoCardlessCountryCode.lithuania: 'LT',
  GoCardlessCountryCode.luxembourg: 'LU',
  GoCardlessCountryCode.malta: 'MT',
  GoCardlessCountryCode.netherlands: 'NL',
  GoCardlessCountryCode.norway: 'NO',
  GoCardlessCountryCode.poland: 'PL',
  GoCardlessCountryCode.portugal: 'PT',
  GoCardlessCountryCode.romania: 'RO',
  GoCardlessCountryCode.slovakia: 'SK',
  GoCardlessCountryCode.slovenia: 'SI',
  GoCardlessCountryCode.spain: 'ES',
  GoCardlessCountryCode.sweden: 'SE',
  GoCardlessCountryCode.unitedKingdom: 'GB',
};
