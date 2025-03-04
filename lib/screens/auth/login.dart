import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/screens/main/home.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loginState = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _name = '';
  String _email = '';
  String _password = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final user = await Provider.of<UserProvider>(context, listen: false)
          .login(_email, _password);

      if (user == null) {
        ScaffoldMessengerService.instance.displayError('error logging in');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      NavigationService.instance.pushAndReplaceAll(const Home());
    } catch (ex) {
      ScaffoldMessengerService.instance.displayError(ex.toString());
    }
  }

  Future<void> _register() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final user = await Provider.of<UserProvider>(context, listen: false)
          .register(_name, _email, _password);

      if (user == null) {
        ScaffoldMessengerService.instance.displayError('error signing up');
        return;
      }

      NavigationService.instance.pushAndReplaceAll(const Home());
    } catch (ex) {
      ScaffoldMessengerService.instance.displayError(ex.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  const Text(
                    'CALORIES',
                    style: TextStyles.white20Bold,
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Visibility(
                    visible: !_loginState,
                    child: CustomTextField(
                      controller: _nameController,
                      label: 'name',
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    label: 'email',
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'password',
                    obscureText: true,
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  CustomOutlinedButton(
                    onPressed: () {
                      _loginState ? _login() : _register();
                    },
                    child: Text(
                      _loginState ? 'login' : 'sign up',
                      style: TextStyles.white15Medium,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _loginState = !_loginState;
                      });
                    },
                    child: Text(
                      'switch to ${_loginState ? 'sign up' : 'login'}',
                      style: TextStyles.white15Medium,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
