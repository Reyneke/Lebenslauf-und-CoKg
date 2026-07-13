import 'package:flutter/material.dart';
import '../models/cv_data.dart';

class CvHeader extends StatelessWidget {
  final Person person;

  const CvHeader({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (person.photo != null && person.photo!.isNotEmpty)
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(person.photo!),
            ),
          if (person.photo != null && person.photo!.isNotEmpty)
            const SizedBox(height: 16),
          Text(
            person.name,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Dipl. Ing. (FH) – Technische Informatik',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}