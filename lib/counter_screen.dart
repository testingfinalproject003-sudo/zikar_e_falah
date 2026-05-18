import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; 
import 'package:zikar_e_falah/widgets/zikar_model.dart';

class CounterScreen extends StatefulWidget {
  final Zikar zikar;
  const CounterScreen({super.key, required this.zikar});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int _current;
  double _beadScale = 1.0;

  @override
  void initState() {
    super.initState();
    // Load existing count from the model
    _current = widget.zikar.currentCount;
  }

  // Function to trigger haptic feedback/vibration
  void _triggerTargetVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 600);
    }
  }

  // Handle tap events on the counter circle
  void _handleTap() {
    // STOP LOGIC: Prevent counting further if target is reached
    if (_current >= widget.zikar.targetCount) {
      return; 
    }

    setState(() {
      _current++; // Increment counter
      _beadScale = 1.1; // Visual feedback: scale up circle
      
      // Trigger vibration when target is reached
      if (_current == widget.zikar.targetCount) {
        _triggerTargetVibration(); 
      }
    });

    // Reset circle size after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _beadScale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = _current >= widget.zikar.targetCount;

    return PopScope(
      canPop: false,
      // Pass updated count back to the dashboard when navigating back
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _current);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFD7CCC8),
        appBar: AppBar(
          title: Text(widget.zikar.name, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: const Color(0xFF5D4037),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 40), 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ذکر میں سکون ہے،\nتسبیح دل کے نور کو پیدا کرتی ہے\nاور ہر ذکر کے ساتھ دل کی صفائی بڑھتی ہے،\nذکر جاری رکھیں",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20, // Increased font size for better Urdu readability
                    color: Color(0xFF4E342E),
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    // Show success message when goal is reached
                    if (isDone)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "MashaAllah! Target Achieved",
                          style: TextStyle(
                            color: Color(0xFF2E7D32), 
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    
                    Text(
                      "Target: ${widget.zikar.targetCount}",
                      style: const TextStyle(fontSize: 20, color: Color(0xFF5D4037)),
                    ),

                    const SizedBox(height: 20),

                    // Interactive Counter Circle
                    GestureDetector(
                      onTap: _handleTap,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        transform: Matrix4.diagonal3Values(_beadScale, _beadScale, 1.0),
                        alignment: Alignment.center,
                        width: 260, 
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // Change color based on completion status
                          color: isDone ? Colors.amber[700] : const Color(0xFF8D6E63),
                          border: Border.all(color: Colors.white, width: 8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 25, offset: Offset(0, 10))
                          ],
                        ),
                        child: Text(
                          "$_current",
                          style: const TextStyle(
                            fontSize: 90, 
                            color: Colors.white, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Reset button to clear current count
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _current = 0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D4037),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                      label: const Text("RESET", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      "Tap circle to count • Auto-saves on back", 
                      style: TextStyle(color: Color(0xFF8D6E63), fontSize: 13, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}