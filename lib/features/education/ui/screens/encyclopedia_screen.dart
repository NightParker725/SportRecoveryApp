import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/ui/theme/app_colors.dart';
import 'package:moviles252/ui/widgets/bottom_navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/common_injuries_bloc.dart';
import '../bloc/prevention_tips_bloc.dart';
import '../bloc/myths_bloc.dart';
import '../bloc/glossary_bloc.dart';
import '../../data/repositories/education_repository_impl.dart';
import '../../data/datasources/education_datasource_impl.dart';
import '../../domain/usecases/view_common_injuries_flow_usecase.dart';
import '../../domain/usecases/view_prevention_tips_flow_usecase.dart';
import '../../domain/usecases/view_myths_flow_usecase.dart';
import '../../domain/usecases/view_glossary_flow_usecase.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  int _selectedSectionIndex = 0;

  final List<EncyclopediaSection> _sections = [
    EncyclopediaSection(
      title: 'Lesiones Comunes',
      description: 'Información detallada sobre las lesiones musculoesqueléticas más frecuentes en el deporte.',
      color: const Color(0xFF019193),
      icon: Icons.medical_information_outlined,
      sectionType: SectionType.commonInjuries,
    ),
    EncyclopediaSection(
      title: 'Prevención',
      description: 'Tips y estrategias para prevenir lesiones y mantenerte seguro durante la práctica deportiva.',
      color: const Color(0xFF00C897),
      icon: Icons.shield_outlined,
      sectionType: SectionType.prevention,
    ),
    EncyclopediaSection(
      title: 'Mitos y Realidades',
      description: 'Descubre la verdad científica detrás de las creencias comunes sobre lesiones deportivas.',
      color: const Color(0xFFE67F0D),
      icon: Icons.lightbulb_outline,
      sectionType: SectionType.myths,
    ),
    EncyclopediaSection(
      title: 'Glosario Médico',
      description: 'Términos médicos y científicos explicados de forma clara y accesible.',
      color: const Color(0xFF9B59B6),
      icon: Icons.book_outlined,
      sectionType: SectionType.glossary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales
    _loadSectionData(_selectedSectionIndex);
  }

  void _loadSectionData(int index) {
    final section = _sections[index];
    switch (section.sectionType) {
      case SectionType.commonInjuries:
        context.read<CommonInjuriesBloc>().add(LoadCommonInjuries());
        break;
      case SectionType.prevention:
        context.read<PreventionTipsBloc>().add(LoadPreventionTips());
        break;
      case SectionType.myths:
        context.read<MythsBloc>().add(LoadMyths());
        break;
      case SectionType.glossary:
        context.read<GlossaryBloc>().add(LoadGlossary());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = _sections[_selectedSectionIndex];
    final accent = selectedSection.color;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          // Background image - using a light pattern or gradient
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      accent.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: topInset + kToolbarHeight + 8,
              bottom: 100, // Padding para la barra de navegación flotante
            ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Enciclopedia de',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(height: 0),
                                Text(
                                  selectedSection.title,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              selectedSection.description,
                              style: const TextStyle(
                                color: Colors.black87,
                                height: 1.4,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            // Section buttons (moved below title and description)
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: List.generate(_sections.length, (i) {
                                  final section = _sections[i];
                                  final isSelected = _selectedSectionIndex == i;
                                  return GestureDetector(
                                    onTap: () {
                                      if (_selectedSectionIndex != i) {
                                        setState(() {
                                          _selectedSectionIndex = i;
                                        });
                                        _loadSectionData(i);
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? section.color
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: isSelected
                                              ? section.color
                                              : Colors.grey[300]!,
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: section.color
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            section.icon,
                                            color: isSelected
                                                ? Colors.white
                                                : section.color,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            section.title,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Dark container at the bottom with content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: _buildContentSection(selectedSection),
                ),
              ],
            ),
          ),
          // Bottom navigation bar
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(EncyclopediaSection section) {
    switch (section.sectionType) {
      case SectionType.commonInjuries:
        return BlocBuilder<CommonInjuriesBloc, CommonInjuriesState>(
          builder: (context, state) {
            if (state is CommonInjuriesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF019193)),
                  ),
                ),
              );
            } else if (state is CommonInjuriesLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.injuries.map((injury) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _InjuryCard(injury: injury),
                      )),
                ],
              );
            } else if (state is CommonInjuriesError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      case SectionType.prevention:
        return BlocBuilder<PreventionTipsBloc, PreventionTipsState>(
          builder: (context, state) {
            if (state is PreventionTipsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C897)),
                  ),
                ),
              );
            } else if (state is PreventionTipsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PreventionTipCard(tip: tip),
                      )),
                ],
              );
            } else if (state is PreventionTipsError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      case SectionType.myths:
        return BlocBuilder<MythsBloc, MythsState>(
          builder: (context, state) {
            if (state is MythsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE67F0D)),
                  ),
                ),
              );
            } else if (state is MythsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.myths.map((myth) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MythCard(myth: myth),
                      )),
                ],
              );
            } else if (state is MythsError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      case SectionType.glossary:
        return BlocBuilder<GlossaryBloc, GlossaryState>(
          builder: (context, state) {
            if (state is GlossaryLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B59B6)),
                  ),
                ),
              );
            } else if (state is GlossaryLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...state.terms.map((term) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GlossaryTermCard(term: term),
                      )),
                ],
              );
            } else if (state is GlossaryError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
    }
  }
}

