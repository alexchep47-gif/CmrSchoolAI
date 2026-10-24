import 'package:flutter/material.dart';

import '../../core/levels/level_model.dart';
import '../../core/theme/app_theme.dart';
import '../chat_tutor/chat_page.dart';
import '../exam_generator/exam_generator_page.dart';
import '../scan_homework/scan_homework_page.dart';
import '../nearby_devices/nearby_devices_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.level});

  final SchoolLevel level;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CmrSchoolAI'),
        actions: [
          IconButton(
            tooltip: 'Réglages',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          _HomeContent(level: widget.level),
          const _LibraryContent(),
          const _ProgressContent(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Bibliothèque'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Progression'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.level});
  final SchoolLevel level;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Text('Bonjour, apprenant', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('Ton espace adapté au niveau ${level.label}.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Card(
          color: AppTheme.navy,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.auto_awesome, color: AppTheme.orange, size: 30),
              const SizedBox(height: 12),
              Text('Ton professeur IA', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('Pose une question sur ton cours et reçois une explication claire, à ton niveau.', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatPage(level: level))), icon: const Icon(Icons.chat_bubble_outline), label: const Text('Démarrer une conversation')),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        Text('Apprendre aujourd’hui', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ScanHomeworkPage(level: level))), borderRadius: BorderRadius.circular(12), child: _ActionCard(icon: Icons.camera_alt_outlined, title: 'Scanner un devoir', subtitle: 'Photo et correction', color: AppTheme.orange))),
          const SizedBox(width: 12),
          Expanded(child: InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ExamGeneratorPage(level: level))), borderRadius: BorderRadius.circular(12), child: _ActionCard(icon: Icons.assignment_outlined, title: 'Créer une épreuve', subtitle: 'Exercices adaptés', color: AppTheme.mint))),
        ]),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.devices_other_outlined)),
            title: const Text('Partager à proximité'),
            subtitle: const Text('Détecter et connecter un téléphone proche'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NearbyDevicesPage())),
          ),
        ),
        const SizedBox(height: 22),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.flag_outlined)), title: const Text('Objectif de la semaine'), subtitle: const Text('3 leçons terminées sur 5'), trailing: const Text('60%', style: TextStyle(fontWeight: FontWeight.w800)))),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: .18), child: Icon(icon, color: color)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _LibraryContent extends StatelessWidget {
  const _LibraryContent();
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [Text('Bibliothèque', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Les cours et fiches sont filtrés selon ton niveau.'), const SizedBox(height: 20), ...['Mathématiques', 'Français', 'Sciences', 'Histoire-Géographie'].map((subject) => Card(child: ListTile(leading: const Icon(Icons.folder_outlined), title: Text(subject), subtitle: const Text('Cours, fiches et exercices hors-ligne'), trailing: const Icon(Icons.chevron_right))))]);
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent();
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [Text('Ma progression', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 20), Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Progression générale'), const SizedBox(height: 12), LinearProgressIndicator(value: .64, minHeight: 10, borderRadius: BorderRadius.circular(8)), const SizedBox(height: 10), const Text('64% des compétences maîtrisées')]))), const SizedBox(height: 12), const Card(child: ListTile(leading: Icon(Icons.lightbulb_outline), title: Text('Recommandation'), subtitle: Text('Révise les fractions avant de passer au prochain chapitre.')))]);
}
