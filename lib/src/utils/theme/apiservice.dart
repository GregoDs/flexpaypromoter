import 'dart:developer';
import 'package:flexpaypromoter/src/features/authentication/controllers/user_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class ApiService {
  final UserController userController = Get.find();

  Future<void> verifyToken() async {
    final url = Uri.parse('https://flexpay.co.ke/users/api/verify-token');
    final token = userController.getToken();

    if (token.isEmpty) {
      log('No token found. Please log in.');
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode == 200) {
        log('Token is valid.');
      } else {
        log('Token is invalid or expired. Logging out user.');
        userController.logoutUser(); // Clear token and log out user
        Get.offAllNamed('/login'); // Redirect to login
      }
    } catch (error) {
      log('Error verifying token: $error');
    }
  }
}


