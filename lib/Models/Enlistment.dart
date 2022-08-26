

class Enlistment extends Iterable<bool>{

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

  factory Enlistment.fromNullableBoolList(List<bool?> list) {
    return Enlistment(
        monday: list[0]!,
        tuesday: list[1]!,
        wednesday: list[2]!,
        thursday: list[3]!,
        friday: list[4]!
    );
  }

  @override
  Iterator<bool> get iterator => [monday, tuesday, wednesday, thursday, friday].iterator;
}