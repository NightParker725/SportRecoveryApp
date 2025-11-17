// Mock data for development and testing

const mockInjuryEducations = [
  // Rodilla
  {
    'id': '1',
    'body_location': 'Rodilla',
    'name': 'Esguince de ligamentos',
    'description':
        'Lesión en los ligamentos que conectan los huesos de la rodilla. Los ligamentos pueden estirarse o romperse parcialmente.',
    'causes': ['Cambio de dirección brusco', 'Impacto directo', 'Movimiento forzado'],
    'symptoms': ['Dolor agudo', 'Inflamación', 'Inestabilidad', 'Dificultad para caminar'],
    'recommendations': ['Reposo inmediato', 'Hielo (15 min cada 2 horas)', 'Compresión con vendaje', 'Elevación', 'Consultar especialista'],
    'recovery_days': 21,
    'severity': 'MEDIO',
  },
  {
    'id': '2',
    'body_location': 'Rodilla',
    'name': 'Tendinitis rotuliana',
    'description':
        'Inflamación del tendón rotuliano que conecta la rótula con la tibia. Es común en deportistas de salto.',
    'causes': ['Sobrecarga', 'Cambios en entrenamiento', 'Desequilibrio muscular', 'Alineación incorrecta'],
    'symptoms': ['Dolor bajo la rótula', 'Rigidez matutina', 'Inflamación leve', 'Dolor al saltar'],
    'recommendations': ['Reducir actividad', 'Fortalecimiento muscular', 'Estiramientos', 'Hielo post-actividad', 'Fisioterapia'],
    'recovery_days': 28,
    'severity': 'BAJO',
  },
  // Tobillo
  {
    'id': '3',
    'body_location': 'Tobillo',
    'name': 'Esguince de tobillo',
    'description':
        'Lesión de los ligamentos laterales del tobillo. Ocurre cuando el pie se tuerce más allá de su rango normal de movimiento.',
    'causes': ['Pisada incorrecta', 'Terreno irregular', 'Caída', 'Giro brusco'],
    'symptoms': ['Dolor intenso', 'Hinchazón rápida', 'Moretones', 'Dificultad para apoyar el pie'],
    'recommendations': ['RICE protocol (Reposo, Hielo, Compresión, Elevación)', 'Vendaje de tobillo', 'Muletas si es necesario', 'Radiografías para descartar fractura'],
    'recovery_days': 14,
    'severity': 'LEVE',
  },
  {
    'id': '4',
    'body_location': 'Tobillo',
    'name': 'Tendinitis de Aquiles',
    'description':
        'Inflamación del tendón de Aquiles. Es una lesión común en corredores y saltadores.',
    'causes': ['Sobrecarga gradual', 'Aumento rápido de actividad', 'Apretamiento muscular', 'Calzado inadecuado'],
    'symptoms': ['Dolor en el talón', 'Rigidez matutina', 'Chasquidos al mover', 'Inflamación leve'],
    'recommendations': ['Reposo relativo', 'Hielo regularmente', 'Estiramientos suaves', 'Fortalecimiento excéntrico', 'Uso de talonera'],
    'recovery_days': 35,
    'severity': 'BAJO',
  },
  // Hombro
  {
    'id': '5',
    'body_location': 'Hombro',
    'name': 'Tendinitis del manguito rotador',
    'description':
        'Inflamación de los tendones del manguito rotador. Afecta la movilidad y estabilidad del hombro.',
    'causes': ['Movimientos repetitivos', 'Sobrecarga', 'Debilidad muscular', 'Mala postura'],
    'symptoms': ['Dolor al levantar el brazo', 'Debilidad', 'Rango de movimiento limitado', 'Dolor nocturno'],
    'recommendations': ['Reposo de actividades que causen dolor', 'Terapia física', 'Fortalecimiento del manguito rotador', 'Estiramientos suaves', 'Antiinflamatorios'],
    'recovery_days': 42,
    'severity': 'MEDIO',
  },
  // Espalda
  {
    'id': '6',
    'body_location': 'Espalda baja',
    'name': 'Esguince lumbar',
    'description':
        'Lesión de los ligamentos y músculos de la espalda baja. Generalmente causada por movimientos bruscos o levantamiento inadecuado.',
    'causes': ['Levantamiento incorrecto', 'Movimiento brusco', 'Caída', 'Sobrecarga'],
    'symptoms': ['Dolor agudo en la espalda baja', 'Rigidez', 'Espasmos musculares', 'Dificultad para moverse'],
    'recommendations': ['Reposo en los primeros días', 'Hielo inicialmente, luego calor', 'Medicamentos antiinflamatorios', 'Terapia física gradual', 'Mejorar ergonomía'],
    'recovery_days': 30,
    'severity': 'MEDIO',
  },
];

