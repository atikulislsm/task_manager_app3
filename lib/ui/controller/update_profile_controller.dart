import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/controller/auth.dart';

class UpdateProfileController extends GetxController{
  bool _inprogress=false;
  bool get updateProfileInprogress=>_inprogress;

  String? _errorMassage;
  String? get errorMassage=>_errorMassage;
  XFile? _selectedImage;

  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password)async{
    bool isSuccess=false;
    _inprogress=true;
    update();
    Map<String, dynamic> requestBody ={
      "email":email,
      "firstName":firstName,
      "lastName":lastName,
      "mobile":mobile,
    };
    if(password.isNotEmpty){
      requestBody['password']=password;
    }
    if(_selectedImage !=null){
      List<int> imageByte=await _selectedImage!.readAsBytes();
      String convertedImage=base64Encode(imageByte);
      requestBody['password']= convertedImage;
    }
    final NetworkResponse response=await NetworkCaller.postRequest(url: Urls.profileUpdate, body: requestBody);

    if(response.isSuccess){
      UserModel userModel=UserModel.fromJson(requestBody);
      AuthController.saveUserDate(userModel);
      isSuccess=true;
    }else{
      _errorMassage=response.errorMassage;
    }
    _inprogress=false;
    update();
    return isSuccess;
  }
}