class AppLocation {
  const AppLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    this.isDefault = false,
  });

  static const pekanbaru = AppLocation(
    latitude: 0.4699,
    longitude: 101.4478,
    label: 'Pekanbaru, Riau',
    isDefault: true,
  );

  final double latitude;
  final double longitude;
  final String label;
  final bool isDefault;

  String get coordinateLabel =>
      '${latitude.toStringAsFixed(3)}, ${longitude.toStringAsFixed(3)}';
}
