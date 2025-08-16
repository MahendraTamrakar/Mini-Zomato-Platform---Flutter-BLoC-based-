import 'package:mini_zomato_platform/models/user_model.dart';

class AuthRepository {
  // Mock implementation - replace with actual API calls
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Mock validation
    if (email == "user@example.com" && password == "password") {
      return UserModel(
        id: "1",
        name: "John Doe",
        email: email,
        phoneNumber: "+1234567890",
        profilePictureUrl:
            "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
      );
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<UserModel> signup(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    await Future.delayed(Duration(seconds: 2));

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePictureUrl: "https://example.com/profile.jpg",
    );
  }

  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
    // Clear local storage, tokens, etc.
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(Duration(seconds: 1));
    // Check if user is logged in from local storage
    return null; // Return null if no user is logged in
  }
}
