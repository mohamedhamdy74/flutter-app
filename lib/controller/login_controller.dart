import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:routing/api/api-client.dart';
import 'package:routing/api/constant-urls.dart';
import 'package:routing/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final formKey = GlobalKey<FormBuilderState>();
  final usernmaeController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false;
  // يمكنك إضافة userModel هنا إذا كان لديك موديل مستخدم

  @override
  void onInit() {
    // أي إعدادات أو تحميل بيانات أولية
    super.onInit();
  }

  void login() async {
    print('login called');
    print(
      'username: ${usernmaeController.text}, password: ${passwordController.text}',
    );
    Get.snackbar('Debug', 'login called: ${usernmaeController.text}');
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading = true;
      update();
      try {
        var response = await _apiClient.postData(BaseUrls.authUrl, {
          "username": usernmaeController.text,
          "password": passwordController.text,
        });
        print('API response: ${response.statusCode}');
        if (response.statusCode == 200) {
          // حفظ التوكن في SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = response.data['accessToken'] ?? '';
          await prefs.setString('token', token);
          Get.snackbar('Login', 'Success!');
          Get.offAll(() => Home());
        } else {
          Get.snackbar('Login Failed', 'Invalid username or password');
        }
      } catch (e) {
        Get.snackbar('Error', 'Error occurred: $e');
      } finally {
        isLoading = false;
        update();
      }
    } else {
      print('Form not valid');
      Get.snackbar('Error', 'Form not valid');
    }
  }

  @override
  void dispose() {
    usernmaeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update(ids, condition);
  }
}
