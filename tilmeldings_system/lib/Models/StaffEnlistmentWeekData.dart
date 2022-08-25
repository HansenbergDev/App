class StaffEnlistmentWeekData extends Iterable<int>{

  const StaffEnlistmentWeekData({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday
  });

  final int monday;
  final int tuesday;
  final int wednesday;
  final int thursday;

  factory StaffEnlistmentWeekData.fromJson(Map<String, dynamic> json) {
    return StaffEnlistmentWeekData(
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday']
    );
  }

  @override
  Iterator<int> get iterator => [monday, tuesday, wednesday, thursday].iterator;
}