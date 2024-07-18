import 'package:flutter/material.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({Key? key, required this.onMessagePublished, required List notices})
      : super(key: key);

  final Function(String) onMessagePublished;

  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  TextEditingController _messageController = TextEditingController();

  void _publishMessage() {
    String publishedMessage = _messageController.text;
    _messageController.clear();

    // Pass published message to the callback function
    widget.onMessagePublished(publishedMessage);

    // Show a dialog or snackbar to indicate message published
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message Published'),
        content: Text('Published Message: $publishedMessage'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade500,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 100, 181, 246),
              Color.fromARGB(255, 100, 181, 246),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _messageController,
              maxLines: 4,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Enter Message (Max 100 words)',
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _publishMessage,
              child: const Text('Publish'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue.shade300,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
