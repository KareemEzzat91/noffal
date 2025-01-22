import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BlocHelper/home_cubit.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getEmployees();
  }

  void _showEmployeeDialog({String? title, Employee? employee}) {
    final nameController = TextEditingController(text: employee?.name ?? '');
    final emailController = TextEditingController(text: employee?.email ?? '');
    final phoneController = TextEditingController(text: employee?.phone ?? '');
    final passwordController = TextEditingController(text: employee?.password ?? '');
    final salaryController = TextEditingController(text: employee != null ? employee.salary.toString() : '');
    final ageController = TextEditingController(
        text: employee != null ? employee.age.toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? 'Add Employee',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(
                    labelText: 'salary',
                    prefixIcon: Icon(Icons.monetization_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'phone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final phone = phoneController.text.trim();
                        final password = passwordController.text.trim();
                        final age = int.tryParse(ageController.text.trim());
                        final salary = int.tryParse(salaryController.text.trim());

                        if (name.isNotEmpty && email.isNotEmpty && age != null) {
                          if (employee == null) {
                            context.read<HomeCubit>().addEmployee(
                              employee: Employee(
                                name: name,
                                email: email,
                                age: age,
                                salary: salary,
                                phone: phone,
                                password: password
                              ),
                            );
                          } else {
                            context.read<HomeCubit>().updateEmployee(
                              id: employee.id ?? 0,
                              employee: Employee(
                                name: name,
                                email: email,
                                age: age,
                                  salary: salary,
                                  phone: phone,
                                  password: password
                              ),
                            );
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(Employee employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${employee.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().deleteEmployee(id: employee.id ?? 0);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees System"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HomeCubit>().getEmployees(),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SuccessState) {
            final employees = context.read<HomeCubit>().employees;

            if (employees.isEmpty) {
              return const Center(
                child: Text('No Employees Found'),
              );
            }

            return Column(

              children: [
                _buildDashboardItem(Icons.person,"Number of Employee ","3",Colors.blueAccent,false,context),


                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: employees.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade300,
                          child: Text(
                            employee.name![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          employee.name ?? 'No Name',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${employee.email ?? 'No Email'}\nAge: ${employee.age ?? 'N/A'}',
                          style: const TextStyle(height: 1.5),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEmployeeDialog(
                                title: 'Edit Employee',
                                employee: employee,
                              );
                            } else if (value == 'delete') {
                              _confirmDelete(employee);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text(
                state.error ?? "Error",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: Text("No Data Found"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEmployeeDialog(title: 'Add Employee'),
        label: const Text('Add Employee'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
Widget _buildDashboardItem(IconData icon, String label, String value, Color color,bool ISDarkMode,context) {
  return Container(
    margin: const EdgeInsets.all(8),
    padding:  const EdgeInsets.all(10  ),
    decoration: BoxDecoration(
      color:ISDarkMode ?Colors.black:Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 7,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(height: 10),
        Text(
          value,
          style:  const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:  15 ),
          ),
        Text(label,style: const TextStyle(fontSize:  15),),
      ],
    ),
  );
}
