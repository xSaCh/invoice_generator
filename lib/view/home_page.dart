import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invoice_bloc/bloc/Customer/customer_bloc.dart';
import 'package:invoice_bloc/bloc/Home/home_bloc.dart';
import 'package:invoice_bloc/bloc/Invoice/invoice_bloc.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/item.dart';
// import 'package:invoice_bloc/db/db.dart';
import 'package:invoice_bloc/core/invoice_helper.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:invoice_bloc/invoice_pdf.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/view/customer_page.dart';
import 'package:invoice_bloc/view/invoice_detail_page.dart';
// import 'package:invoice_bloc/core/_models/user.dart';
// import 'package:invoice_bloc/pages/customer_page.dart';
// import 'package:invoice_bloc/pages/invoice_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<HomeBloc>(context);
    if (bloc.state is HomeInitial) bloc.add(HomeGetInvoices());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 214, 241, 255),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // // Customer
              Customer? newCst = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => BlocProvider(
                      create: (bctx) => CustomerBloc(customer: Customer.empty()),
                      child: const CustomerPage())));

              if (newCst == null) return;
              if (!newCst.isInBox) bloc.add(HomeAddCustomer(newCst));

              var lastInvNo = bloc.invoiceRepo.getInvoices().last.invoiceNo;

              Invoice? newInvoice = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => BlocProvider(
                      create: (bctx) => InvoiceBloc(
                          invoice: Invoice(
                              "${lastInvNo.substring(0, lastInvNo.length - 3)}${(int.parse(lastInvNo.substring(lastInvNo.length - 3)) + 1).toString().padLeft(3, '0')}",
                              DateTime.now(),
                              0,
                              newCst,
                              [].cast<Item>())),
                      child: const InvoiceDetailPage())));

              if (newInvoice != null) bloc.add(HomeAddInvoice(newInvoice));
              bloc.add(HomeGetInvoices());
            },
            child: const Icon(Icons.add)),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            return current is HomeLoaded || current is HomeError;
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    if (state is HomeLoaded)
                      ListView.builder(
                          itemCount: state.invoices.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                                child: invoiceCard(state.invoices[i]),
                                onTap: () async {
                                  await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => BlocProvider(
                                          create: (bctx) =>
                                              InvoiceBloc(invoice: state.invoices[i]),
                                          child: const InvoiceDetailPage())));
                                  bloc.add(HomeGetInvoices());
                                });
                          })
                    else
                      const Center(child: Text("No Invoice"))
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget invoiceCard(Invoice inv) {
    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inv.customer.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.lightGreen.shade300),
                        child: Text(
                          "Sale",
                          style: TextStyle(color: Colors.green.shade600),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "#${inv.key}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      _invCardDate(inv.date),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          sAmount(inv.getTotal()),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Received",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          sAmount(inv.getReceivedAmount()),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          _saveInvoice(inv, "/storage/emulated/0/Download/test.pdf"),
                      padding: const EdgeInsets.all(5),
                      constraints:
                          const BoxConstraints(), // override default min size of 48px
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.print_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.all(5),
                      constraints:
                          const BoxConstraints(), // override default min size of 48px
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.share_outlined),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [const PopupMenuItem(value: 1, child: Text("Delete"))];
                      },
                      onSelected: (e) => _removeInvoice(inv),
                      padding: const EdgeInsets.all(5),
                      constraints:
                          const BoxConstraints(), // override default min size of 48px
                      icon: const Icon(Icons.more_vert_outlined),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveInvoice(Invoice inv, String path) async {
    // var pdf = InvoicePdf(config: await db.getConfig(), invoice: inv);
    // pdf.save(
    //     "${await getAppPath()}/${inv.customer.name}${DateFormat("_dd_MM_yyyy").format(DateTime.now())}.pdf");
  }

  String _invCardDate(DateTime dt) {
    final df = DateFormat("dd MMM yy");
    return df.format(dt);
  }

  void _removeInvoice(Invoice inv) => bloc.add(HomeRemoveInvoice(inv));
}
