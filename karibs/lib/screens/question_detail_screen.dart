import 'package:flutter/material.dart';
import 'package:karibs/database/database_helper.dart';

class QuestionDetailScreen extends StatefulWidget {
  final int questionId;

  const QuestionDetailScreen({super.key, required this.questionId});

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  Map<String, dynamic>? _question;
  List<Map<String, dynamic>> _choices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestionDetails();
  }

  Future<void> _fetchQuestionDetails() async {
    final question = await DatabaseHelper().queryQuestion(widget.questionId);
    final choices = await DatabaseHelper().queryAllQuestionChoices(widget.questionId);
    setState(() {
      _question = question;
      _choices = choices;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _question == null
          ? const Center(child: Text('Question not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Question: ${_question!['text']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${_question!['category']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_choices.isNotEmpty)
              const Text(
                'Choices:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ..._choices.map((choice) {
              return ListTile(
                title: Text(choice['choice_text']),
                trailing: choice['is_correct'] == 1 ? const Icon(Icons.check, color: Colors.green) : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
