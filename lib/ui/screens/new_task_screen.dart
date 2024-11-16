import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app/data/model/task_status_model.dart';
import 'package:task_manager_app/ui/controller/get_task_status_count_controller.dart';
import 'package:task_manager_app/ui/controller/new_task_list_controller.dart';
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

  final NewTaskListController _newTaskListController=Get.find<NewTaskListController>();
  final GetTaskStatusCountController _getTaskStatusCountController=Get.find<GetTaskStatusCountController>();

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
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inprogress,
                    replacement: const CenterCircularProgressIndecator(),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: controller.taskList[index],
                            onReffressList: _getNewTaskList,
                          );
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                        itemCount: controller.taskList.length),
                  );
                }
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
            child: GetBuilder<GetTaskStatusCountController>(
              builder: (controller) {
                return Visibility(
                  visible: !controller.inprogress,
                  replacement: CenterCircularProgressIndecator(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getTaskSummaryCardList(),
                    ),
                  ),
                );
              }
            ),
          );
  }
  List<TaskSummaryCard> _getTaskSummaryCardList(){
    List<TaskSummaryCard> taskSummaryCardList=[];
      for(TaskStatusModel t in _getTaskStatusCountController.taskStatusCountList){
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
    final bool result=await _newTaskListController.getNewTaskList();
    if(result==false){
      showSnackBarMassage(context, _newTaskListController.errorMassage!, true);
    }
  }
  Future<void> _getTaskStatusCount() async {
    final bool result = await _getTaskStatusCountController
        .getTaskStatusCount();

    if (result == false) {
      showSnackBarMassage(
          context, _getTaskStatusCountController.errorMassage!, true);
    }
  }
}


