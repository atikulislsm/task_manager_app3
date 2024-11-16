import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_app/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/screen_background.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String name='/resetPasswordScreen';
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email;
  final int otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final TextEditingController _passTEController=TextEditingController();
  final TextEditingController _confirmPassTEController=TextEditingController();
  bool _inprogress=true;
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
                  Text('Set Password',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0,),
                  Text('Minimum number of password should be 8 letters',
                      style: textTheme.titleSmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(
                    height: 24,
                  ),
                  builResetPassword(),
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
            text: "Alreday Have an Account? ",
            children: [
              TextSpan(
                  style: TextStyle(color: AppsColor.themecolor),
                  text: 'Sign In',
                recognizer: TapGestureRecognizer()..onTap=_onTapSignInButton

              )
            ]));
  }

  Widget builResetPassword() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passTEController,
            decoration: InputDecoration(hintText: 'Password'),
            keyboardType: TextInputType.text,
            validator: (String ? value){
              if(value?.isEmpty ?? true){
                return 'Enter a new password';
              }
              if(value!.length<8){
                return'Enter minimum 8 digit password';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0,),
          TextFormField(
            controller: _confirmPassTEController,
            decoration: InputDecoration(hintText: 'Confirm password'),
            keyboardType: TextInputType.text,
            validator: (String ? value){
              if(value?.isEmpty ?? true){
                return 'Enter a confirm password';
              }
              if(value!.length<8){
                return 'Enter minimum 8 digit password';
              }
              if(value!=_passTEController.text){
                return 'password do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 34.0,),
          ElevatedButton(
              onPressed: () {
                _onTapNextButton();
              },
              child: Icon(Icons.arrow_circle_right_outlined)),
        ],
      ),
    );
  }
  void _onTapNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _passwordReset();
  }
  Future<void> _passwordReset() async{
    _inprogress=true;
    setState(() {
    });
    final String email=widget.email;
    final int otp=widget.otp;
    Map<String, dynamic> _reqBody={
      "email":email,
      "OTP": otp.toString(), // ei jonno ei khane toStirng diye convert kore nite hobe
      "password":_passTEController.text
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: _reqBody,
    );
    _inprogress=false;
    setState(() {
    });
    if(response.isSuccess){
      Get.offAllNamed(SignInScreen.name);
    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }
  void _onTapSignInButton(){
    Get.offAllNamed(SignInScreen.name);
  }

}

