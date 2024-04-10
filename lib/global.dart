import 'package:invoice_bloc/data/repositories/customer_repository.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';

class Global {
  static Global? _global;
  static Global ins() {
    _global ??= Global();

    return _global!;
  }

  final InvoiceRepository invoiceRepository;
  final CustomerRepository customerRepository;
  Global()
      : invoiceRepository = InvoiceRepository(),
        customerRepository = CustomerRepository();
}
