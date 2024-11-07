import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/model/task_model.dart';
import 'package:task_manager_app/data/service/network_caller.dart';
import 'package:task_manager_app/data/utils/uris.dart';
import 'package:task_manager_app/utils/apps_color.dart';
import 'package:task_manager_app/widget/center_circular_progress_indecator.dart';
import 'package:task_manager_app/widget/snack_bar_massage.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel, required this.onReffressList
  });
  final TaskModel taskModel;
  final VoidCallback onReffressList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus='';
  bool _inprogress=false;
  bool _deleteInprogress=false;
  @override
  void initState() {

    super.initState();
    _selectedStatus=widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.taskModel.title}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16)),
            Text('${widget.taskModel.description}'),
            const SizedBox(height: 5,),
            Text('Date: ${widget.taskModel.createdDate ?? ''}'),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatuseChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: _inprogress==false,
                      replacement: const CenterCircularProgressIndecator(),
                      child: IconButton(
                        onPressed: () {
                          _onTapEditButton();
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: _deleteInprogress==false ,
                      replacement: CenterCircularProgressIndecator(),
                      child: IconButton(
                        onPressed: () {
                          _onTapDeleteButton();
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTaskStatuseChip() {
    return Chip(
                label: Text(widget.taskModel.status!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppsColor.themecolor),
                ),
              );
  }


  void _onTapEditButton(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['New', 'Completed','Cancel', 'Progress'].map((e){
            return ListTile(
              onTap: (){
                _changeStatus(e);
                Navigator.pop(context);
              },
              title: Text(e),
              selected: _selectedStatus==e,
              trailing: _selectedStatus==e ? const  Icon(Icons.check_box):null,
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel'))
        ],
      );
    });
  }
  Future<void> _onTapDeleteButton() async {
    _deleteInprogress=true;
    setState(() {
    });
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteStatus(widget.taskModel.sId!),
    );
    if(response.isSuccess){
      widget.onReffressList();
    }else{
      _deleteInprogress=false;
      setState(() {

      });
      showSnackBarMassage(context, response.errorMassage, true);
    }

  }
  Future<void> _changeStatus (String newStatus) async{
    _inprogress=true;
    setState(() {
    });
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.changeStatus(widget.taskModel.sId!, newStatus),
    );
    if(response.isSuccess){
      widget.onReffressList();
    }else{
      _inprogress=false;
      setState(() {

      });
      showSnackBarMassage(context, response.errorMassage, true);
    }
  }

}