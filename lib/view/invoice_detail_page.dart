// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:invoice_bloc/bloc/Invoice/invoice_bloc.dart';
// import 'package:invoice_bloc/db/db.dart';
import 'package:invoice_bloc/core/invoice_helper.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/global.dart';
import 'package:invoice_bloc/view/item_page.dart';
// import 'package:invoice_bloc/pages/item_page.dart';

class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({super.key});

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  late InvoiceBloc bloc;
  var isItemVisible = true;
  var isRecevied = false;
  var rcvTxtCnt = TextEditingController();
  var dueTxtCnt = TextEditingController();
  var custTxtCnt = TextEditingController();
  var totalTxtCnt = TextEditingController();
  var invoiceDate = "";
  var items = <Item>[];

  @override
  void initState() {
    bloc = BlocProvider.of<InvoiceBloc>(context);

    items = bloc.invoice.items;
    rcvTxtCnt.text = bloc.invoice.receivedAmt.toString();
    custTxtCnt.text = bloc.invoice.customer.name;
    totalTxtCnt.text = sAmount(bloc.invoice.getTotal());
    invoiceDate = sDate(bloc.invoice.date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (bloc.invoice.customer.name != custTxtCnt.text) return;

                Navigator.of(context).pop(bloc.invoice);
                inspect(bloc.invoice);
              },
              icon: Icon(Icons.check_rounded))
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        // listener: (context, state) {
        //   if(state is Invoice){

        //   }
        // },
        listenWhen: (previous, current) => current is InvoiceUpdated,
        listener: (context, state) {
          rcvTxtCnt.text = bloc.invoice.receivedAmt.toString();
          custTxtCnt.text = bloc.invoice.customer.name;
          totalTxtCnt.text = sAmount(bloc.invoice.getTotal());
          dueTxtCnt.text = (bloc.invoice.getTotal() - bloc.invoice.getReceivedAmount())
              .toStringAsFixed(2);

          debugPrint("lister call ${sAmount(bloc.invoice.getTotal())}");
        },
        buildWhen: (previous, current) {
          return current is InvoiceUpdated || current is InvoiceError;
        },
        builder: (context, state) {
          if (state is InvoiceError) {
            return const Center(child: Text("ERROR"));
          }
          return SingleChildScrollView(
              child: Column(
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: _headerSection(),
                ),
              ),
              SizedBox(height: 12),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: _midSection(),
                ),
              ),
            ],
          ));
        },
      ),
    );
  }

  Widget _headerSection() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invoice No."),
                Text(bloc.invoice.invoiceNo),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: Colors.grey,
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date"),
                GestureDetector(
                  onTap: () => _pickInvoiceDate(context),
                  child: Text(invoiceDate),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _midSection() {
    //TODO: Fix Disabled Textfield color with row or other
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Part Balance: 90,9840.00",
              style: TextStyle(fontSize: 12, color: Colors.green),
              textAlign: TextAlign.end,
            )
          ],
        ),
        SizedBox(height: 2),
        // TextFormField(
        //   controller: custTxtCnt,
        //   decoration: InputDecoration(
        //       border: OutlineInputBorder(),
        //       contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        //       labelText: "Customer Name",
        //       errorText: custTxtCnt.text != bloc.invoice.customer.name ? "No Customer Found" : null),
        //   onChanged: (e) => setState(() {
        //     debugPrint(e);
        //   }),
        // ),
        _suggestionCstTxtField(),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              isItemVisible = !isItemVisible;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.blueAccent,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Billed Items",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  Icon(
                      isItemVisible
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: Colors.white)
                ],
              )),
        ),
        if (isItemVisible) _itemsSection(),
        SizedBox(height: 16),
        _amountSection()
      ],
    );
  }

  Widget _amountSection() {
    if (bloc.invoice.items.isEmpty) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Total Amount"),
        SizedBox(
            width: 120,
            child: TextFormField(
              initialValue: sAmount(0),
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 25,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none),
              textAlign: TextAlign.end,
              textAlignVertical: TextAlignVertical.center,
            ))
      ]);
    }
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Total Amount"),
          SizedBox(
              width: 120,
              child: TextFormField(
                controller: totalTxtCnt,
                enabled: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_rounded),
                    prefixIconConstraints: BoxConstraints(
                      minHeight: 25,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none),
                textAlign: TextAlign.end,
                textAlignVertical: TextAlignVertical.center,
              ))
        ]),
        SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Subtotal", style: TextStyle(fontSize: 12)),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: sAmount(bloc.invoice.getSubTotal()),
                      enabled: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money_rounded, size: 14),
                          prefixIconConstraints: BoxConstraints(minHeight: 22),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12),
                      textAlignVertical: TextAlignVertical.center,
                    ))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Total GST", style: TextStyle(fontSize: 12)),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: sAmount(bloc.invoice.getGstTotal()),
                      enabled: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money_rounded, size: 14),
                          prefixIconConstraints: BoxConstraints(minHeight: 22),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12),
                      textAlignVertical: TextAlignVertical.center,
                    ))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Discount", style: TextStyle(fontSize: 12)),
                SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: "0",
                      enabled: false,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money_rounded, size: 14),
                          prefixIconConstraints: BoxConstraints(minHeight: 22),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 12),
                      textAlignVertical: TextAlignVertical.center,
                    ))
              ]),
            ],
          ),
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox.adaptive(
                      value: isRecevied,
                      onChanged: (val) => setState(() => isRecevied = !isRecevied)),
                ),
                SizedBox(width: 10),
                Text("Received")
              ],
            ),
            SizedBox(
                width: 120,
                child: TextFormField(
                  controller: rcvTxtCnt,
                  onChanged: (e) {
                    double? d = double.tryParse(e);
                    if (d != null) bloc.add(InvoiceUpdateInvoiceValue(receivedAmt: d));
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money_rounded),
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 25,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  textAlign: TextAlign.end,
                  textAlignVertical: TextAlignVertical.center,
                ))
          ],
        ),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Balance Due"),
            SizedBox(
                width: 120,
                child: TextFormField(
                  controller: dueTxtCnt,
                  enabled: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money_rounded),
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 25,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  textAlign: TextAlign.end,
                  textAlignVertical: TextAlignVertical.center,
                ))
          ],
        ),
      ],
    );
  }

  Widget _itemsSection() {
    return Column(
      children: [
        ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) {
              return GestureDetector(
                onTap: () async {
                  Item? newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => ItemPage(items[i])));
                  if (newItem != null) {
                    bloc.add(InvoiceUpdateItem(i, newItem));
                  }
                },
                child: _itemCard(items[i]),
              );
            }),
        OutlinedButton(
            onPressed: () async {
              Item? newItem = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ItemPage(Item(Product.empty()))));
              if (newItem != null) {
                bloc.add(InvoiceAddItem(newItem));
              }
            },
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_outlined),
                SizedBox(width: 4),
                Text("Add Item")
              ],
            ))
      ],
    );
  }

  Card _itemCard(Item item) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.symmetric(vertical: 4),
        color: Colors.grey.shade200,
        child: Column(
          children: [
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(item.product.name, overflow: TextOverflow.fade)),
                Text(sAmount(item.getAmount()))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Item Subtotal",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text(
                    "${item.quantities} ${item.product.unit.toString().split('.')[1]} x ${item.product.unitPrice} = ${sAmount(item.getSubAmount())}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700))
              ]),
            ),
            //TODO: Add Discount support
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Discount", style: TextStyle(fontSize: 12, color: Colors.orange)),
                Text("\$ 0", style: TextStyle(fontSize: 12, color: Colors.orange))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(sGstWord(item.product.gstType, sepCSgst: false),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text(sAmount(item.getGstAmount()),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700))
              ]),
            ),
            SizedBox(height: 4),
          ],
        ));
  }

  Widget _suggestionCstTxtField() {
    // final customers = Db.ins().customers;
    final customers = Global.ins().customerRepository.getCustomers();

    return TypeAheadField<Customer>(
      suggestionsCallback: (search) {
        var iter =
            customers.where((c) => c.name.toLowerCase().contains(search.toLowerCase()));
        return iter.toList();
      },
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              labelText: "Customer Name",
              errorText: custTxtCnt.text != bloc.invoice.customer.name
                  ? "No Customer Found"
                  : null),
        );
      },
      itemBuilder: (context, customer) {
        return ListTile(
          title: Text(customer.name),
          subtitle: Text(customer.phone),
        );
      },
      onSelected: (customer) {
        //TODO: Return selected Customer
        custTxtCnt.text = customer.name;
        bloc.add(InvoiceUpdateInvoiceValue(customer: customer));
      },
      controller: custTxtCnt,
    );
  }

  void _pickInvoiceDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(DateTime.now().year + 100));

    if (pickedDate != null) {
      invoiceDate = sDate(pickedDate);
      bloc.add(InvoiceUpdateInvoiceValue(date: pickedDate));
    }
  }
}
