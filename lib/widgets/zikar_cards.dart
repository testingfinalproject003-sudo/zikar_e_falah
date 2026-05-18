import 'package:flutter/material.dart';

// This is a reusable 'Card' widget. 
// Every time we want to show a Zikar on the screen, we call this class.
class ZikarCard extends StatelessWidget {
  final String name;      // The name of the Zikar (e.g., "SubhanAllah")
  final int count;       // Current progress
  final int target;      // The goal (e.g., 33)
  final VoidCallback onTap; // What happens when the user clicks this card

  const ZikarCard({    // This is the 'Constructor'.
    super.key, 
    required this.name, 
    required this.count, 
    required this.target, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // LOGIC: We create a boolean (true/false) to check if the goal is reached.
    // This makes it easy to change colors automatically.
    bool isDone = count >= target;

    return Container(
      // Margin creates space 'outside' the card so cards don't touch each other.
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // BoxDecoration is used to style the 'Box' (colors, rounded corners, borders).
      decoration: BoxDecoration(
        // If isDone is true, use light green. If false, use a soft brown/grey.
        color: isDone ? const Color(0xFFF1F8E9) : const Color(0xFFEFEBE9), 
        borderRadius: BorderRadius.circular(20), // Makes the corners rounded
        border: Border.all(
          color: isDone ? Colors.green : const Color(0xFF8D6E63), 
          width: isDone ? 2 : 1, // Make the border thicker when completed
        ),
      ),
      // ListTile is a built-in Flutter widget perfect for rows with icons and text.
      child: ListTile(
        onTap: onTap, // Executes the function passed from the parent screen
        contentPadding: const EdgeInsets.all(15), // Space 'inside' the card
        // 'leading' is the widget at the very start (left side) of the row.
        leading: CircleAvatar(
          backgroundColor: isDone ? Colors.green : const Color(0xFF6D4C41),
          child: isDone 
          ? const Icon(Icons.check, color: Colors.white, size: 20) // Show tick if done
          : Text("$count", style: const TextStyle(color: Colors.white, fontSize: 12)), // Show number if not done
        ),
        // 'title' is the main text in the middle.
        title: Text(
          name,
          textAlign: TextAlign.right, // Aligns text to the right
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: isDone ? Colors.green[800] : const Color(0xFF4E342E),
          ),
        ),
        // 'trailing' is the widget at the very end (right side) of the row.
        trailing: isDone 
        ? const Icon(Icons.verified, color: Colors.green, size: 22) // Verified badge if finished
        : const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF8D6E63)), // Small arrow otherwise
      ),
    );
  }
}