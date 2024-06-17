import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:karibs/main.dart';

class ViewTestGradeScreen extends StatefulWidget {
  final int reportId;

  ViewTestGradeScreen({required this.reportId});

  @override
  _ViewTestGradeScreenState createState() => _ViewTestGradeScreenState();
}

class _ViewTestGradeScreenState extends State<ViewTestGradeScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _questions = [];
  Map<int, List<Map<String, dynamic>>> _choices = {};

  @override
  void initState() {
    super.initState();
    _fetchQuestionsAndAnswers();
  }

  Future<void> _fetchQuestionsAndAnswers() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.getQuestionsAndAnswersForReport(widget.reportId);

    setState(() {
      _questions = result['questions'];

      // Group choices by question_id
      _choices = {};
      for (var choice in result['choices']) {
        int questionId = choice['question_id'];
        if (_choices[questionId] == null) {
          _choices[questionId] = [];
        }
        _choices[questionId]!.add(choice);
      }

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: White,
        backgroundColor: DeepPurple,
        title: Text('Exam Grade Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: 8),
                Text('Green tile means the student got it correct.'),
                SizedBox(width: 16),
                Icon(Icons.close, color: Colors.red),
                SizedBox(width: 8),
                Text('Red tile means the student got it incorrect.'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  color: question['got_correct'] == 1 ? Colors.green[100] : Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['question_text'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Category: ${question['question_category']}'),
                        Divider(),
                        Text(
                          'Choices:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...(_choices[question['question_id']] ?? []).map((choice) {
                          return ListTile(
                            title: Text(choice['choice_text']),
                            trailing: Icon(
                              choice['is_correct'] == 1 ? Icons.check : Icons.close,
                              color: choice['is_correct'] == 1 ? Colors.green : Colors.red,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
