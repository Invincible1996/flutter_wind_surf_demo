import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../data/datasources/database_helper.dart';
import '../state/customer_state.dart';

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerRepository _repository;

  CustomerNotifier(this._repository) : super(const CustomerState.loading());

  /// Load all customers
  /// 1. Get the current list of customers
  Future<void> loadCustomers() async {
    state = const CustomerState.loading();
    try {
      final customers = await _repository.getAllCustomers();
      state = CustomerState.data(customers);
    } catch (e) {
      state = CustomerState.error(e.toString());
    }
  }

  /// Add a new customer
  /// 2. Add the new customer to the current list of customers
  Future<void> addCustomer(Customer customer) async {
    final currentCustomers = state.when(
      loading: () => <Customer>[],
      error: (_) => <Customer>[],
      data: (customers) => customers,
    );

    state = const CustomerState.loading();
    try {
      final newCustomer = await _repository.createCustomer(customer);
      state = CustomerState.data([...currentCustomers, newCustomer]);
    } catch (e) {
      state = CustomerState.error(e.toString());
    }
  }

  /// Update an existing customer
  /// 3.Update the current list of customers
  Future<void> updateCustomer(Customer customer) async {
    final currentCustomers = state.when(
      loading: () => <Customer>[],
      error: (_) => <Customer>[],
      data: (customers) => customers,
    );

    state = const CustomerState.loading();
    try {
      await _repository.updateCustomer(customer);
      final updatedCustomers = currentCustomers.map((c) {
        return c.id == customer.id ? customer : c;
      }).toList();
      state = CustomerState.data(updatedCustomers);
    } catch (e) {
      state = CustomerState.error(e.toString());
    }
  }

  /// Delete a customer
  /// 4. Update the current list of customers
  Future<void> deleteCustomer(int id) async {
    final currentCustomers = state.when(
      loading: () => <Customer>[],
      error: (_) => <Customer>[],
      data: (customers) => customers,
    );

    state = const CustomerState.loading();
    try {
      await _repository.deleteCustomer(id);
      final updatedCustomers =
          currentCustomers.where((c) => c.id != id).toList();
      state = CustomerState.data(updatedCustomers);
    } catch (e) {
      state = CustomerState.error(e.toString());
    }
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final databaseHelper = DatabaseHelper.instance;
  return CustomerRepositoryImpl(databaseHelper: databaseHelper);
});

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return CustomerNotifier(repository)..loadCustomers();
});
