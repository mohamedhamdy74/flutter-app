import 'package:routing/api/api-client.dart';
import 'package:routing/api/constant-urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:routing/models/user-model.dart';

class AuthServices {
  ApiClient _apiClient = ApiClient();

  Future<AuthModel?> login(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await _apiClient.postData(BaseUrls.authUrl, {
        "username": email,
        "password": password,
      });
      if (response.statusCode == 200 && response.data != null) {
        AuthModel authModel = authModelFromJson(response.data);
        await prefs.setString('accessToken', authModel.accessToken);
        return authModel;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
