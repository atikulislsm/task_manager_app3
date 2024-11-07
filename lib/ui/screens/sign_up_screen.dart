import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/screen_background.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailTEController = TextEditingController();
final TextEditingController _firstNameEController = TextEditingController();
final TextEditingController _lastNameEController = TextEditingController();
final TextEditingController _mobileEController = TextEditingController();
final TextEditingController _passwordEController = TextEditingController();
bool _inprogress = false;

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 90,
              ),
              Text('Join with us',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 24,
              ),
              buildSignUpform(),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Column(
                  children: [
                    buildSignInSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget buildSignInSection() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.75,
            ),
            text: "Already Have an Account?",
            children: [
          TextSpan(
              style: TextStyle(color: AppsColor.themecolor),
              text: 'Sign In',
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton)
        ]));
  }

  Widget buildSignUpform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            decoration: InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid mail';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _firstNameEController,
            decoration: InputDecoration(hintText: 'First Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid first name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _lastNameEController,
            decoration: InputDecoration(hintText: 'Last Name'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid last name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _mobileEController,
            decoration: InputDecoration(hintText: 'Mobile'),
            keyboardType: TextInputType.number,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid mobile';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: _passwordEController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter valid last name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !_inprogress,
            replacement: CenterCircularProgressIndecator(),
            child: ElevatedButton(
                onPressed: () {
                  _onTapNextButton();
                },
                child: Icon(Icons.arrow_circle_right_outlined)),
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _inprogress = true;
    setState(() {});
    Map<String, dynamic> reqBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameEController.text.trim(),
      "lastName": _lastNameEController.text,
      "mobile": _mobileEController.text.trim(),
      "password": _passwordEController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: reqBody,
    );
    _inprogress = false;
    setState(() {});
    if (response.isSuccess) {
      _clear();
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return SignInScreen();
      }));
      showSnackBarMassage(context, 'New User Created');
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }
  void _clear(){
    _emailTEController.clear();
    _firstNameEController.clear();
    _lastNameEController.clear();
    _mobileEController.clear();
    _passwordEController.clear();
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  // @override
  // void dispose() {
  //   _emailTEController.dispose();
  //   _firstNameEController.dispose();
  //   _lastNameEController.dispose();
  //   _mobileEController.dispose();
  //   _passwordEController.dispose();
  //   super.dispose();
  // }
}
