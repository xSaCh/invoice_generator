import 'dart:io';

import 'package:flutter/services.dart';
import 'package:invoice_bloc/core/invoice_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/user.dart';

class InvoiceConfig {
  final User user;
  String? signImgPath;
  String? upiImgPath;

  InvoiceConfig({required this.user, this.signImgPath, this.upiImgPath});
}

class InvoicePdf {
  final InvoiceConfig config;
  final bool isOriginal;
  final Invoice invoice;

  MemoryImage? _signImg;
  MemoryImage? _upiImg;

  InvoicePdf({required this.config, required this.invoice, this.isOriginal = true});

  Future<Uint8List> getPdfUint() async {
    final pdf = Document(
        theme: ThemeData.withFont(
            base: Font.ttf(await rootBundle.load("fonts/ARIAL.TTF")),
            bold: Font.ttf(await rootBundle.load("fonts/ARIALBD.TTF"))));

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => _multiPage(),
      margin: const EdgeInsets.symmetric(
          horizontal: 1.268 * PdfPageFormat.cm, vertical: 2.14 * PdfPageFormat.cm),
    )); // Page
    return pdf.save();
  }

  void save(String path) async {
    // _signImg = MemoryImage(File("fonts/plc.png").readAsBytesSync());
    // _upiImg = MemoryImage(File("fonts/plc.png").readAsBytesSync());

    final pdf = Document(
        theme: ThemeData.withFont(
            base: Font.ttf(await rootBundle.load("fonts/ARIAL.TTF")),
            bold: Font.ttf(await rootBundle.load("fonts/ARIALBD.TTF"))));

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => _multiPage(),
      margin: const EdgeInsets.symmetric(
          horizontal: 1.268 * PdfPageFormat.cm, vertical: 2.14 * PdfPageFormat.cm),
    )); // Page
    File f = File(path);
    f.writeAsBytesSync(await pdf.save());
  }

  List<Widget> _multiPage() {
    return [
      _headerSec(),
      SizedBox(height: 20),
      Center(
        child: Text(
          "Tax Invoice",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      _invoiceDetailSec(),
      SizedBox(height: 15),
      _itemTable(),
      SizedBox(height: 10),
      _amountSec(),
      SizedBox(height: 20),
      _paymentSec(),
    ];
  }

  Widget _page() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerSec(),
        SizedBox(height: 20),
        Center(
          child: Text(
            "Tax Invoice",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        _invoiceDetailSec(),
        SizedBox(height: 15),
        _itemTable(),
        SizedBox(height: 10),
        _amountSec(),
        SizedBox(height: 20),
        _paymentSec(),
      ],
    );
  }

  Row _headerSec() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.user.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 230,
                child: _pText(config.user.address),
              ),
              // SizedBox(height: 1),
              // _pText("Kathwada GIDC, Ahmedabad, 382430"),
              SizedBox(height: 3),
              _lblText("Phone: ", "+91 ${config.user.phone}"),
              SizedBox(height: 1),
              _lblText("Email: ", config.user.email),
              SizedBox(height: 1),
              // _pText("GSTIN: ${config.user.gstin}"),
              _lblText("GSTIN: ", config.user.gstin),
              SizedBox(height: 1),
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_lblText(isOriginal ? "Original" : "Duplicate", "")])
        ]);
  }

  Row _invoiceDetailSec() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Bill To: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 5),
        Text(
          invoice.customer.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 5),
        if (invoice.customer.address != '')
          Container(
            width: 170,
            child: _pText(invoice.customer.address),
          ),
        SizedBox(height: 1),
        // pText("Kathwada, Ahmedabad, 382350"),
        _pText(""),
        SizedBox(height: 4),
        _pText("Contact No: +91 ${invoice.customer.phone}"),
        SizedBox(height: 1),
        // pText("GSTIN: 1234567890"),
        if (invoice.customer.gstin != '') _pText("GSTIN: ${invoice.customer.gstin}"),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          "Invoice No: ${invoice.invoiceNo}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 5),
        Text(
          "Date: ${sDate(invoice.date)}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 5),
      ]),
    ]);
  }

  Table _itemTable() {
    return TableHelper.fromTextArray(
        border: TableBorder.all(width: 0.6),
        // border: null,
        columnWidths: const {
          0: IntrinsicColumnWidth(flex: 1),
          1: IntrinsicColumnWidth(flex: 6),
          2: IntrinsicColumnWidth(flex: 1.5),
          3: IntrinsicColumnWidth(flex: 2),
          4: IntrinsicColumnWidth(flex: 1),
          5: IntrinsicColumnWidth(flex: 2),
          6: IntrinsicColumnWidth(flex: 2.4),
          7: IntrinsicColumnWidth(flex: 2.4),
        },
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        // headerCellDecoration: const BoxDecoration(color: PdfColors.grey),
        // cellDecoration: (index, data, rowNum) {
        //   return const BoxDecoration(color: PdfColors.grey300);
        // },
        headerAlignment: Alignment.centerLeft,
        cellStyle: const TextStyle(fontSize: 10),
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerLeft,
          2: Alignment.centerLeft,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
          5: Alignment.centerRight,
          6: Alignment.centerRight,
          7: Alignment.centerRight,
        },
        data: [
          ['#', 'Item Name', 'HSN', 'Quantity', 'Unit', 'Price/ unit', 'GST', 'Amount'],
          ...sItemList(invoice.items),
        ]);
  }

  Row _amountSec() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spacer(flex: 6),
          Expanded(
              flex: 10,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // color: PdfColors.amber50,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        width: double.infinity,
                        child: Text("INVOICE AMOUNT IN WORDS ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    Container(
                        color: PdfColors.grey50,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        width: double.infinity,
                        child: Text(sAmountWord(invoice.getTotal().floor()),
                            style: const TextStyle(fontSize: 11))),
                    SizedBox(height: 8),
                    Container(
                        // color: PdfColors.amber50,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        width: double.infinity,
                        child: Text("TERMS AND CONDITIONS",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    Container(
                        color: PdfColors.grey50,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        width: double.infinity,
                        // child: Text("Thirty One Thousand Two Hundred Rupees only",
                        //     style: const TextStyle(fontSize: 11))),
                        child: Text("", style: const TextStyle(fontSize: 11))),
                  ])),
          Spacer(flex: 1),
          Expanded(
              flex: 10,
              child: Container(
                  // color: PdfColors.amber200,
                  child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _pText("Sub Total: "),
                  _pText(sAmount(invoice.getSubTotal())),
                ]),
                ..._gstAmtInfo(),
                Divider(thickness: 1),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Total ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(sAmount(invoice.getTotal()),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
                SizedBox(height: 2),
              ])))
        ]);
  }

  Row _paymentSec() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_upiImg == null)
            Container(width: 100, height: 100, color: PdfColors.white)
          else
            Image(_upiImg!, width: 100, height: 100, fit: BoxFit.contain),
          Container(
              width: 180,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Pay To: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                SizedBox(height: 5),
                _lblText("Bank Name: ", config.user.bankInfo.bankName),
                SizedBox(height: 6),
                _lblText("Account Holder: ", config.user.bankInfo.holderName),
                SizedBox(height: 6),
                _lblText("Bank Account No: ", config.user.bankInfo.accountNo),
                SizedBox(height: 6),
                _lblText("IFSC code: ", config.user.bankInfo.ifscCode),
                SizedBox(height: 6),
              ])),
          Container(
            constraints: const BoxConstraints(maxWidth: 140),
            // width: 130,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("For, ${config.user.name}"),
              SizedBox(height: 10),
              if (_signImg == null)
                Container(width: 120, height: 40, color: PdfColors.white)
              else
                Image(_signImg!, width: 100, height: 100, fit: BoxFit.contain),
              SizedBox(height: 6),
              Text("Authorized Signature"),
            ]),
          )
        ]);
  }

  List<Widget> _gstAmtInfo() {
    List<Widget> l = [];
    invoice.getGstTotals().forEach((key, value) {
      if (!key.name.contains("igst")) {
        l.add(SizedBox(height: 2));
        l.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _pText(sGstWord(key, isCgst: true)),
          _pText(sAmount(value / 2)),
        ]));
      }

      l.add(SizedBox(height: 2));
      l.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _pText(sGstWord(key)),
        _pText(sAmount(value / 2)),
      ]));
    });
    return l;
  }
}

Widget _lblText(String lbl, String txt) {
  return RichText(
      text: TextSpan(
          text: lbl,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          children: [
        TextSpan(text: txt, style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal))
      ]));
}

Widget _pText(String txt) {
  return Text(
    txt,
    style: const TextStyle(fontSize: 10),
  );
}
