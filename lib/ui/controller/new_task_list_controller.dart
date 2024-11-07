import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/task_card.dart';

class NewTaskListController extends GetxController{
  bool _inprogress=false;
  String? _errorMassage;
  bool get inprogress=>_inprogress;
  String? get errorMassage=>_errorMassage;
  List<TaskModel> _taskList=[];
  List<TaskModel> get taskList=>_taskList;

  Future<bool> getNewTaskList() async{
    bool isSuccess=false;
    _taskList.clear();
    _inprogress=true;
    update();
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.newTaskList);

    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _taskList=taskListModel.taskList?? [];
      isSuccess=true;

    }else{
      _errorMassage=response.errorMassage;
    }
    _inprogress=false;
    update();
    return isSuccess;
  }
}