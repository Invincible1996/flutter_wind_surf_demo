import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wind_surf_demo/features/customer/domain/models/customer.dart';
import 'package:flutter_wind_surf_demo/features/customer/presentation/providers/customer_provider.dart';

// DropdownMenuEntry labels and values for the first dropdown menu.
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

enum GenderLabel {
  male('Male', Icons.male),
  female('Female', Icons.female),
  other('Other', Icons.person);

  const GenderLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

@RoutePage()
class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  final TextEditingController colorController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  ColorLabel? selectedColor;
  GenderLabel? selectedGender;

  @override
  void dispose() {
    colorController.dispose();
    genderController.dispose();
    iconController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownMenu<GenderLabel>(
                initialSelection: GenderLabel.male,
                controller: genderController,
                requestFocusOnTap: true,
                label: const Text('Gender'),
                onSelected: (GenderLabel? gender) {
                  setState(() {
                    selectedGender = gender;
                  });
                },
                dropdownMenuEntries: GenderLabel.values
                    .map<DropdownMenuEntry<GenderLabel>>((GenderLabel gender) {
                  return DropdownMenuEntry<GenderLabel>(
                    value: gender,
                    label: gender.label,
                    leadingIcon: Icon(gender.icon),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownMenu<ColorLabel>(
                initialSelection: ColorLabel.green,
                controller: colorController,
                requestFocusOnTap: true,
                label: const Text('Color'),
                onSelected: (ColorLabel? color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
                dropdownMenuEntries: ColorLabel.values
                    .map<DropdownMenuEntry<ColorLabel>>((ColorLabel color) {
                  return DropdownMenuEntry<ColorLabel>(
                    value: color,
                    label: color.label,
                    enabled: color.label != 'Grey',
                    style: MenuItemButton.styleFrom(
                      foregroundColor: color.color,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final customer = Customer(
                      name: _nameController.text,
                      gender: selectedGender?.label ?? 'Male',
                      age: int.parse(_ageController.text),
                      address: _addressController.text,
                      color: selectedColor?.label ?? 'Green',
                    );

                    await ref
                        .read(customerNotifierProvider.notifier)
                        .addCustomer(customer);
                    if (context.mounted) {
                      context.router.maybePop();
                    }
                  }
                },
                child: const Text('Save Customer Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
