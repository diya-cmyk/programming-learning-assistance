import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../theme/cyberpunk_theme.dart';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  List<int> _array = [64, 34, 25, 12, 22, 11, 90];

  int _comparingI = -1;
  int _comparingJ = -1;

  bool _isRunning = false;

  int _speed = 500;

  String _statusText = "Press Start to visualize sorting";

  String _selectedAlgorithm = "Bubble Sort";

  final TextEditingController _arrayController = TextEditingController();

  void _setCustomArray() {
    try {
      final values = _arrayController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();

      setState(() {
        _array = values;
        _statusText = "Custom array loaded";
      });
    } catch (e) {
      setState(() {
        _statusText = "Invalid input. Example: 10,5,3,8";
      });
    }
  }

  void _generateRandomArray() {
    final rand = Random();
    final newArray = List.generate(8, (_) => rand.nextInt(100) + 10);

    setState(() {
      _array = newArray;
      _statusText = "Random array generated";
    });
  }

  Future<void> _startBubbleSort() async {
    setState(() => _isRunning = true);

    final arr = List<int>.from(_array);

    for (int i = 0; i < arr.length - 1; i++) {
      for (int j = 0; j < arr.length - i - 1; j++) {
        setState(() {
          _comparingI = j;
          _comparingJ = j + 1;
          _statusText = "Comparing ${arr[j]} and ${arr[j + 1]}";
        });

        await Future.delayed(Duration(milliseconds: _speed));

        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;

          setState(() {
            _array = List.from(arr);
            _statusText = "Swapped";
          });

          await Future.delayed(Duration(milliseconds: _speed ~/ 2));
        }
      }
    }

    setState(() {
      _isRunning = false;
      _comparingI = -1;
      _comparingJ = -1;
      _statusText = "✅ Sorted using Bubble Sort (O(n²))";
    });

    context.read<GamificationProvider>().addPoints(20, skill: "algorithms");
  }

  Future<void> _startSelectionSort() async {
    setState(() => _isRunning = true);

    final arr = List<int>.from(_array);

    for (int i = 0; i < arr.length - 1; i++) {
      int minIndex = i;

      for (int j = i + 1; j < arr.length; j++) {
        setState(() {
          _comparingI = minIndex;
          _comparingJ = j;
        });

        await Future.delayed(Duration(milliseconds: _speed));

        if (arr[j] < arr[minIndex]) {
          minIndex = j;
        }
      }

      int temp = arr[minIndex];
      arr[minIndex] = arr[i];
      arr[i] = temp;

      setState(() {
        _array = List.from(arr);
      });
    }

    setState(() {
      _isRunning = false;
      _statusText = "✅ Sorted using Selection Sort";
    });
  }

  Future<void> _startInsertionSort() async {
    setState(() => _isRunning = true);

    final arr = List<int>.from(_array);

    for (int i = 1; i < arr.length; i++) {
      int key = arr[i];
      int j = i - 1;

      while (j >= 0 && arr[j] > key) {
        setState(() {
          _comparingI = j;
          _comparingJ = j + 1;
        });

        arr[j + 1] = arr[j];

        setState(() {
          _array = List.from(arr);
        });

        j--;

        await Future.delayed(Duration(milliseconds: _speed));
      }

      arr[j + 1] = key;

      setState(() {
        _array = List.from(arr);
      });
    }

    setState(() {
      _isRunning = false;
      _statusText = "✅ Sorted using Insertion Sort";
    });
  }

  void _startSelectedAlgorithm() {
    if (_selectedAlgorithm == "Bubble Sort") {
      _startBubbleSort();
    } else if (_selectedAlgorithm == "Selection Sort") {
      _startSelectionSort();
    } else if (_selectedAlgorithm == "Insertion Sort") {
      _startInsertionSort();
    }
  }

  void _reset() {
    setState(() {
      _array = [64, 34, 25, 12, 22, 11, 90];

      _comparingI = -1;
      _comparingJ = -1;

      _statusText = "Press Start to visualize sorting";
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = _array.reduce(max);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Algorithm Visualizer"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            _statusText,
            style: const TextStyle(
              fontSize: 16,
              color: CyberpunkTheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _arrayController,
                    decoration: const InputDecoration(
                      hintText: "Enter array: 10,5,3,8",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _setCustomArray,
                ),
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: _generateRandomArray,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedAlgorithm,
            items: const [
              DropdownMenuItem(
                  value: "Bubble Sort", child: Text("Bubble Sort")),
              DropdownMenuItem(
                  value: "Selection Sort", child: Text("Selection Sort")),
              DropdownMenuItem(
                  value: "Insertion Sort", child: Text("Insertion Sort")),
            ],
            onChanged: (value) {
              setState(() {
                _selectedAlgorithm = value!;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _array.asMap().entries.map((entry) {
                  int index = entry.key;
                  int value = entry.value;

                  Color color = CyberpunkTheme.secondary;

                  if (index == _comparingI || index == _comparingJ) {
                    color = CyberpunkTheme.accent;
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(value.toString()),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: Duration(milliseconds: _speed ~/ 2),
                            height: (value / maxVal) * 250,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text("Speed"),
                Expanded(
                  child: Slider(
                    value: (1000 - _speed).toDouble(),
                    min: 0,
                    max: 900,
                    onChanged: (v) {
                      setState(() {
                        _speed = (1000 - v).toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? null : _startSelectedAlgorithm,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start"),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                onPressed: _isRunning ? null : _reset,
                icon: const Icon(Icons.refresh),
                label: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
