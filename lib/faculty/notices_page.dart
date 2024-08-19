import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({
    super.key,
    required this.onMessagePublished,
    required this.notices, 
    required String token,
  });

  final Function(String) onMessagePublished;
  final List<String> notices;

  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _notices = [];

  @override
  void initState() {
    super.initState();
    _loadNotices(); // Load notices when the page initializes
  }

  Future<void> _loadNotices() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notices = prefs.getStringList('notices') ?? [];
    });
  }

  Future<void> _saveNotices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notices', _notices);
  }

  void _publishMessage() {
    String publishedMessage = _messageController.text.trim();
    if (publishedMessage.isEmpty) return;

    setState(() {
      _notices.add(publishedMessage);
    });
    _messageController.clear();
    _saveNotices(); // Save notices to shared preferences

    widget.onMessagePublished(publishedMessage);

    // Show a dialog to indicate the message was published
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Published'),
        content: Text('Published Message: $publishedMessage'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteNotice(int index) {
    setState(() {
      _notices.removeAt(index);
    });
    _saveNotices(); // Save updated notices to shared preferences
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff),
                Color(0xffcceeff),
              ],
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _notices.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        _notices[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteNotice(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 4,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Enter Message (Max 100 characters)',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _publishMessage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
