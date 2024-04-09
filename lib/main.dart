import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_bloc/bloc/Home/home_bloc.dart';
import 'package:invoice_bloc/core/_models/bank_info.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';
import 'package:invoice_bloc/view/home_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  debugPrint((await getApplicationDocumentsDirectory()).path);

  await Hive.initFlutter();
  Hive.registerAdapter(BankInfoAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(GSTTypeAdapter());
  Hive.registerAdapter(UnitAdapter());

  debugPrint("AAA");
  await Hive.openBox<Invoice>('invoices');
  // var i = Invoice(
  //     "22/IT001",
  //     DateTime.now(),
  //     0,
  //     Customer("AA", "Addr", "+91 92440", "email@gmail.com", "CCC@45902AK"),
  //     [Item(Product("Tshirt", 69, gstType: GSTType.gst_5))]);

  // // i.save();
  // b.add(i);
  debugPrint("Q q");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => HomeBloc(repository: InvoiceRepository()),
          child: const HomePage(),
        ));
  }
}
