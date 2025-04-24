import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/item.dart';

class ProductRepository {
  late Box<Product> box;

  ProductRepository() {
    box = Hive.box<Product>('products');
  }
  List<Product> getProducts() {
    return box.values.toList().cast<Product>();
  }

  Product? getProduct(int key) {
    return box.get(key);
  }

  void addProduct(Product p) {
    box.add(p);
  }

  void removeProduct(int key) {
    box.delete(key);
  }
}
