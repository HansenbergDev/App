class Student {

  const Student({
    required this.studentName,
    required this.enrolledFrom,
    required this.enrolledTo
  });

  final String studentName;
  final DateTime enrolledFrom;
  final DateTime enrolledTo;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        studentName: json['name'],
        enrolledFrom: DateTime.parse(json['enrolled_from']),
        enrolledTo: DateTime.parse(json['enrolled_to'])
    );
  }
}