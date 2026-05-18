import 'package:flutter/material.dart';
import 'package:zikar_e_falah/widgets/zikar_model.dart';
import 'package:zikar_e_falah/widgets/zikar_cards.dart';
import 'package:zikar_e_falah/counter_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // // [Color: Light Blue] Zikar List: App ka primary data store jo screen par display hota hai
  List<Zikar> myZikars = [
    Zikar(name: "سُبْحَانَ اللَّهِ", targetCount: 10),
    Zikar(name: "الْحَمْدُ لِلَّهِ", targetCount: 30),
    Zikar(name: "لَا إِلٰهَ إِلَّا اللَّهُ", targetCount: 20),
    Zikar(name: "اللَّهُ أَكْبَرُ", targetCount: 30),
    Zikar(name: "أَسْتَغْفِرُ اللَّهَ", targetCount: 10),
    Zikar(name: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", targetCount: 5),
    Zikar(name: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", targetCount: 15),
    Zikar(name: "صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ", targetCount: 20),
    Zikar(name: "سُبْحَانَ اللَّهِ الْعَظِيمِ", targetCount: 10),
  ];

  // // Controllers: Dialog boxes se user input capture karne ke liye
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  // // Function: Naya custom zikar list mein shamil karne ke liye dialog open karta hai
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEFEBE9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Add Custom Zikar",
          style: TextStyle(color: Color(0xFF4E342E), fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              textAlign: TextAlign.right, // // Arabic text ki behtar alignment ke liye
              decoration: const InputDecoration(
                labelText: "Zikar Name (عربی نام)",
                labelStyle: TextStyle(color: Color(0xFF8D6E63)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number, // // Target sirf numbers mein input lene ke liye
              decoration: const InputDecoration(
                labelText: "Target (ہدف)",
                labelStyle: TextStyle(color: Color(0xFF8D6E63)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.brown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D4C41)),
            onPressed: () {
              // // Validation check: Dono fields fill honi chahiye
              if (_nameController.text.isNotEmpty && _targetController.text.isNotEmpty) {
                setState(() {
                  myZikars.add(Zikar(
                    name: _nameController.text,
                    targetCount: int.parse(_targetController.text),
                  ));
                });
                _nameController.clear(); // // Input ke baad fields ko khali karna
                _targetController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // // Function: Long press karne par current zikar ka target change kar sakty hai
  void _editTargetDialog(int index) {
    _targetController.text = myZikars[index].targetCount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Target for ${myZikars[index].name}"),
        content: TextField(
          controller: _targetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "New Target"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // // Specific index par target update karna
                myZikars[index].targetCount = int.parse(_targetController.text);
              });
              _targetController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7CCC8), 
      appBar: AppBar(
        title: const Text(
          "Tasbeeh Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D4037),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
            onPressed: _showAddDialog,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: myZikars.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _editTargetDialog(index); // // Long press par edit option trigger hota hai
            },
            child: ZikarCard(
              name: myZikars[index].name,
              count: myZikars[index].currentCount,
              target: myZikars[index].targetCount, 
              onTap: () async {
                // // Counter Screen par jana aur navigation se result (updated count) ka wait karna
                final int? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CounterScreen(zikar: myZikars[index]),
                  ),
                );

                // // Dashboard par wapas aane par state update karna agar result mile
                if (result != null) {
                  setState(() {
                    myZikars[index].currentCount = result;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}