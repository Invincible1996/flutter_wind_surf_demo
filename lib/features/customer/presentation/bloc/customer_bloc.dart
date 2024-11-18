import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/models/customer.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/repositories/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<LoadCustomers>((event, emit) async {
      try {
        emit(CustomerLoading());
        final customers = await customerRepository.getAllCustomers();
        emit(CustomersLoaded(customers));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<AddCustomer>((event, emit) async {
      try {
        await customerRepository.createCustomer(event.customer);
        final customers = await customerRepository.getAllCustomers();
        emit(CustomersLoaded(customers));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<UpdateCustomer>((event, emit) async {
      try {
        await customerRepository.updateCustomer(event.customer);
        final customers = await customerRepository.getAllCustomers();
        emit(CustomersLoaded(customers));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<DeleteCustomer>((event, emit) async {
      try {
        await customerRepository.deleteCustomer(event.customerId);
        final customers = await customerRepository.getAllCustomers();
        emit(CustomersLoaded(customers));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });
  }
}
