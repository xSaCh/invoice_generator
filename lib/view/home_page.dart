import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invoice_bloc/bloc/Customer/customer_bloc.dart';
import 'package:invoice_bloc/bloc/Home/home_bloc.dart';
import 'package:invoice_bloc/bloc/Invoice/invoice_bloc.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/user.dart';
import 'package:invoice_bloc/core/invoice_helper.dart'; // Added import for sAmount
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/global.dart';
import 'package:invoice_bloc/invoice_pdf.dart';
import 'package:invoice_bloc/view/customer_page.dart';
import 'package:invoice_bloc/view/invoice_detail_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<HomeBloc>();
    if (bloc.state is HomeInitial) {
      bloc.add(HomeGetInvoices());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: const Text('Invoices'),
          backgroundColor: theme.colorScheme.primaryContainer,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Customer? newCst = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => BlocProvider(
                          create: (bctx) =>
                              CustomerBloc(customer: Customer.empty()),
                          child: const CustomerPage())));

              if (newCst == null) return;
              if (!newCst.isInBox) bloc.add(HomeAddCustomer(newCst));

              var lastInvNo = "22/IT_000";
              final currentState = bloc.state;
              if (currentState is HomeLoaded &&
                  currentState.invoices.isNotEmpty) {
                lastInvNo = currentState.invoices.last.invoiceNo;
              }
              // else if (Global.ins()
              //     .invoiceRepository
              //     .getInvoices()
              //     .isNotEmpty) {
              //   lastInvNo =
              //       Global.ins().invoiceRepository.getInvoices().last.invoiceNo;
              // }

              String nextInvNo;
              try {
                final parts = lastInvNo.split('_');
                final prefix = parts[0];
                final numberPart = parts.length > 1 ? parts[1] : '0';
                final nextNumber =
                    (int.parse(numberPart) + 1).toString().padLeft(3, '0');
                nextInvNo = "$prefix\_$nextNumber";
              } catch (e) {
                log("Error parsing last invoice number: $lastInvNo, Error: $e");
                nextInvNo = "22/IT_001";
              }

              Invoice? newInvoice = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => BlocProvider(
                          create: (bctx) => InvoiceBloc(
                              invoice: Invoice(
                                  nextInvNo, DateTime.now(), 0, newCst, [])),
                          child: const InvoiceDetailPage())));

              bloc.add(HomeUpdateInvoices());
            },
            child: const Icon(Icons.add)),
        body: RefreshIndicator(
          onRefresh: () async {
            debugPrint("REFRESH");
            bloc.add(HomeUpdateInvoices());
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              wid({required Widget child}) =>
                  state is! HomeLoaded || (state.invoices.isEmpty)
                      ? LayoutBuilder(builder: (context, c) {
                          return Container(
                            constraints: BoxConstraints(minHeight: c.maxHeight),
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: child,
                            ),
                          );
                        })
                      : SizedBox(child: child);
              debugPrint("W: ${state is! HomeLoaded}");
              return wid(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error loading invoices. Please try again.', // Changed to generic message
                            style: TextStyle(color: theme.colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (state is HomeLoaded) {
                      if (state.invoices.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  size: 80, color: theme.colorScheme.secondary),
                              const SizedBox(height: 16),
                              Text(
                                "No invoices yet",
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap the '+' button to add your first invoice.",
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: state.invoices.length,
                          itemBuilder: (ctx, i) {
                            final inv = state.invoices[i];
                            return GestureDetector(
                                child: _InvoiceCard(
                                  invoice: inv,
                                  // onSave: () => _saveInvoice(inv),
                                  onSave: () => _printInvoice(inv),
                                  onShare: () => _shareInvoicePdf(inv),
                                  onDelete: () => _removeInvoice(inv),
                                ),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => BlocProvider(
                                              create: (bctx) =>
                                                  InvoiceBloc(invoice: inv),
                                              child:
                                                  const InvoiceDetailPage())));
                                  bloc.add(HomeGetInvoices());
                                });
                          });
                    }
                    return const Center(child: Text("Loading invoices..."));
                  },
                ),
              );
            },
          ),
        ));
  }

  Future<void> _saveInvoice(Invoice inv) async {
    if (!await _requestStoragePermission()) return;

    try {
      final pdf =
          InvoicePdf(config: InvoiceConfig(user: User.ex2), invoice: inv);
      final path = await getAppPath();
      final fileName =
          "${inv.customer.name.replaceAll(' ', '_')}${DateFormat("_dd_MM_yyyy_HHmmss").format(DateTime.now())}.pdf";
      final filePath = "$path/$fileName";

      pdf.save(filePath); // Removed await here

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invoice saved to $filePath")));
    } catch (e) {
      log("Error saving invoice: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving invoice: $e")));
    }
  }

  Future<void> _printInvoice(Invoice inv) async {
    if (!await _requestStoragePermission()) return;

    try {
      final pdf =
          InvoicePdf(config: InvoiceConfig(user: User.ex2), invoice: inv);
      final path = await getAppPath();
      final fileName =
          "${inv.customer.name.replaceAll(' ', '_')}${DateFormat("_dd_MM_yyyy_HHmmss").format(DateTime.now())}.pdf";
      final filePath = "$path/$fileName";

      final pdfBytes = pdf.getPdfUint();

      await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invoice saved to $filePath")));
    } catch (e) {
      log("Error saving invoice: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving invoice: $e")));
    }
  }

  Future<void> _shareInvoicePdf(Invoice inv) async {
    if (!await _requestStoragePermission()) return;

    try {
      final tmpDir = await getApplicationCacheDirectory();
      final fileName =
          "${inv.customer.name.replaceAll(' ', '_')}${DateFormat("_dd_MM_yyyy_HHmmss").format(DateTime.now())}.pdf";
      final filePath = "${tmpDir.path}/$fileName";

      final pdf =
          InvoicePdf(config: InvoiceConfig(user: User.ex2), invoice: inv);
      final data = await pdf.getPdfUint();
      final file = File(filePath);
      await file.writeAsBytes(data);

      if (await file.exists()) {
        final xFile = XFile(filePath);
        final result =
            await Share.shareXFiles([xFile], text: 'Invoice ${inv.invoiceNo}');
        log('Share result: ${result.status}');
      } else {
        throw Exception("Failed to create file for sharing.");
      }
    } catch (e) {
      log("Error sharing invoice: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error sharing invoice: $e")));
    }
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Storage permission is permanently denied. Please enable it in settings."),
        duration: Duration(seconds: 5),
      ));
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied.")));
      return false;
    }
  }

  void _removeInvoice(Invoice inv) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Invoice?'),
          content: Text('Are you sure you want to delete invoice #${inv.key}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                bloc.add(HomeRemoveInvoice(inv));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invoice #${inv.key} deleted.')));
              },
            ),
          ],
        );
      },
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const _InvoiceCard({
    required this.invoice,
    required this.onSave,
    required this.onShare,
    required this.onDelete,
  });

  String _invCardDate(DateTime dt) {
    final df = DateFormat("dd MMM yy");
    return df.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.customer.name,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: Text(
                          "Sale",
                          style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "#${invoice.key}",
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _invCardDate(invoice.date),
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildAmountColumn(context, "Total", invoice.getTotal()),
                    const SizedBox(width: 16),
                    _buildAmountColumn(
                        context, "Received", invoice.getReceivedAmount()),
                  ],
                ),
                Row(
                  children: [
                    _buildIconButton(context, Icons.print_outlined, onSave),
                    _buildIconButton(context, Icons.share_outlined, onShare),
                    PopupMenuButton<int>(
                      onSelected: (value) {
                        if (value == 1) onDelete();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 1, child: Text("Delete")),
                      ],
                      icon: Icon(Icons.more_vert_outlined,
                          color: colorScheme.onSurfaceVariant),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: "More options",
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

  Widget _buildAmountColumn(BuildContext context, String label, double amount) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          sAmount(amount),
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
      splashRadius: 20,
      tooltip: icon == Icons.print_outlined
          ? 'Save PDF'
          : (icon == Icons.share_outlined ? 'Share PDF' : null),
    );
  }
}

Future<String> getAppPath() async {
  if (Platform.isAndroid) {
    Directory? downloadsDir = await getExternalStorageDirectory();
    return downloadsDir?.path ??
        (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isIOS) {
    return (await getApplicationDocumentsDirectory()).path;
  } else {
    return (await getApplicationDocumentsDirectory()).path;
  }
}
