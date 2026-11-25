class Surah {
  const Surah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.translation,
    required this.ayahCount,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json['number'] as int,
        arabicName: json['name']?.toString() ?? '',
        englishName: json['englishName']?.toString() ?? '',
        translation: json['englishNameTranslation']?.toString() ?? '',
        ayahCount: json['numberOfAyahs'] as int,
        revelationType: json['revelationType']?.toString() ?? '',
      );

  final int number;
  final String arabicName;
  final String englishName;
  final String translation;
  final int ayahCount;
  final String revelationType;

  String get revelationLabel =>
      revelationType == 'Meccan' ? 'Makkiyah' : 'Madaniyah';
}
