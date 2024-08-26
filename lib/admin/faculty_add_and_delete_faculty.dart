import 'package:flutter/material.dart';

class Faculty {
  final String id;
  final String name;
  final String email;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
  });
}

class FacultyAddAndDeletePage extends StatefulWidget {
  const FacultyAddAndDeletePage({super.key});

  @override
  _FacultyAddAndDeletePageState createState() => _FacultyAddAndDeletePageState();
}

class _FacultyAddAndDeletePageState extends State<FacultyAddAndDeletePage> {
  List<Faculty> _faculties = [
    Faculty(id: '1', name: 'Dr. John Doe', email: 'john.doe@example.com'),
    Faculty(id: '2', name: 'Dr. Jane Smith', email: 'jane.smith@example.com'),
    // Add more faculty as needed
  ];

  void _addFaculty() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Faculty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final String name = nameController.text;
                final String email = emailController.text;

                setState(() {
                  _faculties.add(Faculty(
                    id: (_faculties.length + 1).toString(),
                    name: name,
                    email: email,
                  ));
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFaculty(String id) {
    setState(() {
      _faculties.removeWhere((faculty) => faculty.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: const Text(
          'Manage Faculties',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFE0F2F1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _addFaculty,
                child: const Text('Add New Faculty'),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _faculties.length,
                  itemBuilder: (context, index) {
                    final faculty = _faculties[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(faculty.name),
                        subtitle: Text(faculty.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteFaculty(faculty.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
