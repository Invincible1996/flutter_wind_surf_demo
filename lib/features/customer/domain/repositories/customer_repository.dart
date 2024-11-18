import 'package:flutter_wind_surf_demo/features/customer/domain/models/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers();
  Future<Customer> createCustomer(Customer customer);
  Future<Customer?> getCustomer(int id);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
}
