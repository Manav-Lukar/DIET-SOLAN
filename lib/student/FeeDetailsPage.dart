import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeeDetailsPage extends StatefulWidget {
  @override
  _FeeDetailsPageState createState() => _FeeDetailsPageState();
}

class _FeeDetailsPageState extends State<FeeDetailsPage> {
  final Map<String, String> feeDetails = {
    'January': 'Paid',
    'February': 'Paid',
    'March': 'Unpaid',
    'April': 'Paid',
    'May': 'Unpaid',
    'June': 'Paid',
    'July': 'Paid',
    'August': 'Paid',
    'September': 'Unpaid',
    'October': 'Paid',
    'November': 'Unpaid',
    'December': 'Paid',
  };

  File? _paymentScreenshot;

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
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Payment Screenshot'),
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
              child: const Text('Paid'),
              onPressed: () {
                if (_paymentScreenshot != null) {
                  // Simulate payment success and update the fee details
                  Navigator.of(context).pop();
                  _showPaymentSuccessDialog(context, month);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please upload a payment screenshot.')),
                  );
                }
              },
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
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('You have successfully paid the fee for $month.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateFeeStatus(month);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Details'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff3498db),
                Color(0xff4a77f2),
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
              Color(0xff3498db),
              Color(0xff4a77f2),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: feeDetails.entries.map((entry) {
            return Card(
              color:
                  Colors.white.withOpacity(0.6), // Semi-transparent white color
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
