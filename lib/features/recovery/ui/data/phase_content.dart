import 'package:flutter/material.dart';

class PhaseVideo {
  final String thumbnailAsset;
  final String title;
  final String shortDescription;
  final String url;
  const PhaseVideo({
    required this.thumbnailAsset,
    required this.title,
    required this.shortDescription,
    required this.url,
  });
}

class PhaseTopic {
  final String title;
  final String description;
  final PhaseVideo? video; // Optional tutorial
  const PhaseTopic({
    required this.title,
    required this.description,
    this.video,
  });
}

class PhaseContent {
  final int phaseIndex; // 1-based
  final String phaseTitle;
  final String phaseDescription;
  final List<PhaseTopic> topics;
  const PhaseContent({
    required this.phaseIndex,
    required this.phaseTitle,
    required this.phaseDescription,
    required this.topics,
  });
}

const List<PhaseContent> kPhaseContents = [
  PhaseContent(
    phaseIndex: 1,
    phaseTitle: 'Proceso de Recuperación: Fase 1',
    phaseDescription:
        'Ocurre en los primeros 1 a 3 días. El objetivo principal es reducir el dolor y controlar la inflamación. En esta etapa usamos el protocolo RICE (reposo, hielo, compresión, elevación).',
    topics: [
      PhaseTopic(
        title: 'Reposo',
        description:
            'Evita actividades que aumenten el dolor o la inflamación. Prioriza la inmovilidad relativa y protege la zona afectada.',
      ),
      PhaseTopic(
        title: 'Hielo',
        description:
            'Aplicación de frío envuelto en una toalla (bolsas de gel o hielo) durante 10-15 minutos, 3-5 veces al día. Ayuda con la vasoconstricción y disminuye la inflamación.',
        video: PhaseVideo(
          thumbnailAsset: 'assets/images/recovery/1_enabled.png',
          title: 'Aplicación frío - calor',
          shortDescription: 'Tutorial: cómo aplicar compresas de forma segura.',
          url: 'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
        ),
      ),
      PhaseTopic(
        title: 'Compresión y elevación',
        description:
            'Usa un vendaje elástico firme pero cómodo y eleva la extremidad por encima del nivel del corazón para reducir el edema.',
      ),
    ],
  ),
  PhaseContent(
    phaseIndex: 2,
    phaseTitle: 'Proceso de Recuperación: Fase 2',
    phaseDescription:
        'Fase subaguda. Se inicia movilidad suave y fortalecimiento ligero, manteniendo control del dolor. Progresión gradual según tolerancia.',
    topics: [
      PhaseTopic(
        title: 'Movilidad',
        description:
            'Ejercicios de rango de movimiento sin dolor para recuperar amplitud articular.',
      ),
      PhaseTopic(
        title: 'Fuerza ligera',
        description:
            'Trabajo isométrico y cargas bajas enfocadas en la musculatura estabilizadora.',
      ),
      PhaseTopic(
        title: 'Control de dolor',
        description:
            'Continuar con estrategias de manejo del dolor y monitorización de la respuesta al ejercicio.',
      ),
    ],
  ),
  PhaseContent(
    phaseIndex: 3,
    phaseTitle: 'Proceso de Recuperación: Fase 3',
    phaseDescription:
        'Fase funcional/retorno progresivo. Se trabaja potencia, coordinación y gestos específicos del deporte hasta el retorno seguro.',
    topics: [
      PhaseTopic(
        title: 'Fuerza y potencia',
        description:
            'Progresión de cargas, pliometría y potencia, manteniendo una técnica segura.',
      ),
      PhaseTopic(
        title: 'Coordinación',
        description:
            'Ejercicios neuromusculares y de control motor orientados al gesto funcional.',
      ),
      PhaseTopic(
        title: 'Retorno al deporte',
        description:
            'Integración de tareas específicas, test funcionales y criterios de alta.',
      ),
    ],
  ),
];

PhaseContent getPhaseContentByIndex(int phaseIndex) {
  return kPhaseContents.firstWhere(
    (c) => c.phaseIndex == phaseIndex,
    orElse: () => kPhaseContents.first,
  );
}

Color colorForPhaseIndex(int idx) {
  if (idx == 1) return const Color(0xFFE87C38);
  if (idx == 2) return const Color(0xFFD3EE3D);
  return const Color(0xFF00DFC1);
}


