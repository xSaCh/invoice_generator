// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:invoice_bloc/core/invoice_helper.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';

class ItemPage extends StatefulWidget {
  final Item item;
  const ItemPage(this.item, {super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  // GSTType gstT = GSTType.gst_5;
  late Item newItem;
  late Unit un;
  var taxTxtCtn = TextEditingController();
  var itmTxtCtn = TextEditingController();
  var qtyTxtCtn = TextEditingController();
  var rateTxtCtn = TextEditingController();
  var hscTxtCtn = TextEditingController();

  @override
  void initState() {
    super.initState();

    newItem = widget.item;
  }

  void initCont() {
    un = newItem.product.unit;

    taxTxtCtn.text = newItem.getGstAmount().toStringAsFixed(2);
    itmTxtCtn.text = newItem.product.name;
    qtyTxtCtn.text = newItem.quantities.toString();
    rateTxtCtn.text = newItem.product.unitPrice.toString();
    hscTxtCtn.text = newItem.product.hsc.toString();
  }

  @override
  Widget build(BuildContext context) {
    // initItem();
    // initTxtCont();
    initCont();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item"),
        actions: [
          IconButton(
              onPressed: () {
                debugPrint(itmTxtCtn.text);
                debugPrint(taxTxtCtn.text);
                debugPrint(un.toString());
                inspect(newItem);

                Navigator.of(context).pop(newItem);
              },
              icon: Icon(Icons.check))
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              // TextFormField(
              //   controller: itmTxtCtn,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              //       labelText: "Item Name"),
              //   onChanged: (n) => newItem.product.name = n,
              // ),

              _suggestionCstTxtField(),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: qtyTxtCtn,
                      onChanged: (e) {
                        if (e != "") setState(() => newItem.quantities = int.parse(e));
                      },
                      // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]|[.]"))],
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          labelText: "Quantity"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "Unit"),
                        value: un,
                        items: Unit.values.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.toString().split(".")[1]),
                          );
                        }).toList(),
                        onChanged: (c) {
                          if (c == null) return;
                          un = c;
                          newItem.product.unit = c;
                        }),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: rateTxtCtn,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          labelText: "Rate (Price/Unit)"),
                      onChanged: (e) {
                        if (e != '') {
                          setState(() => newItem.product.unitPrice = double.parse(e!));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: hscTxtCtn,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          labelText: "HSC Code"),
                      onChanged: (e) {
                        if (e != "") newItem.product.hsc = int.parse(e);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("SubTotal"), Text(sAmount(newItem.getSubAmount()))],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discount"),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  suffixIcon: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.attach_money_rounded, size: 12)),
                                  suffixIconConstraints: BoxConstraints.tightForFinite(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
                              style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.percent_rounded, size: 12)),
                                  suffixIconConstraints: BoxConstraints.tightForFinite(),
                                  // contentPadding: EdgeInsets.zero,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
                              style: TextStyle(fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tax"),
                  SizedBox(width: 50),
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                              ),
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              value: newItem.product.gstType,
                              items: GSTType.values.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(sGstWord(e, sepCSgst: false)),
                                );
                              }).toList(),
                              onChanged: (c) {
                                if (c != null)
                                  setState(() => newItem.product.gstType = c);
                              }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                              controller: taxTxtCtn,
                              enabled: false,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.money_rounded, size: 12)),
                                  suffixIconConstraints: BoxConstraints.tightForFinite(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
                              style: TextStyle(fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    sAmount(newItem.getAmount()),
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _suggestionCstTxtField() {
    // final products = Db.ins().products;
    final products = [].cast<Product>();
    return TypeAheadField<Product>(
      suggestionsCallback: (search) {
        var iter =
            products.where((c) => c.name.toLowerCase().contains(search.toLowerCase()));
        return iter.toList();
      },
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            labelText: "Item Name",
          ),
          onChanged: (e) => newItem.product.name = e,
        );
      },
      itemBuilder: (context, product) {
        return ListTile(
          title: Text(product.name),
          subtitle: Text("${product.hsc}"),
        );
      },
      onSelected: (product) {
        debugPrint("Pata nahi kuch to copy karneka he");
        // setState(() {
        //   newItem.product = Product.copy(product);
        //   itmTxtCtn.text = product.name;
        // });
      },
      controller: itmTxtCtn,
    );
  }
}
