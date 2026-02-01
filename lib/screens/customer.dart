import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/customer.dart';
import '../services/database.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Customer> _customers = [];
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);
    _customers = await _dbService.getAllCustomers();
    setState(() => _isLoading = false);
  }

  void _showCustomerDialog({Customer? customer}) {
    final isEditing = customer != null;
    final nameController = TextEditingController(text: customer?.name ?? '');
    final emailController = TextEditingController(text: customer?.email ?? '');
    final phoneController = TextEditingController(text: customer?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Customer' : 'Add Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.roboto(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.roboto(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                style: GoogleFonts.roboto(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              final phone = phoneController.text.trim();

              if (name.isEmpty) {
                Get.snackbar('Error', 'Name is required');
                return;
              }

              final newCustomer = Customer(
                id: isEditing
                    ? customer!.id
                    : DateTime.now().millisecondsSinceEpoch,
                name: name,
                email: email,
                phone: phone,
              );

              if (isEditing) {
                await _dbService.updateCustomer(newCustomer);
              } else {
                await _dbService.insertCustomer(newCustomer);
              }

              _loadCustomers();
              Navigator.of(context).pop();
              Get.snackbar(
                'Success',
                isEditing ? 'Customer updated' : 'Customer added',
              );
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _dbService.deleteCustomer(customer.id);
              _loadCustomers();
              Navigator.of(context).pop();
              Get.snackbar('Success', 'Customer deleted');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: GoogleFonts.roboto(),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter customer name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.roboto(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.roboto(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final customer = Customer(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                  );
                  await _dbService.insertCustomer(customer);
                  _nameController.clear();
                  _emailController.clear();
                  _phoneController.clear();
                  _loadCustomers();
                  Get.snackbar(
                    'Success',
                    'Customer added',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text(
                'Add Customer',
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _customers.isEmpty
                  ? const Center(child: Text('No customers found. Add some!'))
                  : ListView.builder(
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        final customer = _customers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person, size: 50),
                            title: Text(customer.name),
                            subtitle: Text(
                              'Email: ${customer.email} | Phone: ${customer.phone}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showCustomerDialog(customer: customer),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCustomer(customer),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
