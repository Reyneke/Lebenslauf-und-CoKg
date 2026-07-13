import 'package:flutter/material.dart';
import '../models/cv_data.dart';

class SkillsSection extends StatelessWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox.shrink();

    // Group skills by category
    final grouped = <String, List<Skill>>{};
    for (final skill in skills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16, top: 24),
          child: Text(
            'Kenntnisse & Fertigkeiten',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...grouped.entries.map((entry) => _SkillCategory(
              category: entry.key,
              skills: entry.value,
            )),
      ],
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String category;
  final List<Skill> skills;

  const _SkillCategory({required this.category, required this.skills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              category,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: skills.map((skill) {
              return _SkillBar(skill: skill);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final Skill skill;

  const _SkillBar({required this.skill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = skill.level.clamp(0, 5);
    final percentage = level / 5.0;

    return Tooltip(
      message: '${skill.name}: $level/5',
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skill.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  _colorForLevel(level, theme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForLevel(int level, ThemeData theme) {
    if (level >= 5) return Colors.green;
    if (level >= 4) return Colors.lightGreen;
    if (level >= 3) return Colors.orange;
    return Colors.red;
  }
}