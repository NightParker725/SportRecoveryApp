import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/phase_content.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  late int phaseIndex;
  String? phaseName;
  int _selectedTopicIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;
    phaseIndex = args['phaseIndex'] as int;
    phaseName = args['phaseName'] as String?;
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = getPhaseContentByIndex(phaseIndex);
    final phaseTitle =
        phaseName != null && phaseName!.isNotEmpty ? phaseName! : 'Fase $phaseIndex';

    final icons = List.generate(3, (i) {
      final idx = i + 1;
      final state = idx == phaseIndex ? 'pressed' : 'enabled';
      return Image.asset('assets/images/recovery/${idx}_$state.png', width: 64, height: 64);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(phaseTitle)),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Center(
                child: Image.asset('assets/images/recovery/recovery_back.png', fit: BoxFit.contain),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Proceso de Recuperación',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        phaseTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorForPhaseIndex(phaseIndex),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: icons,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Phase description
                Text(
                  content.phaseDescription,
                  style: const TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 16),
                // Topics selector
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(content.topics.length, (i) {
                    final selected = _selectedTopicIndex == i;
                    return ChoiceChip(
                      label: Text(content.topics[i].title),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedTopicIndex = i),
                      labelStyle: TextStyle(
                        color: selected ? Colors.black : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: colorForPhaseIndex(phaseIndex),
                      backgroundColor: Colors.grey.shade200,
                    );
                  }),
                ),

                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    content.topics[_selectedTopicIndex].description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),

                const SizedBox(height: 16),
                // Optional video for current topic
                if (content.topics[_selectedTopicIndex].video != null)
                  Builder(builder: (context) {
                    final v = content.topics[_selectedTopicIndex].video!;
                    final accent = colorForPhaseIndex(phaseIndex);
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              v.thumbnailAsset,
                              width: 96,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(v.shortDescription, style: const TextStyle(color: Colors.black87)),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: accent,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    onPressed: () => _openUrl(v.url),
                                    child: const Text('Ver tutorial'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
