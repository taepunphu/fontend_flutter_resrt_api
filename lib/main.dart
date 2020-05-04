import 'package:flutter/material.dart';
import 'package:flutter_employees_rest_api/Employee.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp(employees: fetchEmployees()));

List<Employee> parseEmployees(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Employee>((json) => Employee.fromJson(json)).toList();
}

Future<List<Employee>> fetchEmployees() async{
  final response = await http.get('http://192.168.3.140:3000/employees/');
  if(response.statusCode == 200){
    return parseEmployees(response.body);
  }else{
    throw Exception("Unable to fetch employees from the REST API");
  }
}



class MyApp extends StatelessWidget {
  final Future<List<Employee>> employees;
  MyApp({Key key, this.employees}): super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Employee Navigator demo',employees: employees),
    );
  }
}

class MyHomePage extends StatelessWidget {

  final String title;
  final Future<List<Employee>> employees;
  MyHomePage({Key key, this.title, this.employees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee TEST'),
      ),
      body: Center(
        child: FutureBuilder<List<Employee>>(
          future: employees,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return EmployeeBoxList(items: snapshot.data);
            }else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
          ),
        ),
    );
  }
}

class EmployeeBoxList extends StatelessWidget {
  final List<Employee> items;
  EmployeeBoxList({Key key,this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('${items[index].name}')
        );
      },
    );
  }
}

