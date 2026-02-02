import "package:flutter/material.dart";
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import "../models/inventory_item.dart";

///Manages the list of items and notifies the UI when data changes
class InventoryProvider extends ChangeNotifier{

///The data table
  List<InventoryItems> _items = [];

///Allows other files to read the list without changing it directly
  List<InventoryItems> get items => List.unmodifiable(_items);

//Save to disk
  Future <void> _saveToDisk() async{
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(_items.map((i) => i.toMap()).toList());
    await prefs.setString('inventory_data', encodedData); 
  }

  //Load from disk
  Future<void> loadData() async{
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('inventory_data');

    if (savedData != null){
      final List<dynamic> decodedData = jsonDecode(savedData);
      _items = decodedData.map((itemMap) => InventoryItems.fromMap(itemMap)).toList();
      notifyListeners();
    }
  }

//Adds a new item and tells UI to refresh
  void addItem(InventoryItems item){
    _items.add(item);

//This updates the screen
    notifyListeners();
    _saveToDisk(); //Triggers save after adding
  }

  void removeItem(String id) {
//Target the private list directly
    _items.removeWhere((item) => item.id == id);
// Broadcast the change to the UI
    notifyListeners();
    _saveToDisk(); //Triggers save after removing
  }

///Calculates the total value
  double get totalInventoryValue{
    return _items.fold(0, (sum, item) => sum + item.totalValue);
  }
}

