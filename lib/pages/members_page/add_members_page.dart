import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronovo_app/pages/members_page/members_details_page.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({Key? key}) : super(key: key);
  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {

  TextEditingController add_member_Controller = TextEditingController();
  TextEditingController add_role_Controller = TextEditingController();
  TextEditingController mobileno_controller = TextEditingController();

  final _formKey_add_members = GlobalKey<FormState>();

  String people_data = '';
  String people_role = '';
  List<Map<String, dynamic>> _listProjects = [];

  String? get _errorText1 {
    // at any time, we can get the text from _controller.value.text
    final text = add_member_Controller.value.text;

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
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
                  key: _formKey_add_members,
                  child: Column(
                    children: [
                      SizedBox(
                        width: wp(80, context),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: add_member_Controller,
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
                          controller: mobileno_controller,
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
                          controller: add_role_Controller,
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
                          if (_formKey_add_members.currentState?.validate() == true) {
                            await _addMembers();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MembersDetailsPage()),
                            );
                          } else {
                            _formKey_add_members.currentState?.validate();
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
  Future<void> _addMembers() async {
    // String data = json.encode(_selectedItems);
    await SQLHelper.createMembers(
        add_member_Controller.text, mobileno_controller.text, add_role_Controller.text);
  }
}
