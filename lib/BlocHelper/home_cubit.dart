import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:noffal/ApiHelper/Apihelper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Employee> employees = [
  /*  Employee(id: 1,name: "mo",age: 20,email: "wgwgafwfwwg@gmail.com", password: "123534424",phone: '010020120',salary: 22242222),
    Employee(id: 2,name: "ahmad",age: 20,email: "wgwawfwagwg@gmail.com", password: "12234424",phone: '020020220',salary: 22222222),
    Employee(id: 3,name: "Nor",age: 20,email: "wgfwfwwgwg@gmail.com", password: "133524424",phone: '030030220',salary: 22262222),*/
  ];

  // جلب قائمة الموظفين
  Future<List<Employee>> getEmployees() async {
    emit(LoadingState());
    try {
      final response = await Apihelper.getData(path: '/api/Employee');
      if (response.statusCode == 200) {
        employees = (response.data as List)
            .map((e) => Employee.fromJson(e))
            .toList();
        emit(SuccessState());
        return employees;
      } else {
        emit(ErrorState('Failed to fetch employees.'));


      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  // جلب موظف حسب ID
  Future<Employee?> getEmployeeById({required int id}) async {
    emit(LoadingState());
    try {
      final response = await Apihelper.getData(path: '/api/Employee/$id');
      if (response.statusCode == 200) {
        emit(SuccessState());
        return Employee.fromJson(response.data);
      } else {
        emit(ErrorState('Employee not found.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return null;
  }

  // إضافة موظف جديد
  Future<void> addEmployee({required Employee employee}) async {
    emit(LoadingState());
    try {
      final response = await Apihelper.PostData(
        path: '/api/Employee',
        Body: employee.toJson(),
      );
      if (response?.statusCode == 200) {
        employees.add(Employee.fromJson(response?.data));
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to add employee.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // تحديث بيانات الموظف
  Future<void> updateEmployee({ required int id, required  Employee employee}) async {
    emit(LoadingState());
    try {
      final response = await Apihelper.putData(
        path: '/api/Employee/$id',
        body: employee.toJson(),
      );
      if (response.statusCode == 200) {
        final index = employees.indexWhere((e) => e.id == id);
        if (index != -1) {
          employees[index] = Employee.fromJson(response.data);
        }
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to update employee.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // حذف موظف
  Future<void> deleteEmployee({ required int id}) async {
    emit(LoadingState());
    try {
      final response = await Apihelper.deleteData(path: '/api/Employee/$id');
      if (response.statusCode == 200) {
        employees.removeWhere((e) => e.id == id);
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to delete employee.'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

class Employee {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? age;
  int? salary;
  String? password;

  // Constructor
  Employee({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.salary,
    this.password,
  });

  // From JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      age: json['age'] as int?,
      salary: json['salary'] as int?,
      password: json['password'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'salary': salary,
      'password': password,
    };
  }
}
