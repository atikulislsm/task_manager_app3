import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_list_model.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/ui/controller/progress_task_list_controller.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskListController _progressTaskListController=Get.find<ProgressTaskListController>();

  @override
  void initState() {
    super.initState();
    _progressTaskStatusList();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressTaskListController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.progressInprogress,
          replacement: CircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async{
              _progressTaskStatusList();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                   return TaskCard(
                     taskModel:controller.progressTaskList[index] ,
                   onReffressList: _progressTaskStatusList,
                   );
                },
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemCount: controller.progressTaskList.length),
          ),
        );
      }
    );
  }
  Future<void> _progressTaskStatusList () async{
    final bool result=await _progressTaskListController.progressTaskStatusList();
    if(result==false){
      showSnackBarMassage(context, _progressTaskListController.errorMassage!, true);
    }
  }
}
