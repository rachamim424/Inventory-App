import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/inventory_item.dart";
import "../logic/inventory_provider.dart";

class InventoryScreen extends StatefulWidget{
 const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>{

//Search state variables
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

@override
 Widget build(BuildContext context){
///Listens to the provider here. When the list changes, the builder runs again
  final inventory = context.watch<InventoryProvider>();

//Filter logic
  final filteredItems = inventory.items.where((item){
    return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
  }).toList();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Inventory App'), 
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20), //Space below the bar

          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, //Limit width to 85% of screen
            height: 45, 
            
            child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0,2),
                ),
              ],
            ),//Sets slimmer height
          
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                border: InputBorder.none,
                isDense: true, //Removes the extra padding inside
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: _searchQuery.isNotEmpty?
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: (){
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
              ): null,
            ),
            onChanged: (value){
              setState((){_searchQuery = value;
              });
            },
          ),
        ),
       ),
      ),
      ),
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
            child: filteredItems.isEmpty? 
            Center(
              child: Text(
                _searchQuery.isEmpty?
                'No items in Vault yet':
                'No result for $_searchQuery'),
                )
            : ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index){
                final item = filteredItems[index];
              return Dismissible(
  //Essential for Flutter to track which item is being swiped
  key: Key(item.id),

  //The Background: What appears behind the row during the swipe
  direction: DismissDirection.endToStart, // Swipe right-to-left
  background: Container(
    color: Colors.redAccent,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),

  //The Action: What happens when the swipe completes
  onDismissed: (direction) {
//Keep a copy of item before it's gone
    final deletedItem = item;
    final provider = context.read<InventoryProvider>();
    // Remove it from the brain
    provider.removeItem(item.id);

//Show snakbar with an undo botton
     ScaffoldMessenger.of(context).clearSnackBars(); //Clears old bars immediately
    //Provide instant feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar( 
        content: 
          Text("${deletedItem.name} removed",
          ),
         action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.yellow,
          onPressed: (){
//Put it back if UNDO is tapped
            provider.addItem(deletedItem);
          }
          ),
         duration: const Duration(milliseconds:800), //Gives 0.8 secs to decide
         backgroundColor: Colors.black87,
         behavior: SnackBarBehavior.floating,//Makes it float above the bottom
         margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10), //Makes it smaller
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) //Rounded corners
      ),
    );
  },
  //ListTile
  child: ListTile(
    title: Text(item.name),
    subtitle: Text('Qty: ${item.quantity}'),
    trailing: Text('#${(item.price * item.quantity).toStringAsFixed(2)}'),

  //Makes the row clickable
  onTap: () {
    _showAddItemDialog(context, itemToEdit: item);
  }
  ),
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
void _showAddItemDialog(BuildContext context, {InventoryItems? itemToEdit}) {
  final nameController = TextEditingController(text: itemToEdit?.name?? '');
  final qtyController = TextEditingController(text: itemToEdit?.quantity.toString()?? '');
  final priceController = TextEditingController(text: itemToEdit?.price.toString()?? '');

//Pop up for add item
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(itemToEdit == null? 'Add New Item' : 'Edit ${itemToEdit.name}'),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min,
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
//If editing keep same id, if new, create one
          id: itemToEdit?.id?? DateTime.now().toString(),
          name: nameController.text,
          quantity: int.tryParse(qtyController.text) ?? 0,
          price: double.tryParse(priceController.text) ?? 0.0,
        );

        if (itemToEdit == null){
          context.read<InventoryProvider>().addItem(newItem);
        } else{
          context.read<InventoryProvider>().updateItem(newItem);
        }
        Navigator.pop(context);
      },
      child: Text(itemToEdit == null? 'Add to Vault' : 'Update Item'),
      ),
     ], 
    ),
  );
}