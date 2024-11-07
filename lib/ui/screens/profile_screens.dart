import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/controller/auth.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/tm_app_bar_widget.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  final TextEditingController _emailTEController=TextEditingController();
  final TextEditingController _firstNameTEControoler=TextEditingController();
  final TextEditingController _lastNameTEController=TextEditingController();
  final TextEditingController _mobileTEController=TextEditingController();
  final TextEditingController _passwordTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  bool _updateProfileInprogree=false;

  XFile? _selectedImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserDate();
  }
  void _setUserDate(){
    _emailTEController.text=AuthController.userData?.email??'';
    _firstNameTEControoler.text=AuthController.userData?.firstName??'';
    _lastNameTEController.text=AuthController.userData?.lastName??'';
    _mobileTEController.text=AuthController.userData?.mobile??'';

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(isProfileScreenOpen: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Update Profile',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                _buildPhotoPicker(),
                const SizedBox(height: 16),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameTEControoler,
                  decoration: const InputDecoration(hintText: 'First name'),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return 'Enter your First Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(hintText: 'Last name'),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return 'Enter your Last Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _mobileTEController,
                  decoration: const InputDecoration(hintText: 'Phone'),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return 'Enter your Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _updateProfileInprogree==false ,
                  replacement: CenterCircularProgressIndecator() ,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _updateProfile();
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile()async{
    _updateProfileInprogree=true;
    setState(() {
    });
    Map<String, dynamic> requestBody ={
        "email":_emailTEController.text.trim(),
        "firstName":_firstNameTEControoler.text.trim(),
        "lastName":_lastNameTEController.text.trim(),
        "mobile":_mobileTEController.text.trim(),
    };
    if(_passwordTEController.text.isNotEmpty){
      requestBody['password']=_passwordTEController.text;
    }
    if(_selectedImage !=null){
      List<int> imageByte=await _selectedImage!.readAsBytes();
      String convertedImage=base64Encode(imageByte);
      requestBody['password']= convertedImage;
    }
    final NetworkResponse response=await NetworkCaller.postRequest(url: Urls.profileUpdate, body: requestBody);
    _updateProfileInprogree=false;
    setState(() {
    });
    if(response.isSuccess){
      UserModel userModel=UserModel.fromJson(requestBody);
       AuthController.saveUserDate(userModel);
      showSnackBarMassage(context, 'Profile Updated');

    }else{
      showSnackBarMassage(context, 'Profile Updated');
    }
  }
  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: (){
        _pickImageFormGallay();
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text('Photo', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),),
            ),
            const SizedBox(width: 8),
             Text(_getSelectedPhotoTitle()),
          ],
        ),
      ),
    );
  }
  String _getSelectedPhotoTitle(){
    if(_selectedImage !=null){
      return _selectedImage!.name;
    }
    return 'Select photo';
  }

  Future<void> _pickImageFormGallay()async{
    ImagePicker _imagePicker=ImagePicker();
    XFile? pickImage=await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickImage !=null){
      _selectedImage=pickImage;
      setState(() {

      });
    }
  }
}
