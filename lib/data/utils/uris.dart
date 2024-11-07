class Urls{
  static const String _baseUrl='http://35.73.30.144:2005/api/v1';
  static const String registrationUrl='$_baseUrl/Registration';
  static const String signInUrl='$_baseUrl/Login';
  static const String forgotEmail='$_baseUrl/RecoverVerifyEmail';
  static const String recoveryVerifyOtp='$_baseUrl/RecoverVerifyOtp';
  static const String recoverResetPassword='$_baseUrl/RecoverResetPassword';
  static const String taskCreate='$_baseUrl/createTask';
  static const String newTaskList='$_baseUrl/listTaskByStatus/New';
  static const String completedTaskList='$_baseUrl/listTaskByStatus/Completed';
  static const String cancelTaskList='$_baseUrl/listTaskByStatus/Cancel';
  static const String progressTaskList='$_baseUrl/listTaskByStatus/Progress';
  static const String taskStatusCount='$_baseUrl/taskStatusCount';
  static const String profileUpdate='$_baseUrl/ProfileUpdate';
  static String changeStatus(String taskID, String status) => '$_baseUrl/updateTaskStatus/$taskID/$status';
  static String deleteStatus(String taskID) => '$_baseUrl/deleteTask/$taskID';
}