import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import 'members_details_page.dart';

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

  String? get _errorText1 {
    // at any time, we can get the text from _controller.value.text
    final text = update_member_name_Controller.value.text;

    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.trim().isEmpty) {
      return "Name can't be empty";
    } else {
      // Return null if the entered password is valid
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Members")),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20.0),
                child: Form(
                key: _formKey_update_members,
                child: Column(
                  children: [
                    SizedBox(
                      width: wp(80, context),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: update_member_name_Controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_add,
                            color: Colors.grey,
                          ),
                          labelText: 'Add Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          fillColor: Colors.transparent,
                          filled: true,
                          errorText: _errorText1 ,
                          // TODO: add errorHint
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name can't be empty";
                          } else {
                            // Return null if the entered password is valid
                            return null;
                          }
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      height: hp(4, context),
                    ),
                    SizedBox(
                      width: wp(80, context),
                      child: TextFormField(
                        controller: update_member_number_Controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          // for version 2 and greater youcan also use this
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          fillColor: Colors.transparent,
                          labelText: "Enter your number",
                          hintText: "Enter your number",
                          errorText: _errorText1,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Number can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      height: hp(4, context),
                    ),
                    SizedBox(
                      width: wp(80, context),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: update_member_role,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_pin_rounded,
                            color: Colors.grey,
                          ),
                          labelText: 'Add his Role/Designation',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          fillColor: Colors.transparent,
                          filled: true,
                          errorText: _errorText1,
                          // TODO: add errorHint
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Role/Designation can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    SizedBox(
                      height: hp(4, context),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey_update_members.currentState?.validate() == true) {
                          await _updateMembers(widget.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MembersDetailsPage()),
                          );
                        } else {
                          _formKey_update_members.currentState?.validate();
                        }
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize:
                        MaterialStateProperty.all(const Size(350, 40)),
                      ),
                      child: const Text("Add Members"),
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _updateMembers(int mid) async {
    await SQLHelper.updateMembers(mid, update_member_name_Controller.text,
        update_member_number_Controller.text, update_member_role.text);
  }
}
