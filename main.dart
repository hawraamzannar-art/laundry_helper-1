import 'package:flutter/material.dart';

void main() => runApp(const LaundryApp());

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Helper',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> fabrics = ['Cotton', 'Wool', 'Silk', 'Polyester', 'Denim', 'Linen'];
  String selectedFabric = 'Cotton';
  String colorType = 'Whites';
  String result = '';

  // Mixed load check
  final Set<String> loadItems = {};
  String loadResult = '';

  final Map<String, String> plans = {
    'Cotton': 'Wash: 40°C\nDryer: medium heat\nIron: high',

    'Wool': 'Wash: 30°C (gentle cycle)\nDryer: Do not tumble dry\nIron: low heat',

    'Silk': 'Wash: Hand wash in cold water\nDryer: Do not tumble dry\nIron: low heat',

    'Polyester': 'Wash: 30-40°C\nDryer: Low heat\nIron: low heat',

    'Denim': 'Wash: 30°C\nDryer: Air dry\nIron: medium heat',

    'Linen': 'Wash: 30-40°C\nDryer: Air dry\nIron: high heat (slightly damp)',
  };

  String getCarePlan(String fabric, String color) {
    String plan = plans[fabric] ?? 'No data';

    if (color == 'Darks') {
      plan += '\nTip: Wash inside out using cold water.';
    }

    if (color == 'Whites') {
      if (fabric == 'Cotton' || fabric == 'Linen') {
        plan += '\nTip: Bleach is okay if the care label allows it.';
      } else if (fabric == 'Silk' || fabric == 'Wool') {
        plan += '\nTip: Never use bleach.';
      } else {
        plan += '\nTip: Check the care label before using bleach.';
      }
    }

    if (color == 'Colors') {
      plan += '\nTip: Wash new colored garments separately the first time.';
    }

    return plan;
  }

  String checkLoad() {
    if (loadItems.length < 2) return 'Select at least two fabrics.';
    if (loadItems.contains('Wool') && loadItems.contains('Denim')) {
      return 'Wash wool and denim separately.';
    }
    if (loadItems.contains('Silk') && loadItems.contains('Denim')) {
      return 'Wash silk and denim separately.';
    }
    if (loadItems.contains('Silk') && loadItems.contains('Cotton')) {
      return 'Wash silk and cotton separately.';
    }
    if (loadItems.contains('Wool') && loadItems.contains('Cotton')) {
      return 'Wash wool and cotton separately.';
    }
    return 'These fabrics can be washed together.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laundry Helper')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Fabric', style: TextStyle(fontSize: 18)),
              DropdownButton<String>(
                value: selectedFabric,
                isExpanded: true,
                items: fabrics
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (value) => setState(() {
                  selectedFabric = value!;
                  result = '';
                }),
              ),
              const SizedBox(height: 16),
              const Text('Color type', style: TextStyle(fontSize: 18)),
              RadioListTile<String>(
                title: const Text('Darks'),
                value: 'Darks',
                groupValue: colorType,
                onChanged: (value) => setState(() {
                  colorType = value!;
                  result = '';
                }),
              ),
              RadioListTile<String>(
                title: const Text('Whites'),
                value: 'Whites',
                groupValue: colorType,
                onChanged: (value) => setState(() {
                  colorType = value!;
                  result = '';
                }),
              ),
              RadioListTile<String>(
                title: const Text('Colors'),
                value: 'Colors',
                groupValue: colorType,
                onChanged: (v) => setState(() {
                  colorType = v!;
                  result = '';
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => result = getCarePlan(selectedFabric, colorType));
                },
                child: const Text('Show care plan'),
              ),
              const SizedBox(height: 16),
              if (result.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(result, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              const SizedBox(height: 24),
              const Text('Mixed load check', style: TextStyle(fontSize: 18)),
              ...fabrics.map((f) => CheckboxListTile(
                title: Text(f),
                value: loadItems.contains(f),
                onChanged: (checked) => setState(() {
                  if (checked == true) {
                    loadItems.add(f);
                  } else {
                    loadItems.remove(f);
                  }
                  loadResult = '';
                }),
              )),
              ElevatedButton(
                onPressed: () => setState(() => loadResult = checkLoad()),
                child: const Text('Check load'),
              ),
              if (loadResult.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(loadResult),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}