import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/injury_evaluation_service.dart';
import '../bloc/injury_location_bloc.dart';

class InjuryLocationScreen extends StatefulWidget {
  final String userId;

  const InjuryLocationScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<InjuryLocationScreen> createState() => _InjuryLocationScreenState();
}

class _InjuryLocationScreenState extends State<InjuryLocationScreen> {
  String? selectedLocation;
  String? selectedSide;

  final List<String> locations = [
    'Cabeza/Cuello',
    'Hombro/Brazo',
    'Muñeca/Mano',
    'Espalda/Columna',
    'Cadera/Pelvis',
    'Rodilla',
    'Tobillo/Pie',
  ];

  final List<String> sides = ['Izquierdo', 'Derecho', 'Ambos'];

  final Map<String, IconData> locationIcons = {
    'Cabeza/Cuello': Icons.headset,
    'Hombro/Brazo': Icons.accessibility_new,
    'Muñeca/Mano': Icons.pan_tool,
    'Espalda/Columna': Icons.straighten,
    'Cadera/Pelvis': Icons.accessibility,
    'Rodilla': Icons.accessibility,
    'Tobillo/Pie': Icons.directions_walk,
  };

  bool get isFormValid => selectedLocation != null && selectedSide != null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No puedes volver atrás. Completa la evaluación o reinicia.',
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1F242A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F242A),
          elevation: 0,
          leading: const SizedBox.shrink(),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Dónde sientes la molestia?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Paso 1 de 6',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de progreso
                _buildProgressBar(),
                const SizedBox(height: 24),

                // Pregunta principal
                const Text(
                  'Selecciona la zona afectada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Grid de ubicaciones
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: locations
                      .map((location) => _buildLocationButton(location))
                      .toList(),
                ),

                const SizedBox(height: 32),

                // Pregunta adicional
                const Text(
                  '¿Es en el lado izquierdo o derecho del cuerpo?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Opciones de lado
                Column(
                  children: sides
                      .map((side) => _buildSideOption(side))
                      .toList(),
                ),

                const SizedBox(height: 32),

                // Botón siguiente
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            // Guardar datos en el singleton
                            final service = InjuryEvaluationService();
                            service.location = selectedLocation;
                            service.side = selectedSide;

                            context.read<InjuryLocationBloc>().add(
                                  SaveInjuryLocationEvent(
                                    location: selectedLocation!,
                                    side: selectedSide!,
                                  ),
                                );
                            Navigator.of(context)
                                .pushNamed('/injury_mechanism');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFFF),
                      disabledBackgroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'SIGUIENTE',
                      style: TextStyle(
                        color: isFormValid ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: 1 / 6,
        minHeight: 6,
        backgroundColor: Colors.grey[700],
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FFFF)),
      ),
    );
  }

  Widget _buildLocationButton(String location) {
    final isSelected = selectedLocation == location;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLocation = location;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00FFFF) : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00FFFF) : Colors.grey[700]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              locationIcons[location] ?? Icons.location_on,
              color: isSelected ? Colors.black : const Color(0xFF00FFFF),
              size: 32,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                location,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideOption(String side) {
    final isSelected = selectedSide == side;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSide = side;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00FFFF).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF00FFFF) : Colors.grey[600]!,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF00FFFF) : Colors.grey[600]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          color: Color(0xFF00FFFF),
                          size: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                side,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
