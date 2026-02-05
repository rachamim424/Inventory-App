import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../logic/inventory_provider.dart";


class StatsScreen extends StatelessWidget{
    const StatsScreen ({super.key});

@override
Widget build(BuildContext context){
     final inventory = context.watch<InventoryProvider>();

    return Scaffold(
        appBar: AppBar(
            title: const Text('Inventory Analytics'),
             centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
                _buildStatCard('Total Value', '#${inventory.totalInventoryValue.toStringAsFixed(2)}', Colors.green),
                const SizedBox(height: 10),
                _buildStatCard('Total Items', '${inventory.totalItemCount}', Colors.blue),
                const SizedBox(height: 10),
                _buildStatCard('Top Asset', inventory.mostExpensiveItem?.name?? 'N/A', Colors.orange),
            ]
        ),
        ),
    );
}

Widget _buildStatCard(String title, String value, Color color){
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color)
        ),
        child: Column(
            children: [
                Text(title, style: TextStyle(fontSize: 16, color: color,fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ]
        ),
    );
}
}