const mockPreventionTips = [
  {
    'id': '1',
    'sport': 'Fútbol',
    'title': 'Calentamiento dinámico antes de jugar',
    'description':
        'El calentamiento adecuado prepara los músculos y articulaciones para la actividad, reduciendo significativamente el riesgo de lesiones.',
    'tips': [
      'Trote ligero por 5 minutos',
      'Movimientos de piernas (levantamiento de rodillas, talones a glúteos)',
      'Rotaciones articulares (tobillos, rodillas, caderas)',
      'Estiramientos dinámicos',
      'Movimientos técnicos a baja velocidad'
    ],
  },
  {
    'id': '2',
    'sport': 'Fútbol',
    'title': 'Fortalecimiento de core y piernas',
    'description':
        'Un core fuerte proporciona estabilidad y previene lesiones de espalda y rodilla.',
    'tips': [
      'Ejercicios de abdominales',
      'Sentadillas y estocadas',
      'Ejercicios de equilibrio',
      'Planchas laterales',
      '2-3 sesiones de fortalecimiento por semana'
    ],
  },
  {
    'id': '3',
    'sport': 'Basquetbol',
    'title': 'Prevención de esguinces de tobillo',
    'description':
        'Los tobillos son críticos en basquetbol. Un tobillo fuerte y flexible reduce el riesgo de lesión.',
    'tips': [
      'Ejercicios de equilibrio en una sola pierna',
      'Fortalecimiento de pantorrillas',
      'Ejercicios propioceptivos',
      'Uso de tobilleras de soporte',
      'Calzado de basquetbol de calidad con soporte'
    ],
  },
  {
    'id': '4',
    'sport': 'Basquetbol',
    'title': 'Técnica adecuada de salto y aterrizaje',
    'description':
        'Una técnica correcta reduce el impacto en articulaciones y previene lesiones de rodilla y tobillo.',
    'tips': [
      'Distribuir el peso en los antepies',
      'Doblar rodillas al aterrizar',
      'Mantener tronco erguido',
      'Aterrizar sobre ambas piernas',
      'Evitar rotaciones de rodilla al aterrizar'
    ],
  },
  {
    'id': '5',
    'sport': 'Tenis',
    'title': 'Codo de tenista (prevención)',
    'description':
        'El epicondilitis lateral es común en tenistas. La prevención se enfoca en técnica y fortalecimiento.',
    'tips': [
      'Revisar la técnica de golpe',
      'Usar raqueta de peso y tamaño correcto',
      'Fortalecimiento del antebrazo',
      'Estiramientos de muñeca y antebrazo',
      'Aumentar intensidad gradualmente'
    ],
  },
  {
    'id': '6',
    'sport': 'Carrera',
    'title': 'Prevención de lesiones de rodilla en corredores',
    'description':
        'Las lesiones de rodilla son comunes en corredores. La prevención requiere atención a forma, equipo y entrenamiento.',
    'tips': [
      'Revisar la biomecánica de carrera',
      'Usar zapatillas apropiadas para tu tipo de pie',
      'Aumentar distancia gradualmente (regla del 10%)',
      'Fortalecimiento de glúteos y caderas',
      'Incluir días de descanso'
    ],
  },
];

