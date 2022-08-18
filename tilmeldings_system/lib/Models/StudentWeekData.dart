import '../Utilities/util.dart';

class StudentWeekData {
  const StudentWeekData({required this.menu, required this.states});

  final List<EnlistmentStates> states;
  final List<String> menu;

  @override
  String toString() {
    String result = "";

    for (int i = 0; i < states.length; i++) {
      result = "$result${menu[i]}|${states[i].name};";
    }

    return result;
  }
}
