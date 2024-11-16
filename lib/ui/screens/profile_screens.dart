
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app/ui/controller/auth.dart';
import 'package:task_manager_app/ui/controller/update_profile_controller.dart';
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
  final UpdateProfileController updateProfileController=Get.find<UpdateProfileController>();

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
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.updateProfileInprogress==false ,
                      replacement: CenterCircularProgressIndecator() ,
                      child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _updateProfile();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  }
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
    final result=await updateProfileController.updateProfile(
        _emailTEController.text.trim(),
        _firstNameTEControoler.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
      _passwordTEController.text
    );
    if( result){
      showSnackBarMassage(context, 'Profile Updated');
    }else{
      showSnackBarMassage(context, updateProfileController.errorMassage!,true);
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
