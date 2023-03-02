
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kronovo_app/pages/create_project/create_project.dart';
import 'package:kronovo_app/pages/project_details_page.dart';
import 'package:kronovo_app/responsive.dart';

import '../helpers/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _listProjects = [];
  int? id;
  List<String> _peoplesList = [];



  void getAllProjects() async {
    final data = await SQLHelper.getProjects();
    setState(() {
      _listProjects = data;
      String peoples = _listProjects[0]['project_assigned_peoples'].toString();
      _peoplesList = peoples.split(',');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getAllProjects();
      print('number of items ${_listProjects.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('Projects'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Create_Project(onSubmit: (String value){
                    null;
                  },)));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async{
            initState();
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
                child: ListView.builder(
                  itemCount: _listProjects.length,
                  itemBuilder: (context, index) => Container(
                    width: wp(20, context),
                    height: hp(20, context),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectDetailsPage(id :_listProjects[index]['project_id'])));
                      },
                      child: Card(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          width: wp(20, context),
                          height: hp(20, context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${_listProjects[index]['project_name']}',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month),
                                  Text('  ${_listProjects[index]['project_start_date']}'),

                                  Icon(Icons.task_alt_outlined),
                                  Text(' ${_listProjects[index]['project_end_date']}'),
                                ],
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                child: LinearProgressIndicator(
                                  value: 0.7,
                                  valueColor: AlwaysStoppedAnimation(Colors.green),
                                  minHeight: 10.0,
                                ),
                              ),
                              // Wrap(
                              //   children: _listProjects[index]['assigned_peoples'].split(",").toList()
                              //       .map<Widget>((e) {
                              //     Chip(
                              //       label: Text(
                              //         "${e.split(" ")[0][0]}${e.split(" ")[1][0]}",
                              //       ),
                              //       backgroundColor: Colors.green,
                              //     );
                              //   })
                              // ),
                              // Wrap(
                              //   children: List<Widget>.generate(_peoplesList.length, (int i) {
                              //     return Chip(
                              //       label: Text('${_peoplesList[i]}'),
                              //     );
                              //   }).toList(),
                              // ),
                              // Chip(
                              //   label: Text(''),
                              //   labelPadding: EdgeInsets.all(6),
                              //   avatar: CircleAvatar(
                              //     child: Text(' ${json.decode(_listProjects[index]['assigned_peoples'])} '
                              //         ),
                              //   ),
                              //   labelStyle: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${convertToAgo(DateTime.parse(_listProjects[index]['createdAt']))}',
                                    style: TextStyle(fontSize: 11.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago   ";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago   ";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago   ";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago   ";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago   ";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago   ";
    return "just now   ";
  }
}