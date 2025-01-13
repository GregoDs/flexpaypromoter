import 'package:get/get.dart';
// For making HTTP requests
// For JSON decoding



class UserController extends GetxController {
  var phoneNumber = ''.obs;
  var userId = ''.obs;
  var authToken = ''.obs; // Store the token
  var isLoggedIn = false.obs;
  var bookingReference = ''.obs;
  var bookingPrice = ''.obs;

  // Login function to save token and mark user as logged in
  void loginUser(String token) {
    authToken.value = token; // Save the token
    isLoggedIn.value = true; // Mark user as logged in
  }

  // Logout function to clear data
  void logoutUser() {
    authToken.value = '';
    isLoggedIn.value = false;
  }

  String getToken() {
    return authToken.value; // Return the token when needed
  }

   // Setter methods
  void setUserId(String id) {
    userId.value = id;
  }

  void setBookingReference(String reference) {
    bookingReference.value = reference;
  }

  void setBookingPrice(String price) {
    bookingPrice.value = price;
  }

  // Getter methods
  String getUserId() {
    return userId.value;
  }

  String getBookingReference() {
    return bookingReference.value;
  }

  String getBookingPrice() {
    return bookingPrice.value;
  }  
  
}
