import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/forgot_password_email_varification.dart';
import 'package:task_manager_app/ui/screens/reset_password_screen.dart';
import 'package:task_manager_app/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class ForgotPasswordOTPVerification extends StatefulWidget {
  const ForgotPasswordOTPVerification({super.key, required this.email});
  final String email;

  @override
  State<ForgotPasswordOTPVerification> createState() => _ForgotPasswordOTPVerificationState();
}

class _ForgotPasswordOTPVerificationState extends State<ForgotPasswordOTPVerification> {
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final TextEditingController _getOTPTEController=TextEditingController();
  bool _inprogress=false;
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
                  Text('Pin Verification',
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0,),
                  Text('A 6 digit verification otp has been send to your email',
                      style: textTheme.titleSmall
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(
                    height: 24,
                  ),
                  builPinVerification(),
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

  Widget builPinVerification() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PinCodeTextField(
            controller: _getOTPTEController,
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
            ),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
           appContext: context,
            validator: (String? value){
              if(value?.isEmpty?? true){
                return 'Enter your OTP';
              }
              return null;
            },
          ),
          const SizedBox(height: 80.0,),
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
  void _onTapNextButton(){
    if(!_formKey.currentState!.validate()){
      return;
    }
    _otp();
  }
  Future<void> _otp() async{
    _inprogress=true;
    setState(() {
    });
    final String email=widget.email;
    final String urlsPath='${Urls.recoveryVerifyOtp}/${email}/${_getOTPTEController.text.trim()}';
    final NetworkResponse response= await NetworkCaller.getRequest(url: urlsPath);
    _inprogress=false;
    setState(() {
    });
    if(response.isSuccess){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ResetPasswordScreen(email: email,otp: int.parse(_getOTPTEController.text),); // ei kkhane otp ta int hoya ase
      }));
    }else{
      showSnackBarMassage(context, response.errorMassage,true);
    }
  }
  void _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
      return SignInScreen();
    }), (_) => false);


  }

}

