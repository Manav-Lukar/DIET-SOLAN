import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeeDetailsPage extends StatefulWidget {
  final String username;

  const FeeDetailsPage({super.key, required this.username, required Map<String, dynamic> studentDetails, required studentName, required String rollNo});

  @override
  _FeeDetailsPageState createState() => _FeeDetailsPageState();
}

class _FeeDetailsPageState extends State<FeeDetailsPage>
    with SingleTickerProviderStateMixin {
  final Map<String, String> feeDetails = {
    'January': 'Paid',
    'February': 'Paid',
    'March': 'Unpaid',
    'April': 'Paid',
    'May': 'Unpaid',
    'June': 'Unpaid',
    'July': 'Unpaid',
    'August': 'Unpaid',
    'September': 'Unpaid',
    'October': 'Paid',
    'November': 'Unpaid',
    'December': 'Paid',
  };

  File? _paymentScreenshot;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _updateFeeStatus(String month) {
    setState(() {
      feeDetails[month] = 'Paid';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _paymentScreenshot = File(pickedFile.path);
      });
    }
  }

  void _showPaymentDialog(BuildContext context, String month) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay Fee for $month'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('To pay the fee, please scan the QR code below.'),
              const SizedBox(height: 16.0),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.asset(
                  'assets/qr.jpeg',
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16.0),
              _paymentScreenshot != null
                  ? Image.file(
                      _paymentScreenshot!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _animationController?.forward().then((_) {
                  Navigator.of(context).pop();
                  _showPaymentSuccessDialog(context, month);
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Paid'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, String month) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circle background
                Container(
                  width: 120,
                  height: 120,
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                ),
                // Checkmark icon with animation
                ScaleTransition(
                  scale: _scaleAnimation!,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: const Icon(
                      Icons.check,
                      size: 80,
                      color: Color.fromARGB(255, 237, 234, 234),
                    ),
                  ),
                ),
                // Success text
                Positioned(
                  bottom: 10,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: const Text(
                      'Payment Successful',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _updateFeeStatus(month);
      _animationController?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fee Details',
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffe6f7ff), // Deep blue for consistency
                Color(0xffe6f7ff), // Light blue for consistency
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe6f7ff),
              Color(0xffcceeff),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: feeDetails.entries.map((entry) {
            return Card(
              color: Colors.white.withOpacity(0.8),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                trailing: Text(
                  entry.value,
                  style: TextStyle(
                    color: entry.value == 'Paid' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (entry.value == 'Unpaid') {
                    _showPaymentDialog(context, entry.key);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
