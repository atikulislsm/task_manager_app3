import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/controller/auth.dart';
import 'package:task_manager_app/ui/screens/profile_screens.dart';
import 'package:task_manager_app/ui/screens/sign_in_screen.dart';
import 'package:task_manager_app/utils/apps_color.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.isProfileScreenOpen=false,
  });
final bool isProfileScreenOpen;
  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize =>const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.isProfileScreenOpen){
          return;
        }
        Navigator.push(context,MaterialPageRoute(builder: (context){
          return ProfileScreens();
        })
        );
      },
      child: AppBar(
        backgroundColor: AppsColor.themecolor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              foregroundColor: Colors.white,
              foregroundImage: AssetImage('assets/images/atik_5.jpg'),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () async{
                  await AuthController.clearUserData();
                 _logoutButton();
                },
                icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }
  void _logoutButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
      return SignInScreen();
    }), (value)=> false);
  }
}