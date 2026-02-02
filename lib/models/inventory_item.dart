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

//Convert InventoryItems into Map (to be in JSON)
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

//Creates an InventoryItem from a map when loading from storage
  factory InventoryItems.fromMap(Map<String, dynamic> map){
  return InventoryItems(
    id: map['id'],
    name: map['name'],
    quantity: map['quantity'],
    price: map['price'],
  );
  }
}