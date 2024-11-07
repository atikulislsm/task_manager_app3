import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

import '../../widget/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _inprogess=false;
  List<TaskModel> _completeTaskList=[];
  @override
  void initState() {
    super.initState();
    _getCompleteTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_inprogess,
      replacement: const CenterCircularProgressIndecator(),
      child: RefreshIndicator( onRefresh: () async{
        _getCompleteTaskList();
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            return TaskCard(
               taskModel: _completeTaskList[index],
              onReffressList:_getCompleteTaskList ,
            );
              },
          separatorBuilder: (BuildContext context, index) {
            return const SizedBox(
              height:   8,
            );
          },
          itemCount: _completeTaskList.length),
      )
    );
  }
  Future<void> _getCompleteTaskList() async{
    _completeTaskList.clear();
    _inprogess=true;
    setState(() {
    });
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.completedTaskList);
    if(response.isSuccess){
      final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
      _completeTaskList=taskListModel.taskList??[];
    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _inprogess=false;
    setState(() {
    });
  }
}
