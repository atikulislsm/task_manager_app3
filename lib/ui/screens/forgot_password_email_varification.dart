import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/screen_background.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  static TextEditingController _emailTEContoroller=TextEditingController();
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
                  Text('Your Email Address',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0,),
                  Text('A 6 digit verification otp will send to your email',
                      style: textTheme.titleSmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(
                    height: 24,
                  ),
                  builVeirfyEmailform(),
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

  Widget builVeirfyEmailform() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEContoroller,
            decoration: InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (String? value){
              if(value?.isEmpty??true){
                return 'Enter your Mail';
              }
              return null;
            },
          ),
          const SizedBox(height: 80.0,),
          ElevatedButton(
            onPressed: () {
              _onTapNextButton();
            },
            child: Icon(Icons.arrow_circle_right_outlined),
          ),
        ],
      ),
    );
  }
  void _onTapNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _forgoteEmail();
  }
  Future<void> _forgoteEmail() async{
    _inprogress=true;
    setState(() {
    });
    final String urlWithParams = '${Urls.forgotEmail}/${_emailTEContoroller.text.trim()}';
    final NetworkResponse response=await NetworkCaller.getRequest(url:urlWithParams);
    _inprogress=false;
    setState(() {
    });
    if(response.isSuccess){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ForgotPasswordOTPVerification(email: _emailTEContoroller.text.trim(),);
      }));
    }else{
     showSnackBarMassage(context, response.errorMassage, true);
    }
}
  void _onTapSignInButton(){
    Navigator.pop(context);
  }

}

