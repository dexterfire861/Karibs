import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../providers/student_grading_provider.dart';
import 'teacher_class_screen.dart';

class TestGradeScreen extends StatefulWidget {
  final int classId;
  final String testTitle;
  final int testId;

  TestGradeScreen({
    required this.classId,
    required this.testTitle,
    required this.testId,
  });

  @override
  _TestGradeScreenState createState() => _TestGradeScreenState();
}

class _TestGradeScreenState extends State<TestGradeScreen> {
  String? _className;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _categories = [];
  Map<int, int> question_answer_map = {};
  int? _selectedStudentId;
  bool _isLoading = true;
  Map<int, int> categoryScores = {};
  Map<int, int> questionCorrectness = {};

  @override
  void initState() {
    super.initState();
    _fetchClassName();
    _fetchStudents();
    _fetchQuestions();
  }

  Future<void> _fetchClassName() async {
    String? className = await DatabaseHelper().getClassName(widget.classId);
    setState(() {
      _className = className;
    });
  }

  Future<void> _fetchStudents() async {
    List<Map<String, dynamic>> students = await DatabaseHelper().queryAllStudents(widget.classId);
    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  Future<void> _fetchQuestions() async {
    List<Map<String, dynamic>> questions = await DatabaseHelper().getQuestionsByTestId(widget.testId);
    List<Map<String, dynamic>> categories = await DatabaseHelper().getCategoriesByTestId(widget.testId);
    setState(() {
      _questions = questions;
      _categories = categories;
      _initializeCategoryScores();
      _initializeQuestionCorrectness();
    });
  }

  void _initializeCategoryScores() {
    categoryScores.clear();
    for (var category in _categories) {
      categoryScores[category['id']] = 0;
    }
  }

  void _initializeQuestionCorrectness() {
    questionCorrectness.clear();
    for (var question in _questions) {
      questionCorrectness[question['id']] = 0;
    }
  }

  void _markCorrect(int questionId, int categoryId) {
    setState(() {
      if (questionCorrectness[questionId] == -1) {
        questionCorrectness[questionId] = 1;
        categoryScores[categoryId] = (categoryScores[categoryId] ?? 0) + 1;
      } else if (questionCorrectness[questionId] == 0) {
        questionCorrectness[questionId] = 1;
        categoryScores[categoryId] = (categoryScores[categoryId] ?? 0) + 1;
      }
      question_answer_map[questionId] = 1;
    });
  }

  void _markIncorrect(int questionId, int categoryId) {
    setState(() {
      if (questionCorrectness[questionId] == 1) {
        questionCorrectness[questionId] = -1;
        categoryScores[categoryId] = (categoryScores[categoryId] ?? 0) - 1;
      }
      if (questionCorrectness[questionId] == 0) {
        questionCorrectness[questionId] = -1;
      }
      question_answer_map[questionId] = -1;
    });
  }

  void _saveGradingResults() async {
    int totalQuestions = _questions.length;
    int totalCorrect = categoryScores.values.fold(0, (sum, score) => sum + score);

    double totalScore = (totalCorrect / totalQuestions) * 100;

    Map<int, double> categoryScoresPercentage = {};
    for (var category in _categories) {
      int categoryId = category['id'];
      int categoryQuestions = _questions.where((question) => question['category_id'] == categoryId).length;
      double categoryScore = (categoryScores[categoryId] ?? 0) / categoryQuestions * 100;
      categoryScoresPercentage[categoryId] = categoryScore;
    }

    if (_selectedStudentId != null) {
      int studentTestId = await DatabaseHelper().insertStudentTest({
        'student_id': _selectedStudentId!,
        'test_id': widget.testId,
        'total_score': totalScore,
      });

      await DatabaseHelper().insertReport({
        'student_id': _selectedStudentId!,
        'test_id': widget.testId,
        'date': DateTime.now().toIso8601String(),
        'title': widget.testTitle,
        'notes': 'Graded test for student ',
        'score': totalScore,
      });

      for (var entry in question_answer_map.entries) {
        await DatabaseHelper().insertStudentTestQuestion({
          'student_test_id': studentTestId,
          'question_id': entry.key,
          'got_correct': entry.value
        });
      }

      for (var entry in categoryScoresPercentage.entries) {
        await DatabaseHelper().insertStudentTestCategoryScore({
          'student_test_id': studentTestId,
          'category_id': entry.key,
          'score': entry.value,
        });
        print(
            {
              'student_test_id': studentTestId,
              'category_id': entry.key,
              'score': entry.value,
            }
        );
      }


      // Show a confirmation message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Grades saved successfully'),
      duration: Duration(milliseconds: 1500),));


      Provider.of<StudentGradingProvider>(context, listen: false).grade();
    }
  }

  void _goToTeacherDashboard(int classId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeacherClassScreen(classId: classId, refresh: true)),
    ).then((_) {
      _fetchClassName();
      _fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grade Exam for ${widget.testTitle}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (_className != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Grading details for class: $_className and exam: ${widget.testTitle}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              hint: Text("Select Student"),
              value: _selectedStudentId,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedStudentId = newValue;
                  _initializeCategoryScores(); // Clear categoryScores when a new student is selected
                  _initializeQuestionCorrectness(); // Clear questionCorrectness when a new student is selected
                  question_answer_map.clear();
                });
              },
              items: _students.map<DropdownMenuItem<int>>((Map<String, dynamic> student) {
                return DropdownMenuItem<int>(
                  value: student['id'],
                  child: Text(student['name']),
                );
              }).toList(),
            ),
          ),
          if (_selectedStudentId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Student: ${_students.firstWhere((student) => student['id'] == _selectedStudentId)['name']}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          if (_selectedStudentId != null)
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  int questionId = _questions[index]['id'];
                  int categoryId = _questions[index]['category_id'];
                  String categoryName = _categories.firstWhere((category) => category['id'] == categoryId)['name'];
                  return ListTile(
                    title: Text(_questions[index]['text']),
                    subtitle: Text(categoryName),
                    tileColor: questionCorrectness[questionId] == 1
                        ? Colors.green.withOpacity(0.2)
                        : questionCorrectness[questionId] == -1
                        ? Colors.red.withOpacity(0.2)
                        : questionCorrectness[questionId] == 0
                        ? Colors.grey.withOpacity(0.2)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _markCorrect(questionId, categoryId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            _markIncorrect(questionId, categoryId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (_selectedStudentId != null && _questions.isNotEmpty)
                        ? () {
                      _saveGradingResults(); // Navigate to TeacherDashboard after saving results
                    }
                        : null,
                    child: Text('Save Grades'),
                  ),
                  SizedBox(width: 42), // Add some space between the buttons
                  ElevatedButton(
                    onPressed: () {
                      _goToTeacherDashboard(widget.classId); // Navigate to TeacherDashboard after saving results
                    },
                    child: Text('Go to Class'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
