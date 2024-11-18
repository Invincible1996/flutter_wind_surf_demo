import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wind_surf_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_wind_surf_demo/features/customer/presentation/bloc/customer_bloc.dart';
import 'package:flutter_wind_surf_demo/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:flutter_wind_surf_demo/routes/app_router.dart';
import 'package:flutter_wind_surf_demo/widgets/app_drawer.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          AutoRouter.of(context).replace(const LoginRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customers'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                await context.router.push(const AddCustomerRoute());
                if (!context.mounted) return;
                context.read<CustomerBloc>().add(LoadCustomers());
              },
            ),
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkMode) {
                return IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (authState is AuthAuthenticated) {
              return BlocConsumer<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  if (state is CustomerError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CustomerInitial) {
                    context.read<CustomerBloc>().add(LoadCustomers());
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CustomerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CustomerError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CustomerBloc>().add(LoadCustomers());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CustomersLoaded) {
                    if (state.customers.isEmpty) {
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
                                await context.router
                                    .push(const AddCustomerRoute());
                                if (!context.mounted) return;
                                context
                                    .read<CustomerBloc>()
                                    .add(LoadCustomers());
                              },
                              icon: const Icon(Icons.person_add),
                              label: const Text('Add Customer'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CustomerBloc>().add(LoadCustomers());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.customers.length,
                        itemBuilder: (context, index) {
                          final customer = state.customers[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _getColorFromName(customer.color),
                                child: Icon(
                                  _getGenderIcon(customer.gender),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                customer.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Age: ${customer.age}'),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Address: ${customer.address}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Customer'),
                                      content: Text(
                                          'Are you sure you want to delete ${customer.name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true && customer.id != null) {
                                    if (!context.mounted) return;
                                    context
                                        .read<CustomerBloc>()
                                        .add(DeleteCustomer(customer.id!));
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const Center(child: Text('Something went wrong'));
                },
              );
            }
            return const Center(child: Text('Please log in'));
          },
        ),
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
