import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../main.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  void _showDeveloperDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.code, color: Colors.teal),
            ),
            const SizedBox(width: 12),
            const Text('Developer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, 'Name', 'Ahmed AZIBI'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.school, 'Education', 'ENSH - BLIDA - Algiers'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.work, 'Career', 'Developer & Hydraulic Engineering Student'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'Email', 'Ahmed.Azibi@ensh.dz'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.code_outlined, 'GitHub', 'ahmedazibi-bot'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  void _showCompletionBottomSheet(Chapter chapter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            Text(chapter.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Mark this chapter as complete?', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _appState.markChapterComplete(chapter.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chapter completed! Next chapter unlocked.'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Complete', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('ALGO/LAPCP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.teal),
              onPressed: _showDeveloperDialog,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildDashboard()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildModuleCard(_appState.modules[index]),
                  childCount: _appState.modules.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.withOpacity(0.3), const Color(0xFF1E1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.teal, size: 28),
                      const SizedBox(height: 8),
                      Text('Day ${_appState.currentDay} of 365', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Daily Streak', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 35,
                        lineWidth: 6,
                        percent: _appState.getWeeklyProgress(),
                        center: Text('${(_appState.getWeeklyProgress() * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        progressColor: Colors.teal,
                        backgroundColor: const Color(0xFF3C3C3C),
                      ),
                      const SizedBox(height: 8),
                      Text('${_appState.weeklyMinutes}/${_appState.weeklyTarget} min', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      Text('Weekly Goal', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: Colors.amber[400], size: 24),
                const SizedBox(width: 12),
                Text(
                  '${_appState.getCompletedChaptersCount()}/${_appState.getTotalChaptersCount()} Chapters Completed',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Module module) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        initiallyExpanded: module.chapters.any((c) => c.isUnlocked && !c.isCompleted),
        collapsedBackgroundColor: const Color(0xFF1E1E1E),
        backgroundColor: const Color(0xFF1E1E1E),
        iconColor: Colors.teal,
        collapsedIconColor: Colors.grey[400],
        title: Text(module.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text('${module.chapters.where((c) => c.isCompleted).length}/${module.chapters.length} completed', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        children: module.chapters.map((chapter) => _buildChapterTile(chapter)).toList(),
      ),
    );
  }

  Widget _buildChapterTile(Chapter chapter) {
    final bool isLocked = !chapter.isUnlocked;
    final bool isCompleted = chapter.isCompleted;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isLocked ? const Color(0xFF3C3C3C) : isCompleted ? Colors.teal.withOpacity(0.2) : Colors.teal.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isLocked ? Colors.grey[600]! : isCompleted ? Colors.teal : Colors.teal.withOpacity(0.5),
            width: isLocked ? 1 : 2,
          ),
        ),
        child: Icon(
          isLocked ? Icons.lock : isCompleted ? Icons.check : Icons.play_arrow,
          color: isLocked ? Colors.grey[500] : Colors.teal,
          size: 20,
        ),
      ),
      title: Text(
        chapter.title,
        style: TextStyle(
          color: isLocked ? Colors.grey[500] : Colors.white,
          fontSize: 14,
          fontWeight: isLocked ? FontWeight.normal : FontWeight.w500,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          decorationColor: Colors.teal,
        ),
      ),
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: Colors.teal, size: 20)
          : isLocked
              ? Icon(Icons.lock_outline, color: Colors.grey[600], size: 18)
              : const Icon(Icons.chevron_right, color: Colors.teal, size: 20),
      onTap: isLocked || isCompleted ? null : () => _showCompletionBottomSheet(chapter),
    );
  }
}