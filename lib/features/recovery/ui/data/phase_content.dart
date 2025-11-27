import 'package:flutter/material.dart';

class PhaseVideo {
  final String thumbnailUrl;
  final String title;
  final String shortDescription;
  final String url;
  const PhaseVideo({
    required this.thumbnailUrl,
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
    phaseTitle: 'Fase 1 · Recuperación aguda',
    phaseDescription:
        'Ocurre en los primeros 1 a 3 días. El objetivo principal es reducir el dolor y controlar la inflamación. En esta etapa usamos el protocolo RICE (reposo, hielo, compresión, elevación).',
    topics: [
      PhaseTopic(
        title: 'Reposo',
        description:
            'Evita actividades que aumenten el dolor o la inflamación. Prioriza la inmovilidad relativa y protege la zona afectada.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=600&q=80',
          title: 'Reposo y protección',
          shortDescription: 'Cómo proteger la zona y organizar el reposo inicial.',
          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        ),
      ),
      PhaseTopic(
        title: 'Hielo',
        description:
            'Aplicación de frío envuelto en una toalla (bolsas de gel o hielo) durante 10-15 minutos, 3-5 veces al día. Ayuda con la vasoconstricción y disminuye la inflamación.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=600&q=80',
          title: 'Aplicación frío - calor',
          shortDescription: 'Tutorial: cómo aplicar compresas de forma segura.',
          url: 'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
        ),
      ),
      PhaseTopic(
        title: 'Compresión y elevación',
        description:
            'Usa un vendaje elástico firme pero cómodo y eleva la extremidad por encima del nivel del corazón para reducir el edema.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=600&q=80',
          title: 'Compresión y elevación',
          shortDescription: 'Aplicación correcta del vendaje y elevación segura.',
          url: 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
        ),
      ),
    ],
  ),
  PhaseContent(
    phaseIndex: 2,
    phaseTitle: 'Fase 2 · Adaptación progresiva',
    phaseDescription:
        'Fase subaguda. Se inicia movilidad suave y fortalecimiento ligero, manteniendo control del dolor. Progresión gradual según tolerancia.',
    topics: [
      PhaseTopic(
        title: 'Movilidad',
        description:
            'Ejercicios de rango de movimiento sin dolor para recuperar amplitud articular.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=600&q=80',
          title: 'Movilidad suave',
          shortDescription: 'Secuencia de movilidad sin dolor para articulación.',
          url: 'https://www.youtube.com/watch?v=04854XqcfCY',
        ),
      ),
      PhaseTopic(
        title: 'Fuerza ligera',
        description:
            'Trabajo isométrico y cargas bajas enfocadas en la musculatura estabilizadora.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=600&q=80',
          title: 'Isométricos básicos',
          shortDescription: 'Introducción segura a fuerza isométrica.',
          url: 'https://www.youtube.com/watch?v=oHg5SJYRHA0',
        ),
      ),
      PhaseTopic(
        title: 'Control de dolor',
        description:
            'Continuar con estrategias de manejo del dolor y monitorización de la respuesta al ejercicio.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=600&q=80',
          title: 'Estrategias de control del dolor',
          shortDescription: 'Respiración, pacing y termoterapia.',
          url: 'https://www.youtube.com/watch?v=9bZkp7q19f0',
        ),
      ),
    ],
  ),
  PhaseContent(
    phaseIndex: 3,
    phaseTitle: 'Fase 3 · Retorno funcional',
    phaseDescription:
        'Fase funcional/retorno progresivo. Se trabaja potencia, coordinación y gestos específicos del deporte hasta el retorno seguro.',
    topics: [
      PhaseTopic(
        title: 'Fuerza y potencia',
        description:
            'Progresión de cargas, pliometría y potencia, manteniendo una técnica segura.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1518458028785-8fbcd101ebb9?auto=format&fit=crop&w=600&q=80',
          title: 'Potencia progresiva',
          shortDescription: 'Pliometría básica y carga submáxima.',
          url: 'https://www.youtube.com/watch?v=2vjPBrBU-TM',
        ),
      ),
      PhaseTopic(
        title: 'Coordinación',
        description:
            'Ejercicios neuromusculares y de control motor orientados al gesto funcional.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=600&q=80',
          title: 'Coordinación y control',
          shortDescription: 'Tareas neuromusculares para estabilidad dinámica.',
          url: 'https://www.youtube.com/watch?v=uelHwf8o7_U',
        ),
      ),
      PhaseTopic(
        title: 'Retorno al deporte',
        description:
            'Integración de tareas específicas, test funcionales y criterios de alta.',
        video: PhaseVideo(
          thumbnailUrl: 'https://images.unsplash.com/photo-1507537509458-b8312d35a233?auto=format&fit=crop&w=600&q=80',
          title: 'Retorno progresivo',
          shortDescription: 'Criterios y progresión de retorno al deporte.',
          url: 'https://www.youtube.com/watch?v=60ItHLz5WEA',
        ),
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
  return const Color(0xFF019193);
}


