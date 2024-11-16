import 'package:get/get.dart';
import 'package:task_manager_app/ui/controller/cancel_task_list_controller.dart';
import 'package:task_manager_app/ui/controller/complete_task_list_controller.dart';
import 'package:task_manager_app/ui/controller/get_task_status_count_controller.dart';
import 'package:task_manager_app/ui/controller/new_task_list_controller.dart';
import 'package:task_manager_app/ui/controller/progress_task_list_controller.dart';
import 'package:task_manager_app/ui/controller/sign_incontroller.dart';
import 'package:task_manager_app/ui/controller/sign_up_controller.dart';
import 'package:task_manager_app/ui/controller/update_profile_controller.dart';

class ControlBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(GetTaskStatusCountController());
    Get.put(CompleteTaskListController());
    Get.put(CancelTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(SignUpController());
    Get.put(UpdateProfileController());

  }
}