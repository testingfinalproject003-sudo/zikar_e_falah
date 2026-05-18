// This class acts as a 'Template' or 'Blueprint' for a Zikar item.
class Zikar {
  // The name of the prayer 
  String name; 

  // The goal we want to reach (e.g., 33, 100, or 1000).
  int targetCount; 

  // How many times we have actually clicked/counted so far.
  int currentCount; 

  // This is the 'Constructor'. 
  Zikar({
    required this.name, 
    required this.targetCount, 
    // This is a 'Default Value'. 
    this.currentCount = 0, 
  });
}