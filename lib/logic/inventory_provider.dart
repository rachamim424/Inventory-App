import "package:flutter/material.dart";
import "../models/inventory_item.dart";

///Manages the list of items and notifies the UI when data changes
class InventoryProvider extends ChangeNotifier{

///The data table
  final List<InventoryItems> _items = [];

///Allows other files to read the list without changing it directly
  List<InventoryItems> get items => List.unmodifiable(_items);

//Adds a new item and tells UI to refresh
  void addItem(InventoryItems item){
    _items.add(item);

//This updates the screen
    notifyListeners();
  }

///Calculates the total value
  double get totalInventoryValue{
    return _items.fold(0, (sum, item) => sum + item.totalValue);
  }
}

