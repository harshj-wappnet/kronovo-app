import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/members_page/add_members_page.dart';
import 'package:kronovo_app/pages/members_page/update_members_page.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../widgets/confirmation_dialog.dart';

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
  int? mem_id;

  // this method is used for fetch all members records for displaying in list
  void _showMembers() async {
    final data = await SQLHelper.getMembers();
    setState(() {
      _listMembers = data;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMembers();
    });
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddMembersPage()));
    if (!mounted) return;
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Members Details",
          style: TextStyle(fontFamily: 'lato'),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
              icon: Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            initState();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _listMembers.isNotEmpty
                ? ListView.builder(
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                      title: 'Delete Member',
                                      content:
                                          'Are you sure you want to delete this Member ?',
                                      onConfirm: () {
                                        // used to delete member
                                        SQLHelper.deleteMembers(
                                            _listMembers[index]['members_id']);
                                        setState(() {
                                          _showMembers();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
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
                                          builder: (context) =>
                                              UpdateMembersPage(
                                                id: _listMembers[index]
                                                    ['members_id'],
                                              )));
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
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'lato'),
                                ),
                                Icon(Icons.phone),
                                Text(
                                  '  ${_listMembers[index]['members_phone']}' +
                                      '    ',
                                  style: TextStyle(fontFamily: 'lato'),
                                ),
                                Icon(Icons.people),
                                Text(
                                  '  ${_listMembers[index]['members_role']}',
                                  style: TextStyle(fontFamily: 'lato'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: hp(30, context)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset("assets/images/add_peoples.png",
                              height: 120, width: 120),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "NO MEMBERS",
                          style: TextStyle(fontFamily: 'lato'),
                        ),
                        Text(
                          "Click On + to add Members",
                          style: TextStyle(fontFamily: 'lato'),
                        ),
                      ],
                    ),
                  ),
          )),
    );
  }
}