const mockMyths = [
  {
    'id': '1',
    'myth': 'El dolor indica que el tratamiento está funcionando',
    'reality': 'El dolor es una señal de que algo está mal. No debes ejercitarte con dolor agudo.',
    'explanation':
        'Aunque cierto dolor muscular es normal después del ejercicio intenso, el dolor agudo o persistente indica una lesión que requiere descanso. Continuar ejercitándose con dolor puede empeorar la lesión.',
  },
  {
    'id': '2',
    'myth': 'Debes entrenar a través del dolor ("No pain, no gain")',
    'reality': 'Entrenar con dolor puede empeorar la lesión y prolongar la recuperación.',
    'explanation':
        'El descanso es parte fundamental de la recuperación. Los mejores atletas saben cuándo entrenar y cuándo descansar. Un entrenamiento inteligente es más efectivo que un entrenamiento a través del dolor.',
  },
  {
    'id': '3',
    'myth': 'El hielo es suficiente para toda lesión',
    'reality': 'El hielo es solo una parte del protocolo RICE y debe usarse correctamente.',
    'explanation':
        'El protocolo RICE (Reposo, Hielo, Compresión, Elevación) es más efectivo que hielo solo. El tiempo de aplicación es importante: máximo 15-20 minutos para evitar daño tisular. Después de 48-72 horas, el calor puede ser más beneficioso.',
  },
  {
    'id': '4',
    'myth': 'Una lesión siempre requiere cirugía',
    'reality': 'La mayoría de lesiones deportivas se tratan exitosamente sin cirugía.',
    'explanation':
        'Aproximadamente el 80-90% de las lesiones deportivas responden bien a tratamiento conservador: reposo, fisioterapia, ejercicio progresivo. La cirugía es considerada cuando el tratamiento conservador falla.',
  },
  {
    'id': '5',
    'myth': 'Puedes lesionarte jugando un deporte',
    'reality': 'La lesión ocurre más por falta de preparación que por el deporte en sí.',
    'explanation':
        'Los atletas lesionados frecuentemente tenían debilidades previas, falta de flexibilidad, o no tenían un calentamiento adecuado. El acondicionamiento físico previo y la técnica correcta previenen la mayoría de lesiones.',
  },
  {
    'id': '6',
    'myth': 'Estirar cuando está lesionado ayuda',
    'reality': 'Los estiramientos agresivos en una lesión aguda pueden empeorar la inflamación.',
    'explanation':
        'Inmediatamente después de una lesión, es mejor descansar. Una vez que la inflamación aguda ha disminuido (después de 48 horas), los estiramientos suaves y controlados son beneficiosos.',
  },
];

const mockGlossaryTerms = [
  {
    'id': '1',
    'term': 'Esguince',
    'definition':
        'Lesión de los ligamentos que conectan los huesos. Los ligamentos se estiran o se rompen parcialmente sin luxar la articulación.',
    'example':
        'Un esguince de tobillo ocurre cuando el pie se tuerce más allá de su rango normal y los ligamentos se estiran.',
    'category': 'Tipos de lesiones',
  },
  {
    'id': '2',
    'term': 'Distensión',
    'definition':
        'Lesión de un músculo o tendón por estiramiento excesivo. Los músculos se estiran o se rompen parcialmente.',
    'example':
        'Una distensión de isquiotibiales es común en atletas que corren a velocidad sin calentar adecuadamente.',
    'category': 'Tipos de lesiones',
  },
  {
    'id': '3',
    'term': 'Inflamación',
    'definition':
        'Respuesta del cuerpo ante una lesión o irritación caracterizada por enrojecimiento, calor, hinchazón y dolor.',
    'example':
        'La inflamación después de una lesión es normal y protector, pero si es excesiva puede limitar el movimiento.',
    'category': 'Procesos de recuperación',
  },
  {
    'id': '4',
    'term': 'Tendinitis',
    'definition':
        'Inflamación de un tendón, el tejido que conecta el músculo con el hueso. Generalmente causada por sobrecarga o uso repetitivo.',
    'example':
        'La tendinitis rotuliana afecta al tendón bajo la rótula, común en atletas que saltan regularmente.',
    'category': 'Tipos de lesiones',
  },
  {
    'id': '5',
    'term': 'Propioceptiva',
    'definition':
        'Capacidad del cuerpo de percibir su posición en el espacio. Es crucial para el equilibrio, la coordinación y la estabilidad.',
    'example':
        'Los ejercicios propioceptivos como estar de pie en una sola pierna mejoran la capacidad del tobillo para prevenir torceduras.',
    'category': 'Funciones corporales',
  },
  {
    'id': '6',
    'term': 'Luxación',
    'definition':
        'Desplazamiento completo de una articulación donde los huesos se salen de su posición normal.',
    'example':
        'Una luxación de hombro es más grave que un esguince porque la articulación se desalinea completamente.',
    'category': 'Tipos de lesiones',
  },
  {
    'id': '7',
    'term': 'Protocolo RICE',
    'definition':
        'Protocolo de primeros auxilios: Reposo, Hielo, Compresión, Elevación. Es el tratamiento inicial estándar para lesiones deportivas.',
    'example':
        'Después de un esguince de tobillo, aplicar RICE dentro de las primeras 48 horas reduce inflamación y acelera recuperación.',
    'category': 'Tratamiento',
  },
  {
    'id': '8',
    'term': 'Fisioterapia',
    'definition':
        'Tratamiento de lesiones mediante ejercicio, estiramiento y otras técnicas para restaurar función y prevenir discapacidad.',
    'example':
        'Un paciente con lesión de rodilla recibe fisioterapia para fortalecer los músculos alrededor de la rodilla y restaurar movimiento.',
    'category': 'Tratamiento',
  },
];
