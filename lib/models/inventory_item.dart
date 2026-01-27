/// Represents a single product information
/// This is the data model
class InventoryItems{
  final String id;
  final String name;
  final int quantity;
  final double price;

InventoryItems({
  required this.id,
  required this.name,
  required this.quantity,
  required this.price,
});

///Calculates the total value of this stock item
double get totalValue => quantity * price;
}