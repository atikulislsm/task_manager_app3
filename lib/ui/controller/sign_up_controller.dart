import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class SignUpController extends GetxController{
  bool  _inprogress=false;
  bool get signUpProgress=> _inprogress;

  String? _errorMassage;
  String? get errorMassage=>_errorMassage;

  Future<bool> signUp(String email, String firstName, String lastName, String mobile, String password) async {
    bool isSuccess=false;
    _inprogress = true;
    update();
    Map<String, dynamic> reqBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: reqBody,
    );
    if (response.isSuccess) {
      isSuccess=true;
      Get.toNamed(SignInScreen.name);
    } else {
      _errorMassage=response.errorMassage;
    }
    _inprogress = false;
    update();
    return isSuccess;
  }

}