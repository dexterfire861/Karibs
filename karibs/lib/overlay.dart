import 'package:flutter/material.dart';

class MainTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to KLAS'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'This is a tutorial to guide you through the app features. \n\n You can view these '
                'instructions again at any time by clicking the question mark icon at the top right corner of every page.',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Text(
            '1. Choose your user type by tapping on either "I\'m a Teacher" or "I\'m a Student".',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class TeacherDashboardTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Teacher Dashboard'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This screen allows you to view all of your classes, add new ones, and manage your exams.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Add a class by clicking on the Add Class button at the bottom of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\n a. Select a desired class and subject from the dropdown, or create your own name by clicking on the + icon on the right.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '\n b. Click the Add button to add your class to the dashboard.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To view your classes, click inside the rectangle with your class name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To edit your class name, click on the pencil icon next to the class name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. To delete a class, click on the trash bin icon next to the class name. '
                    'You will see a confirmation message asking if you want to delete the class.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '5. To view or create your exams, click on the Manage Exams button at the bottom of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class TeacherClassScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Class Viewing Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This screen allows you to view all of your students for a given class,'
                    'search and filter for specific students, add new students, and create a PDF document for an entire class.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Add a student by clicking on the Add Student button in the bottom left corner of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\n a. Type in your student’s name and click the add button to add your student to the class.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '\n b. You should now be able to view your students, their average score, and '
                          'status in the circle to the left of the student’s name.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To view a student, click inside the rectangle with your student’s name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To search for a student by name, click on the search bar at the '
                    'top of the screen and type the desired student’s name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. To filter the students by their status, click on the funnel '
                    'icon at the top left of the screen next to the search bar.',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\n a. You should now be able to view all the students with the selected status',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '5. To sort the students alphabetically or by their average score, click on the gear '
                    'icon at the top right of the screen next to the search bar.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '6. To save or print a PDF document of all of your students within your class, '
                    'click on the PDF button at the bottom right of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class StudentInfoScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Student Information Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This screen allows you to view all of the previous reports for a '
                    'student and track their progress throughout many terms',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. To add a custom report to your student, click on the Add '
                    'Report button at the middle right area of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To view a report, click inside the rectangle with the given report’s name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To save or print a PDF of the individual student, click on the'
                    ' PDF button at the center right of the screen',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. To edit a student’s name, delete a student, or delete reports, '
                    'click on the Edit button at the top right of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class AddReportScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Add Report Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '1. You are able to type in a title for your report, any notes '
                    'you would like to write, and the option to add a score to your report.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. Once this information is filled in, click on the Add button to'
                    ' save the report to your student.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. You should now be able to view a list of the student’s reports '
                    'and see their progress displayed on the graph at the top of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class EditStudentScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Edit Student Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '1. To edit a student’s name, select the Student Name text box at '
                    'the top of the screen and type in your desired name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To delete a report, click on the Trash Bin icon to the right'
                    'of a given report, or swipe all the way to the left on a given report.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To delete a student, click on the Trash Bin icon at the top '
                    'right of the screen. You will see a confirmation message asking '
                    'if you want to delete the student.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. To save your edited changes to the student, click on the square'
                    ' icon in the top right corner of the screen next to the trash bin.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class ReportDetailsScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Report Detail Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This screen allows you to view the grade that your student has '
                    'received for a given report. You can see the total grade as '
                    'well as various categories for an exam.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. To edit the title, notes, or score for a given report, click '
                    'on the Edit Report button at the top right of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To view the correct and incorrect answers from the graded exam, '
                    'click on the View Test Grade button at the bottom of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class EditReportScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Edit Report Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '1. The title, notes, and score of the report can be changed here.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To save your changes, click the Save Changes button.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To delete a report, select the trash bin icon at the top right '
                    'of the screen. You will see a confirmation message asking if '
                    'you want to delete the report.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}

class TestsScreenTutorialDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome to the Exam Viewing Screen'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This screen allows you to view all of your exams created within '
                    'the app. You can create, edit, and delete exams here.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. To add a new exam, click on the Add Exam button at the bottom of the screen.',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\n a. To name your exam, start typing in the Exam Title box.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '\n b. To select a subject for the exam, select from the dropdown '
                          'menu or create a custom subject name by clicking on the '
                          '+ icon next to the subject dropdown.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '\n c. Click the Add button to successfully create the new exam.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. To view an exam and add questions, click inside the rectangle '
                    'with the desired exam name.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. To edit the name or subject of an already created exam, click '
                    'on the pencil icon to the right side of the desired exam.',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\n a. Here you can rename your exam, select a different '
                          'subject from the dropdown, or create a new subject name for your exam.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      '\n b. Click on the Save button to save your new changes.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. To delete an exam, click on the trash bin icon on the right side of the desired exam. '
                    'You will see a confirmation message asking if you want to delete the exam.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Got it'),
        ),
      ],
    );
  }
}