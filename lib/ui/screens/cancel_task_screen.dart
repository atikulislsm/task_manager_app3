import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _inprogree=false;
  List<TaskModel> _cancelTaskList=[];
  @override
  void initState() {
    super.initState();
    _cancelTaskStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_inprogree,
      replacement: CircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async{
          _cancelTaskStatus();
        },
        child: ListView.separated(
              itemBuilder: (context, index) {
                 return TaskCard(
                   taskModel: _cancelTaskList[index],
                   onReffressList: _cancelTaskStatus,
                 );
              },
              separatorBuilder: (BuildContext context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemCount: _cancelTaskList.length,

        ),
      ),
    );
  }
  Future<void> _cancelTaskStatus() async{
    _cancelTaskList.clear();
    _inprogree=true;
    setState(() {
    });
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.cancelTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _cancelTaskList=taskListModel.taskList??[];
    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _inprogree=false;
    setState(() {
    });
  }
}
