// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:invoice_bloc/bloc/Customer/customer_bloc.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/global.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late CustomerBloc bloc;

  var idTxtCnt = TextEditingController();
  var custTxtCnt = TextEditingController();
  var gstTxtCnt = TextEditingController();
  var noTxtCnt = TextEditingController();
  var emailTxtCnt = TextEditingController();
  var addrTxtCnt = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CustomerBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // var oldCst = Db.ins().getCustomer(int.parse(idTxtCnt.text));
                // // if(oldCst != null && oldCst.name == custTxtCnt.)

                // // if (oldCst! == Customer.ex) {}
                // var newCst = Customer(
                //     name: custTxtCnt.text,
                //     gstin: gstTxtCnt.text,
                //     phone: noTxtCnt.text,
                //     email: emailTxtCnt.text,
                //     address: addrTxtCnt.text);
                bloc.add(CustomerUpdateValue(
                    address: addrTxtCnt.text,
                    email: emailTxtCnt.text,
                    gstin: gstTxtCnt.text,
                    name: custTxtCnt.text,
                    phone: noTxtCnt.text));
                Navigator.of(context).pop(bloc.customer);
                // inspect(newCst);
              },
              icon: Icon(Icons.check_rounded))
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listenWhen: (previous, current) => current is CustomerUpdated,
        buildWhen: (previous, current) => current is CustomerUpdated,
        listener: (context, state) {
          idTxtCnt.text = "${bloc.customer.key}";
          custTxtCnt.text = bloc.customer.name;
          addrTxtCnt.text = bloc.customer.address;
          emailTxtCnt.text = bloc.customer.email;
          gstTxtCnt.text = bloc.customer.gstin;
          noTxtCnt.text = bloc.customer.phone;
        },
        builder: (context, state) {
          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: idTxtCnt,
                        enabled: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "Customer ID"),
                      ),
                      SizedBox(height: 16),
                      _suggestionCstTxtField(),
                      // TextFormField(
                      //   controller: custTxtCnt,
                      //   decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //       contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      //       labelText: "Customer Name *"),
                      // ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: gstTxtCnt,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "GSTIN"),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: noTxtCnt,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "Contact Number *"),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: emailTxtCnt,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "Email"),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: addrTxtCnt,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            labelText: "Address"),
                      ),
                      SizedBox(height: 16),
                    ],
                  ))
            ],
          ));
        },
      ),
    );
  }

  Widget _suggestionCstTxtField() {
    final customers = Global.ins().customerRepository.getCustomers();
    return TypeAheadField<Customer>(
      controller: custTxtCnt,
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
              labelText: "Customer Name *"),
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
        // setState(() {
        //   custTxtCnt.text = customer.name;
        //   gstTxtCnt.text = customer.gstin;
        //   noTxtCnt.text = customer.phone;
        //   emailTxtCnt.text = customer.email;
        //   addrTxtCnt.text = customer.address;
        // });
        bloc.add(CustomerChangeCustomer(customer));
      },
    );
  }
}
