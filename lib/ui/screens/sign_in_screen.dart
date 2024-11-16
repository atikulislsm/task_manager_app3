import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app/ui/screens/forgot_password_email_varification.dart';
import 'package:task_manager_app/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/screen_background.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/ui/controller/sign_incontroller.dart';

class SignInScreen extends StatefulWidget {
  static const String name='/signIn';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  final TextEditingController _emailTEController=TextEditingController();
  final TextEditingController _passwordTEController=TextEditingController();
  final SignInController signInController=Get.find<SignInController>();
  bool _inprogrees=false;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Text('Get Started With',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 24,
              ),
              buildSignInform(),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        _onTapForgotPassword();
                      },
                      child: Text('Forgot Password'),
                    ),
                    buildSignUpSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget buildSignInform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            controller: _emailTEController,
            decoration: InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (String ? value){
              if(value?.isEmpty??true){
                return 'Enter your mail';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            controller: _passwordTEController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (String ? value){
              if(value?.isEmpty ?? true){
                return 'Enter your password';
              }
              if(value!.length<3){
                return 'Enter a password 3 digit';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<SignInController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inprogress,
                replacement: CenterCircularProgressIndecator(),
                child: ElevatedButton(
                    onPressed: () {
                      _onTapNextButton();
                    },
                    child: Icon(Icons.arrow_circle_right_outlined)),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget buildSignUpSection() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.75,
            ),
            text: "Don't have account?",
            children: [
          TextSpan(
            style: const TextStyle(color: AppsColor.themecolor),
            text: 'Sign up',
            recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
          )
        ]));
  }

  void _onTapNextButton() {
    if(!_formKey.currentState!.validate()){
      return;
    }
    _signIn();
  }
  Future<void> _signIn() async{
    final bool result=await signInController.signIn(_emailTEController.text.trim(), _passwordTEController.text);

    if(result){
      Get.offAllNamed(MainBottomNavScreen.name);
    }else{
      showSnackBarMassage(context, signInController.errorMassege!,true);

    }
  }
  void _onTapForgotPassword() {
    Get.toNamed(EmailVerification.name);
  }

  void _onTapSignUp() {
    Get.toNamed(SignUpScreen.name);
  }
}
