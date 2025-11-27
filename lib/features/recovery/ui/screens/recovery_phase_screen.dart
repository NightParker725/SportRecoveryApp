import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moviles252/ui/theme/app_colors.dart';
import 'package:moviles252/ui/widgets/content_feature_card.dart';
import '../data/phase_content.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  bool _initialized = false;
  late int _initialPhaseIndex;
  late int _viewPhaseIndex;
  final Map<int, String> _phaseNames = {};
  int _selectedTopicIndex = 0;

  static const Color _topicsHighlight = AppColors.primaryBlue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final initialIdx = args?['phaseIndex'] as int? ?? 1;
    _initialPhaseIndex = initialIdx;
    _viewPhaseIndex = initialIdx;

    final providedName = args?['phaseName'] as String?;
    if (providedName != null && providedName.isNotEmpty) {
      _phaseNames[_initialPhaseIndex] = providedName;
    }

    final rawNames = args?['phaseNames'];
    if (rawNames is Map) {
      rawNames.forEach((key, value) {
        final parsedKey =
            key is int ? key : int.tryParse(key.toString());
        if (parsedKey != null && value is String && value.isNotEmpty) {
          _phaseNames[parsedKey] = value;
        }
      });
    }
    _initialized = true;
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
    final content = getPhaseContentByIndex(_viewPhaseIndex);
    final phaseTitle = _phaseDisplayLabel(_viewPhaseIndex);
    final accent = colorForPhaseIndex(_viewPhaseIndex);
    final screenHeight = MediaQuery.of(context).size.height;

    final icons = List.generate(3, (i) {
      final idx = i + 1;
      final state = idx == _viewPhaseIndex ? 'pressed' : 'enabled';
      return GestureDetector(
        onTap: () {
          if (_viewPhaseIndex == idx) return;
          setState(() {
            _viewPhaseIndex = idx;
            _selectedTopicIndex = 0;
          });
        },
        child: Image.asset(
          'assets/images/recovery/${idx}_$state.png',
          width: 70,
          height: 70,
        ),
      );
    });

    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Image.asset(
                'assets/images/recovery/${_viewPhaseIndex}_back.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: topInset + kToolbarHeight + 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 280,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: icons,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Proceso de',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(height: 0),
                                Text(
                                  phaseTitle,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        content.phaseDescription,
                        style: const TextStyle(color: Colors.black87, height: 1.4, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(content.topics.length, (i) {
                          final selected = _selectedTopicIndex == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTopicIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.pureWhite : AppColors.lightChipGrey,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected ? _topicsHighlight : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                content.topics[i].title,
                                style: TextStyle(
                                  color: selected ? Colors.black : AppColors.pureWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _PhaseTopicDetail(
                  topicTitle: content.topics[_selectedTopicIndex].title,
                  description: content.topics[_selectedTopicIndex].description,
                  video: content.topics[_selectedTopicIndex].video,
                  onOpenVideo: _openUrl,
                  accent: accent,
                  minHeight: screenHeight * 0.55,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _phaseDisplayLabel(int idx) {
    switch (idx) {
      case 1:
        return 'Recuperación';
      case 2:
        return 'Rehabilitación';
      case 3:
        return 'Prevención';
      default:
        return 'Fase $idx';
    }
  }
}

class _PhaseTopicDetail extends StatelessWidget {
  const _PhaseTopicDetail({
    required this.topicTitle,
    required this.description,
    required this.accent,
    this.minHeight,
    this.video,
    this.onOpenVideo,
  });

  final String topicTitle;
  final String description;
  final Color accent;
  final double? minHeight;
  final PhaseVideo? video;
  final void Function(String url)? onOpenVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topicTitle,
            style: const TextStyle(color: AppColors.pureWhite, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        if (video != null) ...[
          const SizedBox(height: 16),
          ContentFeatureCard(
            imageProvider: NetworkImage(video!.thumbnailUrl),
            badgeIcon: Icons.play_arrow,
            badgeBackground: Colors.white,
            badgeIconColor: Colors.black87,
            title: video!.title,
            description: video!.shortDescription,
            buttonLabel: 'Ver tutorial',
            onButtonPressed: video?.url != null && onOpenVideo != null
                ? () => onOpenVideo!(video!.url)
                : () {},
            backgroundColor: AppColors.greySurface,
          ),
        ],
        ],
      ),
    );
  }
}
