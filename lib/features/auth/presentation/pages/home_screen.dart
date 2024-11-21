import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/custom_data_table.dart';
import '../../../../routes/app_router.dart';
import '../../../customer/presentation/providers/customer_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerState = ref.watch(customerNotifierProvider);

    // Listen to auth state changes
    ref.listen<AsyncValue<bool>>(authNotifierProvider, (previous, next) {
      next.whenData((isAuthenticated) {
        if (!isAuthenticated) {
          context.router.replace(const LoginRoute());
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              await context.router.push(const AddCustomerRoute());
              if (!context.mounted) return;
              ref.read(customerNotifierProvider.notifier).loadCustomers();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: customerState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Center(child: Text('Error: $error')),
        data: (customers) {
          if (customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No customers yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context.router.push(const AddCustomerRoute());
                      if (!context.mounted) return;
                      ref
                          .read(customerNotifierProvider.notifier)
                          .loadCustomers();
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Customer'),
                  ),
                ],
              ),
            );
          }

          final columns = [
            CustomDataTableColumn(
              label: 'Avatar',
              tooltip: 'Customer Avatar',
              filterable: false,
              customCell: (value) => CircleAvatar(
                backgroundColor: _getColorFromName(value as String),
                child: Icon(_getGenderIcon(value)),
              ),
            ),
            const CustomDataTableColumn(
              label: 'Name',
              tooltip: 'Customer Name',
            ),
            const CustomDataTableColumn(
              label: 'Age',
              tooltip: 'Customer Age',
              numeric: true,
            ),
            const CustomDataTableColumn(
              label: 'Gender',
            ),
            const CustomDataTableColumn(
              label: 'Address',
              tooltip: 'Customer Address',
            ),
            CustomDataTableColumn(
              label: 'Actions',
              filterable: false,
              customCell: (value) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete ${value['name']}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(customerNotifierProvider.notifier)
                                      .deleteCustomer(value['id']);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ];

          final rows = customers.map((customer) => {
            'avatar': customer.color,
            'name': customer.name,
            'age': customer.age,
            'gender': customer.gender,
            'address': customer.address,
            'actions': {'id': customer.id, 'name': customer.name},
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              return ref
                  .read(customerNotifierProvider.notifier)
                  .loadCustomers();
            },
            child: CustomDataTable(
              columns: columns,
              rows: rows,
              borderColor: Colors.grey.shade300,
            ),
          );
        },
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male;
      case 'female':
        return Icons.female;
      default:
        return Icons.person;
    }
  }
}
