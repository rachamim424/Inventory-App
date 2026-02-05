import "package:flutter/material.dart";
import "../screens/inventory_screen.dart";
import "../screens/stats_screen.dart";

class MainWrapper extends StatefulWidget{
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

  class _MainWrapperState extends State<MainWrapper>{
    int _selectedIndex = 0;

///List of pages to toggle between
    final List<Widget> _pages = [
      const InventoryScreen(),
      const StatsScreen()
    ];

    @override
    Widget build(BuildContext context){
      return Scaffold(
          body: _pages[_selectedIndex], //Shows the current page based on index
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index){
              setState((){_selectedIndex = index; //Changes the page when tapped
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Vault',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
            ],
          ),
      );
    }
  }
