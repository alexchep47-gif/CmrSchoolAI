import 'package:flutter/material.dart';

import '../../core/levels/level_model.dart';

class ExamGeneratorPage extends StatefulWidget {
  const ExamGeneratorPage({super.key, required this.level});
  final SchoolLevel level;
  @override State<ExamGeneratorPage> createState() => _ExamGeneratorPageState();
}

class _ExamGeneratorPageState extends State<ExamGeneratorPage> {
  String subject = 'Mathématiques';
  bool generated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une épreuve')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Une épreuve adaptée à ${widget.level.label}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Choisis une matière et l’IA prépare des exercices avec leur corrigé.'),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: subject,
            decoration: const InputDecoration(labelText: 'Matière'),
            items: ['Mathématiques', 'Français', 'Sciences', 'Histoire-Géographie'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (value) => setState(() => subject = value ?? subject),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: () => setState(() => generated = true), icon: const Icon(Icons.auto_awesome), label: const Text('Générer mon épreuve')),
          if (generated) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$subject · ${widget.level.label}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 12),
                  const Text('Épreuve personnalisée prête. Elle contient 10 exercices progressifs et un corrigé détaillé.'),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.visibility_outlined), label: const Text('Voir l’épreuve')),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
