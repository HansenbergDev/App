class Enlistment {

  const Enlistment({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday
  });

  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;

  @override
  String toString() {
    return "$monday|$tuesday|$wednesday|$thursday|$friday";
  }

  factory Enlistment.fromJson(Map<String, dynamic> json) {
    return Enlistment(
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday'],
        friday: json['friday'],
    );
  }
}