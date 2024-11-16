import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/controller/complete_task_list_controller.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

import '../../widget/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {

  final CompleteTaskListController _completeTaskListController=Get.find<CompleteTaskListController>();
  @override
  void initState() {
    super.initState();
    _getCompleteTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteTaskListController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.completeProgress,
          replacement: const CenterCircularProgressIndecator(),
          child: RefreshIndicator( onRefresh: () async{
            _getCompleteTaskList();
          },
          child: ListView.separated(
              itemBuilder: (context, index) {
                return TaskCard(
                   taskModel: controller.completeTaskList[index],
                  onReffressList:_getCompleteTaskList ,
                );
                  },
              separatorBuilder: (BuildContext context, index) {
                return const SizedBox(
                  height:   8,
                );
              },
              itemCount: controller.completeTaskList.length),
          )
        );
      }
    );
  }
  Future<void> _getCompleteTaskList() async{
    final bool result= await _completeTaskListController.getCompleteTaskListcontroller();
    if(result==false){
      showSnackBarMassage(context, _completeTaskListController.errorMassage!, true);
    }

  }
}
