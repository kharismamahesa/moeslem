class Ayah {
  const Ayah({
    required this.numberInSurah,
    required this.arabic,
    required this.translation,
  });

  final int numberInSurah;
  final String arabic;
  final String translation;
}

class SurahDetail {
  SurahDetail.fromEditions(List<dynamic> editions) {
    final arabicEdition = editions.first as Map<String, dynamic>;
    final translationEdition = editions.last as Map<String, dynamic>;
    final arabicAyahs = arabicEdition['ayahs'] as List<dynamic>;
    final translationAyahs = translationEdition['ayahs'] as List<dynamic>;

    number = arabicEdition['number'] as int;
    name = arabicEdition['englishName']?.toString() ?? '';
    arabicName = arabicEdition['name']?.toString() ?? '';
    ayahs = List.generate(arabicAyahs.length, (index) {
      final arabic = arabicAyahs[index] as Map<String, dynamic>;
      final translation = translationAyahs[index] as Map<String, dynamic>;
      return Ayah(
        numberInSurah: arabic['numberInSurah'] as int,
        arabic: arabic['text']?.toString() ?? '',
        translation: translation['text']?.toString() ?? '',
      );
    });
  }

  late final int number;
  late final String name;
  late final String arabicName;
  late final List<Ayah> ayahs;
}
