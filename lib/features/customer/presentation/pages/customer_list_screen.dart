import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/app_router.dart';
import '../providers/customer_provider.dart';

@RoutePage()
class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerState = ref.watch(customerNotifierProvider);
    final notifier = ref.read(customerNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.pushRoute(const AddCustomerRoute());
            },
          ),
        ],
      ),
      body: customerState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Center(child: Text('Error: $error')),
        data: (customers) => ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return ListTile(
              title: Text(customer.name),
              subtitle:
                  Text('Age: ${customer.age} | Gender: ${customer.gender}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      notifier.deleteCustomer(customer.id!);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
