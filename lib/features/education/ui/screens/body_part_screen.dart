import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/ui/widgets/bottom_navigation_bar.dart';
import '../bloc/common_injuries_bloc.dart';
import '../../data/repositories/education_repository_impl.dart';
import '../../data/datasources/education_datasource_impl.dart';
import '../../domain/usecases/view_common_injuries_flow_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pantalla genérica para mostrar información sobre una parte específica del cuerpo
class BodyPartScreen extends StatefulWidget {
  final String partKey;
  final String partName;

  const BodyPartScreen({
    super.key,
    required this.partKey,
    required this.partName,
  });

  @override
  State<BodyPartScreen> createState() => _BodyPartScreenState();
}

class _BodyPartScreenState extends State<BodyPartScreen> {
  // Mapeo de partKey a body_location en las lesiones
  static const Map<String, String> bodyPartMap = {
    'cabeza': 'Cabeza',
    'cuello': 'Cuello',
    'hombro_izquierdo': 'Hombro',
    'hombro_derecho': 'Hombro',
    'pecho': 'Pecho',
    'brazo_izquierdo': 'Brazo',
    'brazo_derecho': 'Brazo',
    'abdomen': 'Abdomen',
    'cadera_izquierda': 'Cadera',
    'cadera_derecha': 'Cadera',
    'muslo_izquierdo': 'Muslo',
    'muslo_derecho': 'Muslo',
    'rodilla_izquierda': 'Rodilla',
    'rodilla_derecha': 'Rodilla',
    'espinilla_izquierda': 'Espinilla',
    'espinilla_derecha': 'Espinilla',
    'tobillo': 'Tobillo',
  };

  late CommonInjuriesBloc _injuriesBloc;

  @override
  void initState() {
    super.initState();
    // Obtener la ubicación del cuerpo correcta basada en partKey
    final bodyLocation = bodyPartMap[widget.partKey];

    // Crear el repositorio e inicializar el BLoC
    final repository = EducationRepositoryImpl(
      educationDataSource: EducationDataSourceImpl(
        supabaseClient: Supabase.instance.client,
        useMockData: true,
      ),
    );

    _injuriesBloc = CommonInjuriesBloc(
      useCase: ViewCommonInjuriesFlowUseCase(repository: repository),
    );

    // Cargar lesiones para esta parte del cuerpo
    _injuriesBloc.add(LoadCommonInjuries(bodyLocation: bodyLocation));
  }

  @override
  void dispose() {
    _injuriesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F242A),
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado con botón de volver y título
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F242A),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.partName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lesiones comunes',
                          style: TextStyle(
                            color: Color(0xFFB0B5BA),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contenido: Lista de lesiones
            Expanded(
              child: BlocBuilder<CommonInjuriesBloc, CommonInjuriesState>(
                bloc: _injuriesBloc,
                builder: (context, state) {
                  if (state is CommonInjuriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF019193)),
                      ),
                    );
                  } else if (state is CommonInjuriesLoaded) {
                    if (state.injuries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 48,
                              color: Color(0xFF666D77),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay lesiones registradas\npara ${widget.partName}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF666D77),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: state.injuries.length,
                      itemBuilder: (context, index) {
                        final injury = state.injuries[index];
                        return _InjuryCard(injury: injury);
                      },
                    );
                  } else if (state is CommonInjuriesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Barra de navegación inferior
            Container(
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF1F242A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            const AppBottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar cada lesión
class _InjuryCard extends StatefulWidget {
  final dynamic injury;

  const _InjuryCard({required this.injury});

  @override
  State<_InjuryCard> createState() => _InjuryCardState();
}

class _InjuryCardState extends State<_InjuryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF2A2F36),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getSeverityColor(widget.injury.severity)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.injury.severity,
                style: TextStyle(
                  color: _getSeverityColor(widget.injury.severity),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Descripción', widget.injury.description),
                const SizedBox(height: 16),
                _buildBulletSection('Causas', widget.injury.causes),
                const SizedBox(height: 16),
                _buildBulletSection('Síntomas', widget.injury.symptoms),
                const SizedBox(height: 16),
                _buildBulletSection(
                  'Recomendaciones',
                  widget.injury.recommendations,
                ),
                const SizedBox(height: 16),
                _buildInfoBox(
                  'Recuperación estimada: ${widget.injury.recoveryDays} días',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF019193),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFFB0B5BA),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF019193),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFF019193),
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFFB0B5BA),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF019193).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFF019193),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Color(0xFF019193),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'ALTO':
        return Colors.red;
      case 'MEDIO':
        return Colors.orange;
      case 'LEVE':
      case 'BAJO':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

