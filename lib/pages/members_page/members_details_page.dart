import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/members_page/update_members_page.dart';

import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';

class MembersDetailsPage extends StatefulWidget {
  const MembersDetailsPage({Key? key}) : super(key: key);

  @override
  State<MembersDetailsPage> createState() => _MembersDetailsPageState();
}

class _MembersDetailsPageState extends State<MembersDetailsPage> {


  String members_name = "";
  String members_number = "";
  String members_role = "";
  List<Map<String, dynamic>> _listMembers = [];
  bool _isChecked = false;
  int? mem_id;

  void _showMembers() async {
    final data = await SQLHelper.getMembers();

    setState(() {
      _listMembers = data;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showMembers();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KRONOVO"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            initState();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _listMembers.length,
              itemBuilder: (context, index) => Container(
                child: Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        autoClose: true,
                        onPressed: (value) {
                          SQLHelper.deleteMembers(
                              _listMembers[index]['members_id']);
                          setState(() {
                            _showMembers();
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
                                MaterialPageRoute(
                                    builder: (context) => UpdateMembersPage(
                                      id: _listMembers[index]
                                      ['members_id'],
                                    )
                                )
                            );
                          });
                        },
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 1.0),
                      padding: EdgeInsets.all(8.0),
                      height: hp(20, context),
                      width: wp(100, context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${_listMembers[index]['members_name']}',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.phone),
                          Text('  ${_listMembers[index]['members_phone']}' +
                              '    '),
                          Icon(Icons.people),
                          Text('  ${_listMembers[index]['members_role']}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
