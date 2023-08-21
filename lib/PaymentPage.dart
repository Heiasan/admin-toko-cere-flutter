import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;

  PaymentPage({required this.totalAmount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isPaymentProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isPaymentProcessing = true;
    });

    try {
      final paymentResponse = await Dio().post(
        'http://your-api-url.com/api/process-payment',
        data: {
          'total_amount': widget.totalAmount,
          // Add other payment details here
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer your-access-token',
          },
        ),
      );

      if (paymentResponse.statusCode == 200) {
        // Payment successful, show success message
        print('Payment successful');
      } else {
        // Payment failed, show error message
        print('Payment failed');
      }
    } catch (error) {
      // Handle error
      print('Error processing payment: $error');
    }

    setState(() {
      _isPaymentProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: const Color(0xFF343A40),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPaymentProcessing ? null : _processPayment,
                child: _isPaymentProcessing
                    ? CircularProgressIndicator()
                    : Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
