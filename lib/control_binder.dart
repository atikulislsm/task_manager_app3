import 'package:get/get.dart';
import 'package:task_manager_app/ui/controller/get_task_status_count_controller.dart';
import 'package:task_manager_app/ui/controller/new_task_list_controller.dart';
import 'package:task_manager_app/ui/controller/sign_incontroller.dart';

class ControlBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(GetTaskStatusCountController());

  }
}