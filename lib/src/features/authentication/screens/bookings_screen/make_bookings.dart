import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON handling
import '../../controllers/user_controller.dart';

class MakeBookings extends StatefulWidget {
  const MakeBookings({super.key});

  @override
  _MakeBookingsState createState() => _MakeBookingsState();
}

class _MakeBookingsState extends State<MakeBookings> {
  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _productNameController = TextEditingController();
  final _paymentDurationController = TextEditingController();
  final _priceController = TextEditingController();
  final _initialDepositController = TextEditingController();

  final UserController userController = Get.find(); // Instantiate UserController
  late final String userId; // Declare userId

  bool isLoading = false; // To control the button loading state

  @override
  void initState() {
    super.initState();
    userId = userController.getUserId(); // Get the userId on initialization
  }

  // Dispose controllers to free up resources
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _productNameController.dispose();
    _paymentDurationController.dispose();
    _priceController.dispose();
    _initialDepositController.dispose();
    super.dispose();
  }

  Future<void> _createBooking() async {
    setState(() {
      isLoading = true; // Set loading to true when the button is pressed
    });

    final url = Uri.parse('https://bookings.flexpay.co.ke/api/booking/promoter-create');

    // Prepare the request body, including the userId
    final Map<String, dynamic> body = {
      'user_id': userId, // Include the user ID
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone_number': _phoneController.text,
      'product_name': _productNameController.text,
      'booking_days': int.tryParse(_paymentDurationController.text) ?? 0,
      'booking_price': double.tryParse(_priceController.text) ?? 0.0,
      'initial_deposit': double.tryParse(_initialDepositController.text) ?? 0.0,
    };

    try {
      // Send the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Handle the response
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Assuming the response contains bookingReference and bookingPrice
        String bookingReference = responseData['data']['product_booking']['booking_reference'] ?? '';
        String bookingPrice = responseData['data']['product_booking']['booking_price']?.toString() ?? '';

        // Update UserController with booking reference and price
        userController.setBookingReference(bookingReference);
        userController.setBookingPrice(bookingPrice);

        // Clear the input fields
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _productNameController.clear();
        _paymentDurationController.clear();
        _priceController.clear();
        _initialDepositController.clear();

        // Show success dialog box
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Booking Created Successfully!',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Your booking reference is $bookingReference, and the booking price is $bookingPrice.',
                style: GoogleFonts.montserrat(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Show success message
        Get.snackbar("Success", "Your booking has been created successfully.");
      } else {
        // Show error messages
        String errorMessage = "Booking failed: ";
        if (responseData['errors'] != null) {
          responseData['errors'].forEach((key, value) {
            errorMessage += '$key: ${value.join(', ')}; ';
          });
        }
        Get.snackbar("Error", errorMessage);
      }
    } catch (error) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after the request completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF337687),
        elevation: 0,
        toolbarHeight: 100.0,
        title: Text(
          "FlexPay",
          style: GoogleFonts.montserrat(
            fontSize: 33.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Phone Number Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Product Name Field
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Payment Duration Field (in days)
              TextFormField(
                controller: _paymentDurationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Payment Duration (in days)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Price Field
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Initial Deposit Field
              TextFormField(
                controller: _initialDepositController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Initial Deposit',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _createBooking(), // Disable button when loading
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white) // Show loading spinner
                      : Text('Create Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
