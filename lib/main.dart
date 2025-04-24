import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_bloc/bloc/Home/home_bloc.dart';
import 'package:invoice_bloc/core/_models/bank_info.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';
import 'package:invoice_bloc/data/sources/invoice_data_sources.dart';
import 'package:invoice_bloc/firebase_options.dart';
import 'package:invoice_bloc/global.dart';
import 'package:invoice_bloc/view/home_page.dart';
import 'package:invoice_bloc/view/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  // debugPrint((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(BankInfoAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(GSTTypeAdapter());
  Hive.registerAdapter(UnitAdapter());

  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await Permission.manageExternalStorage.request();
    }
    debugPrint((await getApplicationDocumentsDirectory()).path);
  } else {
    debugPrint("Running on the web, no external storage permissions required.");
  }

  await Hive.openBox<Invoice>('invoices');
  // ..addAll(getInvoices());
  var c = await Hive.openBox<Customer>('customers');
  var r = await Hive.openBox<Product>('products');
  // r.clear();
  // c.clear();
  // c.addAll(testCustomers);
  // r.addAll(testProducts);
  
  var a = Hive.box<Invoice>("invoices").values.toList();
  // ..addAll(getCustomers());
  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeBloc())],
      child: const MyApp()));
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
        home: LoginPage());
  }
}
