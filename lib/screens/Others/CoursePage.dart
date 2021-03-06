import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> {
  var selectedIndex, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Add course")),
        body: Form(
          key: _formKeyValue,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("course").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      Text("Loading");
                    } else {
                      List<DropdownMenuItem> courseList = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        DocumentSnapshot snap = snapshot.data.documents[i];
                        courseList.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.documentID,
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                            value: "${snap.documentID}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 50.0),
                          DropdownButton(
                            items: courseList,
                            onChanged: (selectedCourse) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected course is index $selectedCourse',
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                              setState(() {
                                courseList = selectedCourse;
                              });
                            },
                            value: selectedIndex,
                            isExpanded: false,
                            hint: new Text(
                              "Choose Course Index from List",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        ],
                      );
                    }
                    return Row();
                  }),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Course name?",
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Task Description",
                ),
              ),
              InkWell(
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2099))
                      .then((value) {});
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: "Select Due Date",
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Unit Count",
                ),
              ),
              SizedBox(
                height: 150.0,
              ),
              RaisedButton(
                  color: Color(0xff11b719),
                  textColor: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Submit", style: TextStyle(fontSize: 24.0)),
                        ],
                      )),
                  onPressed: () {},
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            ],
          ),
        ));
  }
}
