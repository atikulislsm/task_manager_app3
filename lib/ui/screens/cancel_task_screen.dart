import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controller/cancel_task_list_controller.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';
import 'package:task_manager_app/widget/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  final CancelTaskListController _cancelTaskListController=Get.find<CancelTaskListController>();
  @override
  void initState() {
    super.initState();
    _cancelTaskStatus();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelTaskListController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.cancelTaskProgress,
          replacement: CircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async{
              _cancelTaskStatus();
            },
            child: ListView.separated(
                  itemBuilder: (context, index) {
                     return TaskCard(
                       taskModel: controller.cancelTaskList[index],
                       onReffressList: _cancelTaskStatus,
                     );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                  itemCount: controller.cancelTaskList.length,

            ),
          ),
        );
      }
    );
  }
  Future<void> _cancelTaskStatus() async{

    final bool result=await _cancelTaskListController.cancelTaskStatus();
    if(result==false){
    showSnackBarMassage(context, _cancelTaskListController.errorMassage!, true);
    }
  }
}
