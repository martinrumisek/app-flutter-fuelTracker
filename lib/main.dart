import 'package:flutter/material.dart';

void main() {
  runApp(const FuelTrackerApp());
}

class FuelTrackerApp extends StatelessWidget {
  const FuelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fuel Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FuelTrackerHome(),
    );
  }
}

class FuelEntry {
  final String date;
  final double odometer;
  final double fuel;
  final double pricePerLiter;
  final String notes;

  FuelEntry({
    required this.date,
    required this.odometer,
    required this.fuel,
    required this.pricePerLiter,
    required this.notes,
  });
}

class FuelTrackerHome extends StatefulWidget {
  const FuelTrackerHome({super.key});

  @override
  _FuelTrackerHomeState createState() => _FuelTrackerHomeState();
}

class _FuelTrackerHomeState extends State<FuelTrackerHome> {
  final List<FuelEntry> _entries = [];
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _odometerController = TextEditingController();
  final _fuelController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  void _addEntry() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _entries.add(
          FuelEntry(
            date: _dateController.text,
            odometer: double.parse(_odometerController.text),
            fuel: double.parse(_fuelController.text),
            pricePerLiter: double.parse(_priceController.text),
            notes: _notesController.text,
          ),
        );
      });
      _clearFields();
    }
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  void _clearFields() {
    _dateController.clear();
    _odometerController.clear();
    _fuelController.clear();
    _priceController.clear();
    _notesController.clear();
  }

  double _calculateAverageConsumption() {
    if (_entries.length < 2) return 0;
    double totalDistance = 0;
    double totalFuel = 0;
    for (int i = 1; i < _entries.length; i++) {
      totalDistance += _entries[i].odometer - _entries[i - 1].odometer;
      totalFuel += _entries[i].fuel;
    }
    return totalFuel > 0 ? (totalFuel / totalDistance) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Datum'),
                    validator:
                        (value) => value!.isEmpty ? 'Zadejte datum' : null,
                  ),
                  TextFormField(
                    controller: _odometerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stav tachometru (km)',
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Zadejte stav tachometru' : null,
                  ),
                  TextFormField(
                    controller: _fuelController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Množství paliva (l)',
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Zadejte množství paliva' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cena za litr (Kč)',
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Zadejte cenu za litr' : null,
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Poznámky'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addEntry,
                    child: const Text('Přidat záznam'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Průměrná spotřeba: ${_calculateAverageConsumption().toStringAsFixed(2)} L/100 km',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Card(
                    child: ListTile(
                      title: Text('${entry.date} - ${entry.odometer} km'),
                      subtitle: Text(
                        'Palivo: ${entry.fuel} L | Cena: ${entry.pricePerLiter} Kč/L\nPoznámky: ${entry.notes}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeEntry(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
