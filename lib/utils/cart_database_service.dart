import 'package:ecom/features/cart/model/cart_item_model.dart';
import 'package:ecom/features/product_list/model/product_model.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database == null) {
      final databasePath = await getDatabasesPath();
      final path = '$databasePath/ecom_cart.db';

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE cart(
              product_id INTEGER PRIMARY KEY,
              title TEXT,
              slug TEXT,
              price INTEGER,
              description TEXT,
              category_id INTEGER,
              category_name TEXT,
              category_slug TEXT,
              category_image TEXT,
              images TEXT,
              image TEXT,
              quantity INTEGER
            )
          ''');
        },
      );
    }

    return _database!;
  }

  static Future<List<CartItemModel>> getCartItems() async {
    final db = await database;
    final cartData = await db.query('cart');

    return cartData.map((item) => CartItemModel.fromMap(item)).toList();
  }

  static Future<void> addToCart(ProductModel product) async {
    final db = await database;
    final cartData = await db.query(
      'cart',
      where: 'product_id = ?',
      whereArgs: [product.id],
    );

    if (cartData.isNotEmpty) {
      final quantity = (cartData.first['quantity'] as int) + 1;
      await updateQuantity(product.id, quantity);
      return;
    }

    await db.insert(
      'cart',
      CartItemModel(product: product, quantity: 1).toMap(),
    );
  }

  static Future<void> updateQuantity(int productId, int quantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  static Future<void> deleteItem(int productId) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }
}
