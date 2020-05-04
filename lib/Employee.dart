class Employee {
  final int empID;
  final String name;
  final String empCode;
  final int salary;

  Employee({this.empID, this.name, this.empCode, this.salary});
  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(
      empID: json['EmpID'],
      name: json['Name'],
      empCode: json['EmpCode'],
      salary: json['Salary']
    );
  }
}