import 'package:flutter/material.dart';

import '../../core/levels/level_model.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard_progress/dashboard_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  SchoolLevel? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 18),
                const Icon(Icons.school_rounded, size: 48, color: AppTheme.orange),
                const SizedBox(height: 16),
                Text('Bienvenue sur CmrSchoolAI', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Choisis ton niveau pour recevoir des explications, exercices et corrections adaptés.', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 28),
                Text('Mon niveau scolaire', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180, mainAxisExtent: 108, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: schoolLevels.length,
                  itemBuilder: (context, index) {
                    final level = schoolLevels[index];
                    final isSelected = selected?.id == level.id;
                    return InkWell(
                      onTap: () => setState(() => selected = level),
                      borderRadius: BorderRadius.circular(18),
                      child: Card(
                        color: isSelected ? AppTheme.navy : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: BorderSide(color: isSelected ? AppTheme.navy : Colors.black12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(level.label, style: TextStyle(fontWeight: FontWeight.w800, color: isSelected ? Colors.white : null)),
                            const SizedBox(height: 4),
                            Text(level.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : null)),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: selected == null
                      ? null
                      : () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => DashboardPage(level: selected!)),
                          ),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Continuer')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
