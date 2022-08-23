class Menu {

  const Menu({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday
  });

  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;

  @override
  String toString() {

    return "$monday|$tuesday|$wednesday|$thursday";
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday']
    );
  }
}