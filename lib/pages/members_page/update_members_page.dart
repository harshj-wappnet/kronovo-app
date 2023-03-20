import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

class UpdateMembersPage extends StatefulWidget {
  const UpdateMembersPage({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<UpdateMembersPage> createState() => _UpdateMembersPageState();
}

class _UpdateMembersPageState extends State<UpdateMembersPage> {


  final _formKey_update_members = GlobalKey<FormState>();
  late final ValueChanged<String> onSubmit;
  List<Map<String, dynamic>> _listProjects = [];

  List<String> _peoplesList = [];
  List<String> _selectedItems = [];
  final TextEditingController update_member_role = TextEditingController();
  final update_member_name_Controller = TextEditingController();
  final update_member_number_Controller = TextEditingController();

  void getMembersData(int id) async {
    final data = await SQLHelper.getMembers();
    setState(() {
      _listProjects = data;
      if (id != null) {
        final existingList =
        _listProjects.firstWhere((element) => element['members_id'] == id);
        update_member_name_Controller.text = existingList['members_name'];
        update_member_number_Controller.text = existingList['members_phone'];
        update_member_role.text = existingList['members_role'];
      }
    });
  }


  void initState() {
    super.initState();
    getMembersData(widget.id);
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        Text('All Fields are requiered',
          style: TextStyle(color: Color(0xFFff4667),fontFamily: 'lato'),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  final phonesnackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        Text('Enter Valid Phone No.',
          style: TextStyle(color: Color(0xFFff4667), fontFamily: 'lato'),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text("Update Members", style: TextStyle(fontFamily: 'lato'),),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.0,),
                  Form(
                    key: _formKey_update_members,
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: update_member_name_Controller,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Name",
                                          hintStyle: subtitleStyle,
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0))),
                                      onChanged: (_) => setState(() {}),
                                    )
                                ),
                              ]),
                            ),
                            SizedBox(height: 15.0,),

                            Text(
                              "Mobile No.",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.grey[700],
                                      controller: update_member_number_Controller,
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')),
                                        // for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Mobile No.",
                                          hintStyle: subtitleStyle,
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0))),
                                      onChanged: (_) => setState(() {}),
                                    )
                                ),
                              ]),
                            ),
                            SizedBox(height: 15.0,),

                            Text(
                              "Role",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: update_member_role,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Role",
                                          hintStyle: subtitleStyle,
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0))),
                                      onChanged: (_) => setState(() {}),
                                    )
                                ),
                              ]),
                            ),
                            SizedBox(height: 15.0,),

                            SizedBox(height: 15.0,),
                            ElevatedButton(
                              onPressed: () async {
                                if (update_member_name_Controller.text
                                    .isEmpty ||
                                    update_member_number_Controller.text
                                        .isEmpty ||
                                    update_member_role.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar);
                                }else if(RegExp(r'^[0-9]{10}$').stringMatch(update_member_number_Controller.text) != null){
                                  await _updateMembers(widget.id);
                                  setState(() async {
                                    Navigator.pop(context);
                                  });
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      phonesnackBar);
                                }
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                      fontSize: 20, color: Colors.white, fontFamily: 'lato'),),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                    Size(wp(100, context), 50)),
                              ),
                              child: const Text("Update Member"),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // this method is used for update members details in member table in database
  Future<void> _updateMembers(int mid) async {
    await SQLHelper.updateMembers(mid, update_member_name_Controller.text,
        update_member_number_Controller.text, update_member_role.text);
  }
}
