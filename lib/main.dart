import "package:flutter/material.dart";
import "package:provider/provider.dart";

//This connects main files to the folders
import "../screens/inventory_screen.dart";
import "../logic/inventory_provider.dart";

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => InventoryProvider(),
      child: const EssentialsVaultApp(),
    ),
  );
}

class EssentialsVaultApp extends StatelessWidget{
  const EssentialsVaultApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Inventory App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,
      brightness: Brightness.light,),
      useMaterial3: true,
      ),
      home: const InventoryScreen(),
    );
  }
}