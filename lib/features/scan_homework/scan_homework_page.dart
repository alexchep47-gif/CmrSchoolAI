import 'package:flutter/material.dart';

import '../../core/levels/level_model.dart';
import '../../core/theme/app_theme.dart';

class ScanHomeworkPage extends StatefulWidget {
  const ScanHomeworkPage({super.key, required this.level});

  final SchoolLevel level;

  @override
  State<ScanHomeworkPage> createState() => _ScanHomeworkPageState();
}

class _ScanHomeworkPageState extends State<ScanHomeworkPage> {
  bool hasPhoto = false;
  bool isAnalyzing = false;
  bool hasResult = false;

  Future<void> _analyze() async {
    setState(() => isAnalyzing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      isAnalyzing = false;
      hasResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner un devoir')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('Correction adaptée', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Niveau ${widget.level.label} · Le barème et les explications seront adaptés à ton programme.'),
          const SizedBox(height: 20),
          Semantics(
            button: true,
            label: hasPhoto ? 'Photo du devoir sélectionnée' : 'Ajouter une photo du devoir',
            child: InkWell(
              onTap: () => setState(() => hasPhoto = true),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  color: AppTheme.mint.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.mint.withValues(alpha: .5), width: 1.5),
                ),
                child: Center(
                  child: hasPhoto
                      ? const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.image_outlined, size: 54, color: AppTheme.navy), SizedBox(height: 10), Text('Photo prête à être analysée', style: TextStyle(fontWeight: FontWeight.w700))])
                      : const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera_alt_outlined, size: 54, color: AppTheme.navy), SizedBox(height: 10), Text('Prendre ou choisir une photo', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Image conservée de façon chiffrée', style: TextStyle(color: Colors.black54))]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => setState(() => hasPhoto = true), icon: const Icon(Icons.photo_library_outlined), label: const Text('Galerie'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: () => setState(() => hasPhoto = true), icon: const Icon(Icons.camera_alt_outlined), label: const Text('Caméra'))),
          ]),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: hasPhoto && !isAnalyzing ? _analyze : null,
            icon: isAnalyzing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome),
            label: Text(isAnalyzing ? 'Analyse en cours…' : 'Analyser le devoir'),
          ),
          if (hasResult) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.check_circle_outline, color: Colors.green), const SizedBox(width: 8), Text('Analyse terminée', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))]),
                  const SizedBox(height: 12),
                  const Text('La correction détaillée apparaîtra ici avec les étapes, les erreurs repérées et des conseils de révision adaptés à ton niveau.'),
                ]),
              ),
            ),
          ],
          const SizedBox(height: 18),
          const Card(child: ListTile(leading: Icon(Icons.lock_outline), title: Text('Tes photos restent privées'), subtitle: Text('Elles sont protégées et peuvent être supprimées depuis les réglages.'))),
        ],
      ),
    );
  }
}
