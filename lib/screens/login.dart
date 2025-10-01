import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:routing/screens/register.dart';
import 'package:routing/controller/login_controller.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  // لم يعد هناك حاجة لـ _formKey هنا، سيتم استخدام formKey من الكنترولر

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.ac_unit_outlined,
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 50.0,
                  ),
                  child: FormBuilder(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FormBuilderTextField(
                          name: 'userName',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          decoration: InputDecoration(
                            labelText: 'User name',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Enter your user name",
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.deepOrange,
                            focusColor: Colors.deepOrange,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.deepOrange),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'password',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(6),
                          ]),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Enter your password",
                            prefixIcon: Icon(Icons.lock),
                            prefixIconColor: Colors.deepOrange,
                            focusColor: Colors.deepOrange,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.deepOrange),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          obscureText: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password ?",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    if (controller.formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      controller.usernmaeController.text =
                                          controller
                                              .formKey
                                              .currentState
                                              ?.value['userName'] ??
                                          '';
                                      controller.passwordController.text =
                                          controller
                                              .formKey
                                              .currentState
                                              ?.value['password'] ??
                                          '';
                                      controller.login();
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Please fill all fields correctly',
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 15,
                              ),
                            ),
                            child: controller.isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?"),
                    TextButton(
                      onPressed: () {
                        Get.to(() => Register());
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
