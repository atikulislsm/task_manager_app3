import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';

class ProgressTaskListController extends GetxController{
  bool _inprogress=false;
  bool get progressInprogress=>_inprogress;

  String? _errorMassage;
  String? get errorMassage=>_errorMassage;

  List<TaskModel> _progressTaskList=[];
  List<TaskModel> get progressTaskList=>_progressTaskList;

  Future<bool> progressTaskStatusList () async{
    bool isSuccess=false;
    _progressTaskList.clear();
    _inprogress=true;
    update();
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.progressTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _progressTaskList=taskListModel.taskList??[];
      isSuccess=true;
    }else{
      _errorMassage=response.errorMassage;
    }
    _inprogress=false;
    update();
    return isSuccess;
  }
}