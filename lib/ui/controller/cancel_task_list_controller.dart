import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';

class CancelTaskListController extends GetxController{
  bool _inProgress=false;
  bool get cancelTaskProgress=>_inProgress;
  String? _errorMassage;
  String? get errorMassage=> errorMassage;

  List<TaskModel> _cancelTaskList=[];
  List<TaskModel> get cancelTaskList=> _cancelTaskList;

  Future<bool> cancelTaskStatus() async{
    bool isScuccess=false;
    _cancelTaskList.clear();
    _inProgress=true;
    update();
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.cancelTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _cancelTaskList=taskListModel.taskList??[];
      isScuccess=true;
    }else{
     _errorMassage=response.errorMassage;
    }
    _inProgress=false;
    update();
    return isScuccess;
  }
}