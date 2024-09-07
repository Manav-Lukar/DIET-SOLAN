import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParentAddAndDeletePage extends StatefulWidget {
  @override
  _ParentAddAndDeletePageState createState() => _ParentAddAndDeletePageState();
}

class _ParentAddAndDeletePageState extends State<ParentAddAndDeletePage> {
  List<Map<String, dynamic>> parents = []; // Change to dynamic
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParents();
  }

  Future<void> fetchParents() async {
    final url = 'https://student-attendance-system-ckb1.onrender.com/api/parents/parents-information';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmYWN1bHR5SWQiOiI2NjdlNWYzNTBmMjZkYmFjYTU2MjZlZWEiLCJlbWFpbCI6InNodWJoYW01ODE4OEBnbWFpbC5jb20iLCJyb2xlIjoiQWRtaW4iLCJpYXQiOjE3MjQ4MjA0MTQsImV4cCI6MTcyNDkwNjgxNH0.eoV6nlJSL-DpWrrWvD9J4dnUTyjtLI85Us3oalfKB-8', // Use the correct authorization token
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          // Now use Map<String, dynamic> instead of Map<String, String>
          parents = data.map((parent) => {
            'name': parent['name'],
            'email': parent['email'],
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load parents');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 244, 248),
        title: const Text(
          'Manage Parents',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddParentDialog(),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                child: ListView.builder(
                  itemCount: parents.length,
                  itemBuilder: (context, index) {
                    final parent = parents[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(parent['name'] ?? 'No name'),
                        subtitle: Text(parent['email'] ?? 'No email'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this parent?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                parents.removeAt(index); // Remove the parent from the list
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddParentDialog extends StatefulWidget {
  @override
  _AddParentDialogState createState() => _AddParentDialogState();
}

class _AddParentDialogState extends State<AddParentDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Parent'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
