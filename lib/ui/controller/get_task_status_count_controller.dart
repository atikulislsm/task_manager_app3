import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_status_count_model.dart';
import 'package:task_manager_app/data/model/task_status_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class GetTaskStatusCountController extends GetxController{
  bool _taskListCountInprogress=false;
  bool get inprogress=> _taskListCountInprogress;

  String? _errorMassage;
  String? get errorMassage=>_errorMassage;

  List<TaskStatusModel> _taskStatusCountList=[];
  List<TaskStatusModel> get taskStatusCountList=> _taskStatusCountList;


  Future<bool> getTaskStatusCount() async{
    bool isSucess=false;
    _taskStatusCountList.clear();
    _taskListCountInprogress=true;
   update();
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.taskStatusCount);

    if(response.isSuccess){
      final TaskStatusCountModel taskStatusCountModel=TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList=taskStatusCountModel.taskStatusCountList?? [];
      isSucess=true;

    }else{
      _errorMassage=response.errorMassage;
    }
    _taskListCountInprogress=false;
    update();
    return isSucess;
  }
}