enum SectionType {
  commonInjuries,
  prevention,
  myths,
  glossary,
}

class EncyclopediaSection {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final SectionType sectionType;

  EncyclopediaSection({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.sectionType,
  });
}

// Reusable card widgets (simplified versions from the individual screens)
class _InjuryCard extends StatefulWidget {
  final dynamic injury;

  const _InjuryCard({required this.injury});

  @override
  State<_InjuryCard> createState() => _InjuryCardState();
}

class _InjuryCardState extends State<_InjuryCard> {
  bool _isExpanded = false;
  final accent = const Color(0xFF019193);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.injury.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.injury.bodyLocation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        children: [
          _buildSection('Descripción', widget.injury.description, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Causas', widget.injury.causes, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Síntomas', widget.injury.symptoms, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Recomendaciones', widget.injury.recommendations, accent),
          const SizedBox(height: 16),
          _buildInfoBox(
            'Recuperación estimada: ${widget.injury.recoveryDays} días\nSeveridad: ${widget.injury.severity}',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: accent, fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInfoBox(String content) {
    final isSevere = content.contains('ALTO');
    final isMedium = content.contains('MEDIO');
    final Color boxColor = isSevere ? Colors.red : isMedium ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor.withOpacity(0.15),
        border: Border.all(color: boxColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: TextStyle(color: boxColor, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _PreventionTipCard extends StatefulWidget {
  final dynamic tip;

  const _PreventionTipCard({required this.tip});

  @override
  State<_PreventionTipCard> createState() => _PreventionTipCardState();
}

class _PreventionTipCardState extends State<_PreventionTipCard> {
  bool _isExpanded = false;
  final accent = const Color(0xFF00C897);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greySurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tip.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.tip.sport,
                style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        children: [
          _buildSection('Descripción', widget.tip.description, accent),
          const SizedBox(height: 16),
          _buildBulletSection('Consejos', widget.tip.tips, accent),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓ ', style: TextStyle(color: accent, fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _MythCard extends StatefulWidget {
  final dynamic myth;

  const _MythCard({required this.myth});

  @override
  State<_MythCard> createState() => _MythCardState();
}

class _MythCardState extends State<_MythCard> {
  bool _isExpanded = false;
  final accent = const Color(0xFFE67F0D);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greySurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Creencia errónea:',
              style: TextStyle(color: Color(0xFFE67F0D), fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              widget.myth.myth,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A5F4A).withOpacity(0.2),
              border: Border.all(color: const Color(0xFF4CAF50), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realidad científica',
                  style: TextStyle(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.myth.reality,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explicación', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                widget.myth.explanation,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlossaryTermCard extends StatefulWidget {
  final dynamic term;

  const _GlossaryTermCard({required this.term});

  @override
  State<_GlossaryTermCard> createState() => _GlossaryTermCardState();
}

class _GlossaryTermCardState extends State<_GlossaryTermCard> {
  bool _isExpanded = false;
  final accent = const Color(0xFF9B59B6);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.greySurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.term.term,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.term.category,
                style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Definición', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                widget.term.definition,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ejemplo', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                widget.term.example,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
