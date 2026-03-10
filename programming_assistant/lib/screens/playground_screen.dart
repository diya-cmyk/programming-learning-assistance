import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import '../services/code_execution_service.dart';
import '../services/ai_service.dart';
import '../theme/cyberpunk_theme.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});
  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  String _selectedLang = 'python';
  String _output = '';
  bool _isRunning = false;
  bool _isDebugging = false;

  late final CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '# Write your Python code here\nprint("Hello, World!")',
      language: python,
    );
  }

  Future<void> _runCode() async {
    setState(() {
      _isRunning = true;
      _output = 'Running...';
    });
    final result = await CodeExecutionService.executeCode(
      _codeController.text,
      _selectedLang,
    );
    setState(() {
      _output = result;
      _isRunning = false;
    });
  }

  Future<void> _debugCode() async {
    setState(() {
      _isDebugging = true;
      _output = 'Analyzing...';
    });
    final result = await AIService.sendMessage(
      _codeController.text,
      mode: AIMode.debug,
    );
    setState(() {
      _output = result;
      _isDebugging = false;
    });
  }

  Future<void> _explainCode() async {
    setState(() {
      _output = 'Explaining...';
    });
    final result = await AIService.sendMessage(
      _codeController.text,
      mode: AIMode.explain,
    );
    setState(() {
      _output = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Playground'),
        actions: [
          DropdownButton<String>(
            value: _selectedLang,
            dropdownColor: CyberpunkTheme.surface,
            items: ['python', 'cpp', 'java', 'javascript']
                .map(
                  (l) =>
                      DropdownMenuItem(value: l, child: Text(l.toUpperCase())),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedLang = v!),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runCode,
                  icon: _isRunning
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: const Text('Run'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _isDebugging ? null : _debugCode,
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Debug'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _explainCode,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Explain'),
                ),
              ],
            ),
          ),
          // Code editor
          Expanded(
            flex: 2,
            child: CodeTheme(
              data: CodeThemeData(
                styles: {
                  'root': const TextStyle(backgroundColor: Color(0xFF1A1A2E)),
                },
              ),
              child: SingleChildScrollView(
                child: CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          // Output panel
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF0A0A0F),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Text(
                  _output.isEmpty ? '// Output appears here' : _output,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: _output.startsWith('Error')
                        ? Colors.red[300]
                        : Colors.green[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
