import 'package:tilmeldings_system/Utilities/util.dart';

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

  factory Enlistment.fromEnlistmentStates(List<EnlistmentStates> list) {
    return Enlistment(
        monday: EnlistmentStatesToBool(list[0]),
        tuesday: EnlistmentStatesToBool(list[1]),
        wednesday: EnlistmentStatesToBool(list[2]),
        thursday: EnlistmentStatesToBool(list[3]),
        friday: EnlistmentStatesToBool(list[4])
    );
  }

  @override
  Iterator<bool> get iterator => [monday, tuesday, wednesday, thursday, friday].iterator;
}