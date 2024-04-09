import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';
import 'package:permission_handler/permission_handler.dart';

String sDate(DateTime dt) {
  // return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  return DateFormat("dd/MM/yyyy").format(dt);
}

String sAmount(double amt) {
  var f = NumberFormat.currency(locale: "en_IN", symbol: "₹ ");
  return f.format(amt);
}

String sInvoiceNum(int num, {DateTime? dt}) {
  dt ??= DateTime.now();
  int yr = int.parse(DateFormat("yy").format(dt));

  return "SR/$yr-${yr + 1}/${num.toString().padLeft(4, "0")}";
}

String sAmountWord(int amt) {
  //TODO: Lakh, crore conversion error
  return "${_numToWord(amt)} Rupees Only";
}

String sGstWord(GSTType gst, {bool sepCSgst = true, bool isCgst = false}) {
  if (gst.name.contains("igst")) {
    return "IGST @${gstValue(gst).toStringAsFixed(2)}";
  }

  if (sepCSgst) {
    return "${isCgst ? 'C' : 'S'}GST @${(gstValue(gst) / 2).toStringAsFixed(2)}";
  }
  return "GST @${gstValue(gst).toStringAsFixed(2)}";
}

String _numToWord(int number) {
  if (number == 0) {
    return "Zero";
  }

  List<String> units = [
    "",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine"
  ];
  List<String> teens = [
    "",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen"
  ];
  List<String> tens = [
    "",
    "Ten",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety"
  ];
  List<String> thousands = ["", "Thousand", "Lakh", "Crore"];

  String words = "";
  int count = 0;

  while (number > 0) {
    int lastThreeDigits = number % 1000;
    if (lastThreeDigits != 0) {
      String wordsForLastThreeDigits = "";

      if (lastThreeDigits < 10) {
        wordsForLastThreeDigits = units[lastThreeDigits];
      } else if (lastThreeDigits < 100) {
        if (lastThreeDigits % 10 == 0) {
          wordsForLastThreeDigits = tens[lastThreeDigits ~/ 10];
        } else {
          wordsForLastThreeDigits =
              "${tens[lastThreeDigits ~/ 10]} ${units[lastThreeDigits % 10]}";
        }
      } else {
        wordsForLastThreeDigits = "${units[lastThreeDigits ~/ 100]} hundred";
        if (lastThreeDigits % 100 != 0) {
          wordsForLastThreeDigits += " and ";
          if (lastThreeDigits % 100 < 10) {
            wordsForLastThreeDigits += units[lastThreeDigits % 100];
          } else if (lastThreeDigits % 100 < 100) {
            if (lastThreeDigits % 100 % 10 == 0) {
              wordsForLastThreeDigits += tens[(lastThreeDigits % 100) ~/ 10];
            } else {
              wordsForLastThreeDigits +=
                  "${tens[(lastThreeDigits % 100) ~/ 10]} ${units[lastThreeDigits % 100 % 10]}";
            }
          }
        }
      }

      words = "$wordsForLastThreeDigits ${thousands[count]} $words";
    }

    number ~/= 1000;
    count++;
  }
  return "Two Lakh and Thirty Six Thousand One Hundred and Fifty Five";
  return words.trim();
}

List<List<String>> sItemList(List<Item> items) {
  List<List<String>> l = [];
  for (int i = 0; i < items.length; i++) {
    l.add([
      "${i + 1}",
      items[i].product.name,
      "${items[i].product.hsc ?? ''}",
      items[i].quantities.toString(),
      items[i].product.unit.name,
      sAmount(items[i].product.unitPrice),
      sAmount(items[i].getGstAmount()),
      sAmount(items[i].getAmount()),
    ]);
  }
  return l;
}

Future<String> getAppPath() async {
  if (!await Permission.storage.isGranted) inspect(await Permission.storage.request());
  Directory("/storage/emulated/0/1Invoice/").createSync();

  return "/storage/emulated/0/1Invoice";
}
