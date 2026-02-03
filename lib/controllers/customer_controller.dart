import 'package:get/get.dart';
import '../models/customer.dart';
import '../services/database.dart';

class CustomerController extends GetxController {
  var customers = <Customer>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  void loadCustomers() async {
    customers.value = await DatabaseService().getAllCustomers();
  }

  void addCustomer(Customer customer) async {
    await DatabaseService().insertCustomer(customer);
    loadCustomers();
  }

  void updateCustomer(Customer customer) async {
    await DatabaseService().updateCustomer(customer);
    loadCustomers();
  }

  void deleteCustomer(int id) async {
    await DatabaseService().deleteCustomer(id);
    loadCustomers();
  }
}
