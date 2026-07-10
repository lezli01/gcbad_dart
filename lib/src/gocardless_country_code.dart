import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum GoCardlessCountryCode {
  /// Sentinel for the ISO 3166 user-assigned `XX` code, and the fallback that
  /// unrecognized country codes deserialize to (see `unknownEnumValue` on
  /// `InstitutionMetadata.countries`).
  invalid('XX'),
  austria('AT'),
  belgium('BE'),
  bulgaria('BG'),
  croatia('HR'),
  cyprus('CY'),
  czechia('CZ'),
  denmark('DK'),
  estonia('EE'),
  finland('FI'),
  france('FR'),
  germany('DE'),
  greece('GR'),
  hungary('HU'),
  iceland('IS'),
  ireland('IE'),
  italy('IT'),
  latvia('LV'),
  liechtenstein('LI'),
  lithuania('LT'),
  luxembourg('LU'),
  malta('MT'),
  netherlands('NL'),
  norway('NO'),
  poland('PL'),
  portugal('PT'),
  romania('RO'),
  slovakia('SK'),
  slovenia('SI'),
  spain('ES'),
  sweden('SE'),
  unitedKingdom('GB');

  const GoCardlessCountryCode(this.code);

  final String code;
}
