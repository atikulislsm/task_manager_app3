import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/tm_app_bar_widget.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final TextEditingController _titleTEController=TextEditingController();
  final TextEditingController _descriptionTEController=TextEditingController();
  bool _inprogres=false;
  bool _shouldRefress=false;
  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop,result){
        if(didpop){
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: const TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox( height: 42,),
                  Text('Add New Task', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold
                  )),
                  const SizedBox( height: 24,),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: InputDecoration(
                      hintText: 'Titile'
                    ),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return 'Enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox( height: 8,),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Desription',
                    ),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return 'Enter your Description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  Visibility(
                    visible: !_inprogres,
                    replacement: CenterCircularProgressIndecator(),
                    child: ElevatedButton(onPressed: (){
                      _onTapCreateButton();
                    }, child: const Icon(Icons.arrow_circle_right_outlined)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onTapCreateButton(){
    if(!_formKey.currentState!.validate()){
    }
    _createTask();
  }
  Future<void> _createTask() async{
    _inprogres=true;
    setState(() {
    });
    Map<String, dynamic> _recBody={
      "title":_titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status":"New"
    };

      final NetworkResponse response = await NetworkCaller.postRequest(
    url: Urls.taskCreate,
      body: _recBody,
    );
    _inprogres=false;
    setState(() {
    });
    if(response.isSuccess){
      _shouldRefress=true;
      _clearFildes();
      showSnackBarMassage(context, 'Add new task');
    }else{
      showSnackBarMassage(context, response.errorMassage,true);
    }
  }
  void _clearFildes(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
