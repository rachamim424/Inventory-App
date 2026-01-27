import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/inventory_item.dart";
import "../logic/inventory_provider.dart";

class InventoryScreen extends StatelessWidget{
 const InventoryScreen({super.key});

  @override
 Widget build(BuildContext context){
///Listens to the provider here. When the list changes, the builder runs again
  final inventory = context.watch<InventoryProvider>();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Inventory App'), 
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [

///Totals Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Value:', style: TextStyle(fontSize: 18, 
                fontWeight: FontWeight.bold),),
                Text('#${inventory.totalInventoryValue.toStringAsFixed(2)}', 
                style: TextStyle(fontSize: 18, color: Colors.green, 
                fontWeight: FontWeight.bold, ),),
              ]
            ),
            ),
          ),

          Expanded(
            child: inventory.items.isEmpty? 
            const Center(child: Text('No items in vault yet.'))
            : ListView.builder(
              itemCount: inventory.items.length,
              itemBuilder: (context, index){
                final item = inventory.items[index];
              return ListTile(
                leading: CircleAvatar(child: Text(item.name[0])),
                title: Text(item.name),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: Text('#${item.price.toStringAsFixed(2)}')
              );
              }
            )
          ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddItemDialog(context),
          child: const Icon(Icons.add),
        ),
    );
 }
}

///Defining a function to collect input from user
void _showAddItemDialog(BuildContext context){
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

//Pop up for add item
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add New Item'),
      content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item name')),
          TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType:TextInputType.number),
          TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number), 
        ]
      ),
      ),

     actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'),),
      ElevatedButton(onPressed: (){

//Create the new item model
        final newItem = InventoryItems(
          id: DateTime.now().toString(),
          name: nameController.text,
          quantity: int.tryParse(qtyController.text) ?? 0,
          price: double.tryParse(priceController.text) ?? 0.0,
        );

//Send to brain
        context.read<InventoryProvider>().addItem(newItem);
        Navigator.pop(context);
      },
      child: const Text('Add to Vault'),
      ),
     ], 
    ),
  );
}