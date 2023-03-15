import 'dart:async';
import 'dart:math';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kronovo_app/pages/navigation_drawer/drawer_header.dart';
import 'package:kronovo_app/pages/project_pages/create_project.dart';
import 'package:kronovo_app/pages/project_pages/update_project_page.dart';
import 'package:kronovo_app/pages/project_pages/project_details_page.dart';
import 'package:kronovo_app/utils/responsive.dart';
import 'package:kronovo_app/utils/theme.dart';
import '../databases/sql_helper.dart';
import 'members_page/add_members_page.dart';
import 'navigation_drawer/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> _listProjects = [];
  int? id;
  List<String> _peoplesList = [];
  late final item;
  int? project_id;
  List<Map<String, dynamic>> _listTasks = [];
  double project_progress = 0.0;
  int? task_id;
  DateTime _selectedDate = DateTime.now();



  void getAllProjects() async {
    final data = await SQLHelper.getProjects();
    setState(() {
      _listProjects = data;
      List.generate(_listProjects.length, (index) {
        String peoples = _listProjects[index]['project_assigned_peoples']
            .toString();
        _peoplesList = peoples.split(',');
        project_id = _listProjects[index]['project_id'];
      }
      );
    });
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        CreateProject()));
    if (!mounted) return;
    initState();
  }
  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade600,
    Colors.green.shade700,
    Colors.green.shade800,
  ];
  Random random = new Random();



  @override
  void initState() {
    super.initState();
    getAllProjects();
    //loadTasks(task_id!);
    print('number of items ${_listProjects.length}');
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Kronovo'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                _navigateforResult(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderDrawer(),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    if(scaffoldKey.currentState!.isDrawerOpen){
                      scaffoldKey.currentState!.closeDrawer();
                      //close drawer, if drawer is open
                    }else{
                      scaffoldKey.currentState!.openDrawer();
                      //open drawer, if drawer is closed
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text(
                    "Members",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMembersPage(),));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          initState();
        },

        child:  Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0, top: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle,),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0,left: 20.0),
                    child: DatePicker(
                      DateTime.now(),
                      height: 100.0,
                      width: 80.0,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: primarygreen,
                      selectedTextColor: white,
                      dateTextStyle: GoogleFonts.lato(
                       textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                        ),
                      ),
                      dayTextStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                        ),
                      ),
                      monthTextStyle: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                        ),
                      ),
                      onDateChange: (date){
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                itemCount: _listProjects.length,
                itemBuilder: (context, index) => _listProjects[index]['project_start_date'] == _selectedDate.toString().split(' ')[0] ?  Container(
                  margin: EdgeInsets.only(left: 10, right: 10.0, top: 5.0),
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              autoClose: true,
                              onPressed: (value) {
                                SQLHelper.deleteProject(
                                    _listProjects[index]['project_id']);
                                setState(() {
                                  getAllProjects();
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              autoClose: true,
                              flex: 1,
                              onPressed: (value) {
                                //_listProjects.removeAt(index);
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          UpdateProject(
                                            id: _listProjects[index]['project_id'],
                                            onSubmit: (String value) {
                                              null;
                                            },)));
                                });
                              },
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectDetailsPage(
                                            id: _listProjects[index]['project_id'])));
                          },

                          child: Card(
                            color: colors[random.nextInt(4)],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_listProjects[index]['project_name']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Start Date:  ${_listProjects[index]['project_start_date']}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      Text(
                                        'End Date:  ${_listProjects[index]['project_end_date']}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        child: LinearProgressIndicator(
                                          value: _listProjects[index]['project_progress'] /
                                              _listProjects.length,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor: Colors.green.shade100,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(
                                              '${(_listProjects[index]['project_progress'] /
                                                  _listProjects.length * 100).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${convertToAgo(DateTime.parse(
                                            _listProjects[index]['createdAt']))}',
                                        style: TextStyle(fontSize: 12.0, color: Colors.white),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                    )
              ) : Container(),
            ),
            )
          ],
        )
      ),
    );
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1
          ? "year"
          : "years"} ago   ";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1
          ? "month"
          : "months"} ago   ";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1
          ? "week"
          : "weeks"} ago   ";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago   ";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago   ";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1
          ? "minute"
          : "minutes"} ago   ";
    return "just now   ";
  }
}
