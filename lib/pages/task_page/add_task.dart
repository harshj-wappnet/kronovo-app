// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:intl/intl.dart';
// import 'package:kronovo_app/pages/home_page.dart';
// import 'package:kronovo_app/pages/task_page/task_details_page.dart';
//
// import 'package:kronovo_app/responsive.dart';
//
// import '../../helpers/sql_helper.dart';
// import '../create_project/assign members_dialog.dart';
//
// class Add_Task extends StatefulWidget {
//   @override
//
//   const Add_Task(this.id, {super.key});
//   final id;
//   @override
//   State<Add_Task> createState() => _MyWidgetState();
// }
//
// class _MyWidgetState extends State<Add_Task> {
//   bool isVisible = false;
//   final _formKey = GlobalKey<FormState>();
//   String? _selectedTime;
//   List<String> _selectedItems = [];
//   String people_data = '';
//   bool _validate = false;
//
//
//   //late TextEditingController time_controller = TextEditingController();
//   late TextEditingController dateInput1 = TextEditingController();
//   late TextEditingController task_title_Controller;
//   late TextEditingController task_description_Controller;
//
//   Future<void> _show() async {
//     final TimeOfDay? result =
//         await showTimePicker(context: context, initialTime: TimeOfDay.now());
//     if (result != null) {
//       setState(() {
//         _selectedTime = result.format(context);
//       });
//     }
//   }
//
//   String? get _errorText1 {
//     // at any time, we can get the text from _controller.value.text
//     final text = task_title_Controller.value.text;
//
//     // Note: you can do your own custom validation here
//     // Move this logic this outside the widget for more testable code
//     if (text.trim().isEmpty) {
//       return "Project Title can't be empty";
//     } else {
//       // Return null if the entered password is valid
//       return null;
//     }
//   }
//
//   bool _submitted = false;
//
//   void _submit() {
//     // if there is no error text
//     setState(() => _submitted = true);
//     if (_errorText1 == null) {
//     }
//   }
//
//   @override
//   void initState() {
//     dateInput1.text = "";
//     task_title_Controller = TextEditingController();
//     task_description_Controller = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     task_title_Controller.dispose();
//     task_description_Controller.dispose();
//     super.dispose();
//   }
//
//   void _showMultiSelect() async {
//     // a list of selectable items
//     // these items can be hard-coded or dynamically fetched from a database/API
//     final List<String> items = [
//       'Akshay Patel',
//       'Arti Chauhan',
//       'Harsh Jani',
//       'Darshit Shah',
//       'Apurv Patel',
//       'Yassar Qureshi',
//       'Aditya Soni',
//       'Ram Ghumaliya'
//     ];
//
//     final List<String>? results = await showDialog(
//       context: this.context,
//       builder: (BuildContext context) {
//         return MultiSelect(items: items);
//       },
//     );
//
//     // Update UI
//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//         // String data = jsonEncode(_selectedItems);
//         _selectedItems.forEach((element) {
//           people_data += element;
//           people_data += ',';
//         });
//         //print(people_data);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Center(child: Text("Add Task")),
//           backgroundColor: Colors.green,
//       ),
//       body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).requestFocus(new FocusNode());
//           },
//           child: SafeArea(
//               child: SingleChildScrollView(
//                   child: Center(
//                       child: Column(
//                         children: [
//                           Image.asset('assets/images/tasks_image.jpg', height: 200, width: 300,),
//                           Form(
//                               key: _formKey,
//                               child: Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Container(
//                                       child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                         SizedBox(height: 10),
//                                         SizedBox(
//                                           width: wp(80, context),
//                                           child: TextFormField(
//                                             autovalidateMode:
//                                                 AutovalidateMode.onUserInteraction,
//                                             controller: task_title_Controller,
//                                             decoration: InputDecoration(
//                                               prefixIcon: Icon(
//                                                 Icons.edit_note,
//                                                 color: Colors.grey,
//                                               ),
//                                               labelText: 'Enter the Task',
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8.0)),
//                                               fillColor: Colors.grey.shade200,
//                                               filled: true,
//                                               errorText:
//                                                   _submitted ? _errorText1 : null,
//
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return "Task can't be empty";
//                                               } else {
//                                                 return null;
//                                               }
//                                             },
//                                             onChanged: (_) => setState(() {}),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: hp(4, context),
//                                         ),
//                                         SizedBox(height: 5),
//                                         SizedBox(
//                                           width: wp(80, context),
//                                           child: TextFormField(
//                                             maxLines: 2,
//                                             autovalidateMode:
//                                                 AutovalidateMode.onUserInteraction,
//                                             controller:
//                                                 task_description_Controller,
//                                             decoration: InputDecoration(
//                                               prefixIcon: Icon(
//                                                 Icons.edit_note,
//                                                 color: Colors.grey,
//                                               ),
//                                               labelText: 'Enter Task Description',
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8.0)),
//                                               fillColor: Colors.grey.shade200,
//                                               filled: true,
//
//
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return "Project Description can't be empty";
//                                               } else {
//                                                 return null;
//                                               }
//                                             },
//                                             onChanged: (_) => setState(() {}),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: hp(4, context),
//                                         ),
//                                         SizedBox(height: 5),
//                                         SizedBox(
//                                           width: wp(80, context),
//                                           child: TextField(
//                                             controller: dateInput1,
//                                             decoration: InputDecoration(
//                                               prefixIcon: Icon(
//                                                 Icons.calendar_today,
//                                                 color: Colors.grey,
//                                               ),
//                                               labelText: "Enter Deadline Date",
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8.0)),
//                                               fillColor: Colors.grey.shade200,
//                                               filled: true, //label text of field
//                                             ),
//                                             readOnly: true,
//                                             onTap: () async {
//                                               DateTime? pickedDate1 =
//                                                   await showDatePicker(
//                                                       context: context,
//                                                       initialDate: DateTime.now(),
//                                                       firstDate: DateTime(1950),
//                                                       lastDate: DateTime(2100));
//                                               if (pickedDate1 != null) {
//                                                 print(
//                                                     pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
//                                                 String formattedDate1 =
//                                                     DateFormat('yMMMd')
//                                                         .format(pickedDate1);
//                                                 print(
//                                                     formattedDate1); //formatted date output using intl package =>  2021-03-16
//                                                 setState(() {
//                                                   dateInput1.text =
//                                                       formattedDate1; //set output date to TextField value.
//                                                 });
//                                               } else {}
//                                             },
//                                           ),
//                                         ),
//                                         SizedBox(height: hp(4, context)),
//                                         ElevatedButton(
//                                           onPressed: _showMultiSelect,
//                                           style: ButtonStyle(
//                                             textStyle: MaterialStateProperty.all(
//                                               TextStyle(
//                                                   fontSize: 20,
//                                                   color: Colors.white),
//                                             ),
//                                             shape: MaterialStateProperty.all(
//                                               RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             fixedSize: MaterialStateProperty.all(
//                                                 const Size(250, 40)),
//                                           ),
//                                           child: const Text('Assign Peoples'),
//                                         ),
//
//                                         // display selected items
//                                         Wrap(
//                                           children: _selectedItems
//                                               .map((e) => Chip(
//                                                     label: Text(
//                                                       "${e.split(" ")[0][0]}${e.split(" ")[1][0]}",
//                                                     ),
//                                                     backgroundColor:
//                                                         Colors.lightGreen,
//                                                   ))
//                                               .toList(),
//                                         ),
//                                         SizedBox(
//                                           height: hp(4, context),
//                                         ),
//                                         Row(
//                                           children: [
//                                             SizedBox(width: wp(7, context)),
//                                             ElevatedButton(
//                                                 style: ButtonStyle(
//                                                     shape: MaterialStateProperty.all<
//                                                             RoundedRectangleBorder>(
//                                                         RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8.0),
//                                                 ))),
//                                                 onPressed: (() async {
//                                                   await _addTask(widget.id);
//                                                   if (_formKey.currentState?.validate() == true) {
//                                                     setState(() {
//                                                       Navigator.pop(context);
//                                                     });
//
//                                                   } else {
//                                                     _formKey.currentState?.validate();
//                                                   }
//                                                 }),
//                                                 child: Text("Add Task")),
//                                             SizedBox(
//                                               width: wp(20, context),
//                                             ),
//                                             ElevatedButton(
//                                                 style: ButtonStyle(
//                                                     shape: MaterialStateProperty.all<
//                                                             RoundedRectangleBorder>(
//                                                         RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8.0),
//                                                 ))),
//                                                 onPressed: (() {
//                                                   Navigator.pop(context);
//                                                 }),
//                                                 child: Text("Cancel Task")),
//                                           ],
//                                         ),
//                                       ]
//                                       )
//                                   )
//                               )
//                           ),
//                         ],
//                       )
//                   )
//               )
//           )
//       ),
//     );
//   }
//
//
//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     width: wp(80, context),
//                     child: TextFormField(
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: task_title_Controller,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(
//                           Icons.edit_note,
//                           color: Colors.grey,
//                         ),
//                         labelText: 'Enter Task Title',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0)),
//                         fillColor: Colors.grey.shade200,
//                         filled: true,
//
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Title can't be empty";
//                         } else {
//                           return null;
//                         }
//                       },
//                       onChanged: (_) => setState(() {}),
//                     ),
//                   ),
//                   SizedBox(
//                     height: hp(4, context),
//                   ),
//                   SizedBox(height: 5),
//                   SizedBox(
//                     width: wp(80, context),
//                     child: TextFormField(
//                       maxLines: 2,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       controller: task_description_Controller,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(
//                           Icons.edit_note,
//                           color: Colors.grey,
//                         ),
//                         labelText: 'Enter Task Description',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0)),
//                         fillColor: Colors.grey.shade200,
//                         filled: true,
//
//
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "Project Description can't be empty";
//                         } else {
//                           return null;
//                         }
//                       },
//                       onChanged: (_) => setState(() {}),
//                     ),
//                   ),
//                   SizedBox(
//                     height: hp(4, context),
//                   ),
//                   SizedBox(height: 5),
//                   SizedBox(
//                     width: wp(80, context),
//                     child: TextField(
//                       controller: dateInput1,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(
//                           Icons.calendar_today,
//                           color: Colors.grey,
//                         ),
//                         labelText: "Enter Deadline Date",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0)),
//                         fillColor: Colors.grey.shade200,
//                         filled: true, //label text of field
//                       ),
//                       readOnly: true,
//                       onTap: () async {
//                         DateTime? pickedDate1 = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1950),
//                             lastDate: DateTime(2100));
//                         if (pickedDate1 != null) {
//                           print(
//                               pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
//                           String formattedDate1 =
//                           DateFormat('yMMMd').format(pickedDate1);
//                           print(
//                               formattedDate1); //formatted date output using intl package =>  2021-03-16
//                           setState(() {
//                             dateInput1.text =
//                                 formattedDate1; //set output date to TextField value.
//                           });
//                         } else {}
//                       },
//                     ),
//                   ),
//                   SizedBox(height: hp(4, context)),
//                   SizedBox(
//                     height: hp(4, context),
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(width: wp(7, context)),
//                       ElevatedButton(
//                           style: ButtonStyle(
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ))),
//                           onPressed: (() {
//                             if (_formKey.currentState!.validate()) {
//                               Navigator.pop(context);
//                               // setState(() {
//                               //   _task_title.text.isEmpty &&
//                               //           _task_description.text.isEmpty
//                               //       ? _validate = true
//                               //       : _validate = false;
//                               // });
//                             }
//                           }),
//                           child: Text("Add Task")),
//                       SizedBox(
//                         width: wp(20, context),
//                       ),
//                       ElevatedButton(
//                           style: ButtonStyle(
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ))),
//                           onPressed: (() {
//                             Navigator.pop(context);
//                           }),
//                           child: Text("Cancel Task")),
//                     ],
//                   ),
//                   SizedBox(
//                     height: hp(4, context),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
//
//   Future<void> _addTask(int id) async{
//     String current_date = DateTime.now().toString();
//     // String data = json.encode(_selectedItems);
//     await SQLHelper.createTask(id,task_title_Controller.text, task_description_Controller.text, dateInput1.text, people_data, current_date);
//   }
// }
