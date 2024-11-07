import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _inprogree=false;
  List<TaskModel> _progressTaskList=[];
  @override
  void initState() {
    super.initState();
    _progressTaskStatusList();
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_inprogree,
      replacement: CircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async{
          _progressTaskStatusList();
        },
        child: ListView.separated(
            itemBuilder: (context, index) {
               return TaskCard(
                 taskModel:_progressTaskList[index] ,
               onReffressList: _progressTaskStatusList,
               );
            },
            separatorBuilder: (BuildContext context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: _progressTaskList.length),
      ),
    );
  }
  Future<void> _progressTaskStatusList () async{
    _progressTaskList.clear();
    _inprogree=true;
    setState(() {
    });
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.progressTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _progressTaskList=taskListModel.taskList??[];
    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _inprogree=false;
    setState(() {
    });
  }
}
