import 'package:flutter_wind_surf_demo/features/customer/data/datasources/database_helper.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/models/customer.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final DatabaseHelper databaseHelper;

  CustomerRepositoryImpl({required this.databaseHelper});

  @override
  Future<Customer> createCustomer(Customer customer) async {
    return await databaseHelper.create(customer);
  }

  @override
  Future<void> deleteCustomer(int id) async {
    await databaseHelper.delete(id);
  }

  @override
  Future<List<Customer>> getAllCustomers() async {
    return await databaseHelper.getAllCustomers();
  }

  @override
  Future<Customer?> getCustomer(int id) async {
    return await databaseHelper.getCustomer(id);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await databaseHelper.update(customer);
  }
}
