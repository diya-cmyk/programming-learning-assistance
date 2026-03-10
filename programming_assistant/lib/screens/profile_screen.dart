import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/gamification_provider.dart';
import '../screens/login_screen.dart';
import '../theme/cyberpunk_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GamificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // LEVEL CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'LEVEL ${gp.level}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: CyberpunkTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${gp.points} XP',
                    style: const TextStyle(
                      color: CyberpunkTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: gp.levelProgress,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(
                      CyberpunkTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(gp.levelProgress * 100).toInt()}% to Level ${gp.level + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CyberpunkTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // STATS ROW
          Row(
            children: [
              Expanded(
                child: _statCard(
                  '${gp.streak}',
                  'Day Streak',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statCard(
                  '${gp.badges.length}',
                  'Badges',
                  Icons.military_tech,
                  Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // BADGES SECTION
          if (gp.badges.isNotEmpty) ...[
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: gp.badges
                  .map(
                    (b) => Chip(
                      label: Text(b),
                      backgroundColor:
                          CyberpunkTheme.secondary.withOpacity(0.3),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: CyberpunkTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
