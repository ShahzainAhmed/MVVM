import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/repository/auth_repository.dart';
import 'package:mvvm/resources/components/round_button.dart';
import 'package:mvvm/utils/routes/routes_names.dart';
import 'package:mvvm/view/home_screen.dart';
import 'package:mvvm/view/signup_screen.dart';
import 'package:mvvm/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> _obsecurePassword = ValueNotifier(true);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    _obsecurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocusNode,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  hintText: "shahzainahmed57@gmail.com",
                  labelText: "Email",
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                    context,
                    emailFocusNode,
                    passwordFocusNode,
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _obsecurePassword,
                builder: ((context, value, child) {
                  return TextFormField(
                    style: const TextStyle(fontSize: 20),
                    focusNode: passwordFocusNode,
                    obscureText: _obsecurePassword.value,
                    obscuringCharacter: "*",
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_clock_outlined),
                      suffixIcon: InkWell(
                        onTap: () {
                          _obsecurePassword.value = !_obsecurePassword.value;
                        },
                        child: Icon(
                          _obsecurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: height * 0.085),
              RoundButton(
                title: "Login",
                loading: authViewModel.loading,
                onPress: () {
                  if (_emailController.text.isEmpty) {
                    Utils.flushBarErrorMessages(
                        "Please enter your email", context);
                  } else if (_passwordController.text.isEmpty) {
                    Utils.flushBarErrorMessages(
                        "Please enter your password", context);
                  } else if (_passwordController.text.length < 6) {
                    Utils.flushBarErrorMessages(
                        "Please enter 6 digit password", context);
                  } else {
                    // Map data = {
                    //   'email': _emailController.text.toString(),
                    //   'password': _passwordController.text.toString(),
                    // };

                    Map data = {
                      'email': "eve.holt@reqres.in",
                      'password': 'cityslicka',
                    };
                    authViewModel.loginApi(data, context);
                    if (kDebugMode) {
                      print("API hit");
                    }
                  }
                },
              ),
              SizedBox(height: height * 0.03),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesNames.signUp);
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign up!",
                        style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          color: Colors.indigo,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
