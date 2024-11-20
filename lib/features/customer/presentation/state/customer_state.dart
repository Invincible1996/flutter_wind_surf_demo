import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/customer.dart';

part 'customer_state.freezed.dart';

@freezed
class CustomerState with _$CustomerState {
  const factory CustomerState.loading() = _Loading;
  const factory CustomerState.error(String message) = _Error;
  const factory CustomerState.data(List<Customer> customers) = _Data;
}
