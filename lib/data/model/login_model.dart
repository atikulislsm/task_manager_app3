import 'package:task_manager_app/data/model/user_model.dart';

class LoginModel {
  String? status;
  UserModel? data;
  String? token;

  LoginModel({this.status, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
    token = json['token'];
  }
}




