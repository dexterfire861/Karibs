import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:karibs/database/database_helper.dart';
import 'add_report_screen.dart';
import 'teacher_class_screen.dart';

class EditStudentScreen extends StatefulWidget {
  final int studentId;

  EditStudentScreen({required this.studentId});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  Map<String, dynamic>? _student;
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;
  double? _averageScore = 0.0;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  void _navigateToAddReportScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReportScreen(studentId: widget.studentId),
      ),
    ).then((result) {
      if (result != null && result == true) {
        // Refresh the screen or perform any other action after adding a report
        _fetchStudentData();
      }
    });
  }


  Future<void> _fetchStudentData() async {
    final student = await DatabaseHelper().queryStudent(widget.studentId);
    final reports = await DatabaseHelper().queryAllReports(widget.studentId);
    final averageScore = await DatabaseHelper().queryAverageScore(widget.studentId);
    if(averageScore != null){
      String newStatus = changeStatus(averageScore);
      final status = await DatabaseHelper().updateStudentStatus(widget.studentId, newStatus);
    }
    // Convert the read-only list to a mutable list before sorting
    final mutableReports = List<Map<String, dynamic>>.from(reports);
    mutableReports.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    setState(() {
      _student = student;
      _reports = mutableReports;
      _averageScore = averageScore;
      _nameController.text = _student!['name'];
      _isLoading = false;
    });
  }

  void _addReport(String title, String notes, int? score) async {
    await DatabaseHelper().insertReport({
      'date': DateTime.now().toIso8601String(),
      'title': title,
      'notes': notes,
      'score': score,
      'student_id': widget.studentId,
    });
    _fetchStudentData();
  }


  void _showAddReportDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              TextField(
                controller: scoreController,
                decoration: InputDecoration(labelText: 'Score (optional)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _fetchStudentData();
                Navigator.of(context).pop(true);

              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && notesController.text.isNotEmpty) {
                  _addReport(
                    titleController.text,
                    notesController.text,
                    scoreController.text.isNotEmpty ? int.parse(scoreController.text) : null,
                  );
                  Navigator.of(context).pop(true);

                }
                _fetchStudentData();
              },

              child: Text('Add'),


            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _prepareDataForChart() {
    List<FlSpot> spots = [];
    for (var report in _reports) {
      int id = report['id'];
      double score = report['score'] != null ? report['score'].toDouble(): 0.0;
      spots.add(FlSpot(id.toDouble(), score));
    }
    return spots;
  }

  double _getMinX() {
    if(_reports.isEmpty){
      return 0.0;
    }
    int min = _reports.map((report) => report['id']).reduce((a, b) => a < b ? a : b);
    return min.toDouble();
  }

  double _getMaxX() {
    if(_reports.isEmpty){
      return 0.0;
    }
    int max = _reports.map((report) => report['id']).reduce((a, b) => a >= b ? a : b);
    return max.toDouble();
  }

  String _formatDate(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return '${date.day}/${date.month}';
  }

  void _updateStudentName(String newName) async{
    await DatabaseHelper().updateStudentName(widget.studentId, newName);
    setState(() {
      _student!['name'] = newName;
    });

  }

  void _deleteStudent() async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirm
            child: Text('Delete'),
          ),
        ],
      ),
    );
    // Delete the student if confirmed
    if (confirmDelete == true) {
      await DatabaseHelper().deleteStudent(widget.studentId);
      Navigator.pop(context, true);
      Navigator.pop(context, true);// Navigate back to the previous screen
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Student'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(true);
              }
          ),
          actions: [
            IconButton(onPressed: _deleteStudent, icon: Icon(Icons.delete))
          ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if(_student !=null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
                onEditingComplete: () {
                  // Save the updated name when editing is complete
                  _updateStudentName(_nameController.text);
                },
              ),
            ),
          if (_averageScore != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Average Score: ${_averageScore!.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(
            height: 300, // Provide a fixed height for the chart
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _reports.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No reports available. \nPlease add!', style: TextStyle(fontSize: 30),),
                    SizedBox(height: 20),

                  ],
                ),
              )
                  : LineChart(
                LineChartData(
                  minX: _getMinX(),
                  maxX: _getMaxX(),
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(show: _reports.isNotEmpty),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int index = value.toInt();
                        if(value >=0 && value< _reports.length){
                          return _reports[index]['title'] ?? '';
                        }
                        return '';
                      },
                      reservedSize: 22,
                      margin: 10,
                    ),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _prepareDataForChart(),
                      isCurved: false,
                      colors: [Color(0xFF245209)],
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                children: [
                  Expanded(
                    child: Text('Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToAddReportScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Add Report'),
                  ),
                ]

            ),
          ),
          Expanded(
            child:Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Background color of the box
                      borderRadius: BorderRadius.circular(8), // Rounded corners for the box
                    ),
                    margin: EdgeInsets.only(bottom: 8), // Margin between boxes
                    child: ListTile(
                      title: Text(_reports[index]['title'], style: TextStyle(fontSize: 24)),
                      subtitle: Text(_reports[index]['notes']),
                      trailing: Text(_reports[index]['score']?.toString() ?? '', style: TextStyle(fontSize: 30),),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}