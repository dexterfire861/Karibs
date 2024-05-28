import 'package:flutter/material.dart';
import 'package:karibs/database/database_helper.dart';
import 'student_info_screen.dart';
import 'add_student_screen.dart';

class TeacherClassScreen extends StatefulWidget {
  final int classId;

  TeacherClassScreen({required this.classId});

  @override
  _TeacherClassScreenState createState() => _TeacherClassScreenState();
}

Color getStatusColor(String currStatus){
  switch(currStatus){
    case 'Doing well':
      return Colors.green;
    case 'Doing okay':
      return Colors.yellow;
    case 'Needs help':
      return Colors.red;
    default:
      return Colors.white;
  }
}

String changeStatus(double avgScore){
  if(avgScore >=70){
    return 'Doing well';
  }
  else if(avgScore >=50){
    return 'Doing okay';
  }
  else{
    return 'Needs help';
  }
}

class _TeacherClassScreenState extends State<TeacherClassScreen> {
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final data = await DatabaseHelper().queryAllStudents(widget.classId);
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  void _addStudent(Map<String, dynamic> student) async {
    await DatabaseHelper().insertStudent(student);
    _fetchStudents();
  }

  void _navigateToAddStudentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentScreen(
          classId: widget.classId,
          onStudentAdded: (student) {
            _addStudent(student);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Class Screen'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No students available. Please add!'),
            SizedBox(height: 20),

          ],
        ),
      )
          : Stack(
        children: [
      ListView.builder(
      itemCount: _students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                // Display the average score in a circle
                Container(
                  width: 40, // Adjust the width as needed
                  height: 40, // Adjust the height as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getStatusColor(_students[index]['status']), // Customize the color as needed
                  ),
                  child: Center(
                    child: Text(
                      '${_students[index]['average_score']?.round() ?? ''}',
                      style: TextStyle(
                        color: Colors.white, // Customize the text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add spacing between the circle and the name
                // Display the student's name
                Text(
                  '${_students[index]['name']}',
                  style: TextStyle(
                    color: Colors.black, // Adjust as needed
                  ),
                ),
              ],
            ),
            subtitle: Text(_students[index]['status'] ?? 'No status'),
            onTap: () async {
              setState((){
                _fetchStudents();
              });
              final result = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentInfoScreen(studentId: _students[index]['id']),
                ),
              );
              if(result == true) {
                _fetchStudents();
              }
            },
          );
        },
      ),
          Positioned(
            bottom: 30,
            left: 125,
            child: ElevatedButton(
              onPressed: _navigateToAddStudentScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text('Add Student +'),
            ),
          ),
        ],
      ),
    );
  }
}
