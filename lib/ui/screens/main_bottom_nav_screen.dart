import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/cancel_task_screen.dart';
import 'package:task_manager_app/ui/screens/complete_task_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_screen.dart';
import 'package:task_manager_app/ui/screens/progress_task_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/utils/assets_path.dart';
import 'package:task_manager_app/widget/tm_app_bar_widget.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

int _screenIndex = 0;
final List<Widget> _screens = [
  NewTaskScreen(),
  CompleteTaskScreen(),
  CancelTaskScreen(),
  ProgressTaskScreen()
];

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screens[_screenIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _screenIndex,
          onDestinationSelected: (int index) {
            _screenIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(
                icon: Icon(Icons.check_box), label: 'Completed'),
            NavigationDestination(
                icon: Icon(Icons.cancel_outlined), label: 'Canceled'),
            NavigationDestination(
                icon: Icon(Icons.access_time_outlined), label: 'Progress'),
          ]),
    );
  }

  
}


