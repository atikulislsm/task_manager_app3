import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/login_model.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/controller/auth.dart';

class SignInController extends GetxController{

  bool  _inprogress=false;
  bool get inprogress=> _inprogress;

  String? _errorMassege;
  String? get errorMassege=>_errorMassege;

  Future<bool> signIn( String email, String password) async{
    bool isSucess=false;
    _inprogress=true;
    update();
    Map<String, dynamic> _reqbody={
      "email": email,
      "password": password
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.signInUrl,
      body: _reqbody,
    );

    if(response.isSuccess){
      LoginModel loginModel=LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserDate(loginModel.data!);
      isSucess=true;
    }else{
      _errorMassege=response.errorMassage;
    }
    _inprogress=false;
    update();
    return isSucess;
  }

}