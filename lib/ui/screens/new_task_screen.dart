import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/model/task_status_count_model.dart';
import 'package:task_manager_app/data/model/task_status_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/task_card.dart';
import 'package:task_manager_app/widget/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}
class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  bool _inprogress=false;
  bool _taskListCountInprogress=false;
  List<TaskModel> _newTaskList=[];
  List<TaskStatusModel> _taskStatusCountList=[];

  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_inprogress,
                replacement: const CenterCircularProgressIndecator(),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: _newTaskList[index],
                        onReffressList: _getNewTaskList,
                      );
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: _newTaskList.length),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _floatingAdd();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: _taskListCountInprogress==false,
              replacement: CenterCircularProgressIndecator(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _getTaskSummaryCardList(),
                ),
              ),
            ),
          );
  }
  List<TaskSummaryCard> _getTaskSummaryCardList(){
    List<TaskSummaryCard> taskSummaryCardList=[];
      for(TaskStatusModel t in _taskStatusCountList){
        taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum! ?? 0));
      }
      return taskSummaryCardList;
  }

  Future<void> _floatingAdd() async {

    final bool? shouldRefresh= await  Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNewTaskScreen();
    }));
    if(shouldRefresh==true){
      _getNewTaskList();
    }
  }
  Future<void> _getNewTaskList() async{
    _newTaskList.clear();
    _inprogress=true;
    setState(() {
    });
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.newTaskList);

    if(response.isSuccess){
    final TaskListModel taskListModel=TaskListModel.fromJson(response.responseData);
    _newTaskList=taskListModel.taskList?? [];

    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _inprogress=false;
    setState(() {
    });
  }
  Future<void> _getTaskStatusCount() async{
    _taskStatusCountList.clear();
    _taskListCountInprogress=true;
    setState(() {
    });
    final NetworkResponse response=await NetworkCaller.getRequest(url: Urls.taskStatusCount);

    if(response.isSuccess){
    final TaskStatusCountModel taskStatusCountModel=TaskStatusCountModel.fromJson(response.responseData);
    _taskStatusCountList=taskStatusCountModel.taskStatusCountList?? [];

    }else{
      showSnackBarMassage(context, response.errorMassage, true);
    }
    _taskListCountInprogress=false;
    setState(() {
    });
  }
}


