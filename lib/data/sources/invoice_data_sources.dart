import 'dart:convert';

import 'package:invoice_bloc/core/_models/invoice.dart';

const dataStr = """"invoices": [
    {
      "invId": 2,
      "invoiceNo": "SR/24-25/0002",
      "customer": {
        "cId": 2,
        "name": "Harshaditya Singh Jadeja",
        "address": "8, Adarsh Society, Hospital Road, Bhuj, Kutch - 370001",
        "phone": "9601117957",
        "email": "",
        "gstin": "",
        "bankInfo": null
      },
      "date": "2024-01-06T14:34:46.670405",
      "items": [
        {
          "product": {
            "pid": 1,
            "name": "100% Cotton Tshirt",
            "unitPrice": 165.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 89
        },
        {
          "product": {
            "pid": 2,
            "name": "Sweat Shirt",
            "unitPrice": 300.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 41
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 5,
      "invoiceNo": "SR/24-25/0005",
      "customer": {
        "cId": 2,
        "name": "Harshaditya Singh Jadeja",
        "address": "8, Adarsh Society, Hospital Road, Bhuj, Kutch - 370001",
        "phone": "9601117957",
        "email": "",
        "gstin": "",
        "bankInfo": null
      },
      "date": "2024-01-26T15:14:57.357743",
      "items": [
        {
          "product": {
            "pid": 2,
            "name": "Sweat Shirt",
            "unitPrice": 300.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 2
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 6,
      "invoiceNo": "SR/24-25/0006",
      "customer": {
        "cId": 2,
        "name": "Hc ricarshaditya Singh Jadeja",
        "address": "8, Adarsh Society, Hospital Road, Bhuj, Kutch - 370001",
        "phone": "9601117957",
        "email": "",
        "gstin": "",
        "bankInfo": null
      },
      "date": "2024-01-26T15:22:10.767550",
      "items": [],
      "receivedAmt": 0.0
    },
    {
      "invId": 7,
      "invoiceNo": "SR/24-25/0007",
      "customer": {
        "cId": 3,
        "name": "FORTIFY CONSULTS",
        "address": "B 100, Jaldhara Twin Bunglows, Near Bopal Gram Panchayat, Bopal, Ahmedabad 380058",
        "phone": "9979889393",
        "email": "",
        "gstin": "24AGRPA8267A1ZJ",
        "bankInfo": null
      },
      "date": "2024-01-26T16:16:11.648990",
      "items": [
        {
          "product": {
            "pid": 3,
            "name": "Dry Fit Tshirt",
            "unitPrice": 90.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": 6109
          },
          "quantities": 2499
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 5,
      "invoiceNo": "SR/24-25/0005",
      "customer": {
        "cId": 4,
        "name": "Nirma University ",
        "address": "",
        "phone": "6351116379",
        "email": "",
        "gstin": "",
        "bankInfo": null
      },
      "date": "2024-01-27T17:29:26.270704",
      "items": [
        {
          "product": {
            "pid": 1,
            "name": "100% Cotton Tshirt",
            "unitPrice": 165.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 1
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 6,
      "invoiceNo": "SR/24-25/0006",
      "customer": {
        "cId": 4,
        "name": "Nirma University ",
        "address": "Nirma University, Sarkhej - Gandhinagar Hwy, Gota, Ahmedabad, Gujarat 382481",
        "phone": "6351116379",
        "email": "",
        "gstin": "24AAATT6829N1ZY",
        "bankInfo": null
      },
      "date": "2024-01-27T17:39:37.280372",
      "items": [
        {
          "product": {
            "pid": 4,
            "name": "White Hoodie",
            "unitPrice": 430.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": 6109
          },
          "quantities": 23
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 7,
      "invoiceNo": "SR/24-25/0007",
      "customer": {
        "cId": 5,
        "name": "Satya Sai Transport",
        "address": "RRL- VF DC\nW, Sumar Logistics and Industrial Park,\nNH-8, Ahead of Coca-Cola Factory,\nBetdilat, Hariyala, Kheda, Gujarat 387411",
        "phone": "9898604901",
        "email": "",
        "gstin": "24AGFPG9845A1ZN",
        "bankInfo": null
      },
      "date": "2024-02-10T13:39:39.754910",
      "items": [
        {
          "product": {
            "pid": 2,
            "name": "Sweat Shirt",
            "unitPrice": 300.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 3
        }
      ],
      "receivedAmt": 0.0
    },
    {
      "invId": 8,
      "invoiceNo": "SR/24-25/0008",
      "customer": {
        "cId": 5,
        "name": "Satya Sai Transport",
        "address": "RRL- VF DC\nW, Sumar Logistics and Industrial Park,\nNH-8, Ahead of Coca-Cola Factory,\nBetdilat, Hariyala, Kheda, Gujarat 387411",
        "phone": "9898604901",
        "email": "",
        "gstin": "24AGFPG9845A1ZN",
        "bankInfo": null
      },
      "date": "2024-02-10T13:47:06.989527",
      "items": [
        {
          "product": {
            "pid": 5,
            "name": "Polo Tshirt Loopknit ",
            "unitPrice": 230.0,
            "gstType": "gst_5",
            "unit": "Pcs",
            "hsc": null
          },
          "quantities": 300
        }
      ],
      "receivedAmt": 0.0
    }
  ]""";

List<Invoice> getInvoices() {
  var d = jsonDecode(dataStr);
  // return (d['invoices'] as List).map((e) => Invoice.fromJson(e)).toList();
  return [];
}
