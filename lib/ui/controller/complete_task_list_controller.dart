import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';

class CompleteTaskListController extends GetxController{
  bool _inprogress=false;
  bool get completeProgress =>_inprogress;

  List<TaskModel> _completeTaskList=[];
  List<TaskModel> get completeTaskList=> _completeTaskList;

  String? _errorMassage;
  String? get errorMassage=>_errorMassage;

  Future<bool> getCompleteTaskListcontroller() async{
    bool isSucess=false;
    _completeTaskList.clear();
    _inprogress=true;
    update();
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.completedTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _completeTaskList=taskListModel.taskList??[];
      isSucess=true;
    }else{
      _errorMassage=response.errorMassage;
    }
    _inprogress=false;
    update();
    return isSucess;
  }
}