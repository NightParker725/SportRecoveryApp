# Guía de Migración: Feature Education - Mock Data a Supabase

## 1. Estado Actual

La feature Education actualmente utiliza **datos mockeados** alojados en `lib/features/education/data/datasources/mock_education_data.dart`.

### Ubicación del Flag de Control

El archivo `EducationDataSourceImpl` en `lib/features/education/data/datasources/education_datasource_impl.dart` contiene un parámetro `useMockData`:

```dart
EducationDataSourceImpl({
  required this.supabaseClient,
  this.useMockData = false,  // ← AQUÍ (por defecto es false)
});
```

Actualmente está configurado como `false`, lo que significa que intenta consultar a Supabase, pero **las tablas no existen**, causando errores.

---

## 2. Cambios Necesarios en el Código

### 2.1 Cambiar el Flag para Usar Mock Data (Temporal)

Mientras se configuran las tablas en Supabase, puedes usar los datos mockeados:

**Ubicación**: `lib/features/education/data/datasources/education_datasource_impl.dart`

Encuentra donde se instancia `EducationDataSourceImpl` (probablemente en un service locator o en main.dart) y cambia:

```dart
// ACTUAL (intenta usar Supabase)
EducationDataSourceImpl(
  supabaseClient: supabaseClient,
  useMockData: false,
)

// TEMPORAL (mientras configuras Supabase)
EducationDataSourceImpl(
  supabaseClient: supabaseClient,
  useMockData: true,  // ← Cambiar a true
)
```

### 2.2 Cambiar a Supabase (Después de Crear las Tablas)

Una vez hayas creado las tablas en Supabase e insertado los datos:

```dart
EducationDataSourceImpl(
  supabaseClient: supabaseClient,
  useMockData: false,  // ← Cambiar a false
)
```

No es necesario cambiar ningún otro código. La implementación ya soporta Supabase.

---

## 3. Schema de Supabase

Crea las siguientes 4 tablas en tu proyecto Supabase:

### 3.1 Tabla: `injury_educations`

```sql
CREATE TABLE IF NOT EXISTS public.injury_educations (
  id TEXT PRIMARY KEY,
  body_location TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  causes TEXT[] NOT NULL DEFAULT '{}',
  symptoms TEXT[] NOT NULL DEFAULT '{}',
  recommendations TEXT[] NOT NULL DEFAULT '{}',
  recovery_days INTEGER NOT NULL,
  severity TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);
```

**Índices recomendados:**
```sql
CREATE INDEX idx_injury_educations_body_location ON injury_educations(body_location);
```

---

### 3.2 Tabla: `prevention_tips`

```sql
CREATE TABLE IF NOT EXISTS public.prevention_tips (
  id TEXT PRIMARY KEY,
  sport TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  tips TEXT[] NOT NULL DEFAULT '{}',
  created_at TIMESTAMP DEFAULT now()
);
```

**Índices recomendados:**
```sql
CREATE INDEX idx_prevention_tips_sport ON prevention_tips(sport);
```

---

### 3.3 Tabla: `myths`

```sql
CREATE TABLE IF NOT EXISTS public.myths (
  id TEXT PRIMARY KEY,
  myth TEXT NOT NULL,
  reality TEXT NOT NULL,
  explanation TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);
```

---

### 3.4 Tabla: `glossary_terms`

```sql
CREATE TABLE IF NOT EXISTS public.glossary_terms (
  id TEXT PRIMARY KEY,
  term TEXT NOT NULL,
  definition TEXT NOT NULL,
  example TEXT NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);
```

**Índices recomendados:**
```sql
CREATE INDEX idx_glossary_terms_category ON glossary_terms(category);
CREATE INDEX idx_glossary_terms_term ON glossary_terms(term);
```

---

## 4. Inserción de Datos

### 4.1 Via Supabase SQL Editor

Copia y ejecuta los siguientes scripts SQL en el **SQL Editor** de Supabase:

#### Insertar Injury Educations

```sql
INSERT INTO public.injury_educations (id, body_location, name, description, causes, symptoms, recommendations, recovery_days, severity)
VALUES
  ('1', 'Rodilla', 'Esguince de ligamentos', 'Lesión en los ligamentos que conectan los huesos de la rodilla. Los ligamentos pueden estirarse o romperse parcialmente.', ARRAY['Cambio de dirección brusco', 'Impacto directo', 'Movimiento forzado'], ARRAY['Dolor agudo', 'Inflamación', 'Inestabilidad', 'Dificultad para caminar'], ARRAY['Reposo inmediato', 'Hielo (15 min cada 2 horas)', 'Compresión con vendaje', 'Elevación', 'Consultar especialista'], 21, 'MEDIO'),
  ('2', 'Rodilla', 'Tendinitis rotuliana', 'Inflamación del tendón rotuliano que conecta la rótula con la tibia. Es común en deportistas de salto.', ARRAY['Sobrecarga', 'Cambios en entrenamiento', 'Desequilibrio muscular', 'Alineación incorrecta'], ARRAY['Dolor bajo la rótula', 'Rigidez matutina', 'Inflamación leve', 'Dolor al saltar'], ARRAY['Reducir actividad', 'Fortalecimiento muscular', 'Estiramientos', 'Hielo post-actividad', 'Fisioterapia'], 28, 'BAJO'),
  ('3', 'Tobillo', 'Esguince de tobillo', 'Lesión de los ligamentos laterales del tobillo. Ocurre cuando el pie se tuerce más allá de su rango normal de movimiento.', ARRAY['Pisada incorrecta', 'Terreno irregular', 'Caída', 'Giro brusco'], ARRAY['Dolor intenso', 'Hinchazón rápida', 'Moretones', 'Dificultad para apoyar el pie'], ARRAY['RICE protocol (Reposo, Hielo, Compresión, Elevación)', 'Vendaje de tobillo', 'Muletas si es necesario', 'Radiografías para descartar fractura'], 14, 'LEVE'),
  ('4', 'Tobillo', 'Tendinitis de Aquiles', 'Inflamación del tendón de Aquiles. Es una lesión común en corredores y saltadores.', ARRAY['Sobrecarga gradual', 'Aumento rápido de actividad', 'Apretamiento muscular', 'Calzado inadecuado'], ARRAY['Dolor en el talón', 'Rigidez matutina', 'Chasquidos al mover', 'Inflamación leve'], ARRAY['Reposo relativo', 'Hielo regularmente', 'Estiramientos suaves', 'Fortalecimiento excéntrico', 'Uso de talonera'], 35, 'BAJO'),
  ('5', 'Hombro', 'Tendinitis del manguito rotador', 'Inflamación de los tendones del manguito rotador. Afecta la movilidad y estabilidad del hombro.', ARRAY['Movimientos repetitivos', 'Sobrecarga', 'Debilidad muscular', 'Mala postura'], ARRAY['Dolor al levantar el brazo', 'Debilidad', 'Rango de movimiento limitado', 'Dolor nocturno'], ARRAY['Reposo de actividades que causen dolor', 'Terapia física', 'Fortalecimiento del manguito rotador', 'Estiramientos suaves', 'Antiinflamatorios'], 42, 'MEDIO'),
  ('6', 'Espalda baja', 'Esguince lumbar', 'Lesión de los ligamentos y músculos de la espalda baja. Generalmente causada por movimientos bruscos o levantamiento inadecuado.', ARRAY['Levantamiento incorrecto', 'Movimiento brusco', 'Caída', 'Sobrecarga'], ARRAY['Dolor agudo en la espalda baja', 'Rigidez', 'Espasmos musculares', 'Dificultad para moverse'], ARRAY['Reposo en los primeros días', 'Hielo inicialmente, luego calor', 'Medicamentos antiinflamatorios', 'Terapia física gradual', 'Mejorar ergonomía'], 30, 'MEDIO');
```

#### Insertar Prevention Tips

```sql
INSERT INTO public.prevention_tips (id, sport, title, description, tips)
VALUES
  ('1', 'Fútbol', 'Calentamiento dinámico antes de jugar', 'El calentamiento adecuado prepara los músculos y articulaciones para la actividad, reduciendo significativamente el riesgo de lesiones.', ARRAY['Trote ligero por 5 minutos', 'Movimientos de piernas (levantamiento de rodillas, talones a glúteos)', 'Rotaciones articulares (tobillos, rodillas, caderas)', 'Estiramientos dinámicos', 'Movimientos técnicos a baja velocidad']),
  ('2', 'Fútbol', 'Fortalecimiento de core y piernas', 'Un core fuerte proporciona estabilidad y previene lesiones de espalda y rodilla.', ARRAY['Ejercicios de abdominales', 'Sentadillas y estocadas', 'Ejercicios de equilibrio', 'Planchas laterales', '2-3 sesiones de fortalecimiento por semana']),
  ('3', 'Basquetbol', 'Prevención de esguinces de tobillo', 'Los tobillos son críticos en basquetbol. Un tobillo fuerte y flexible reduce el riesgo de lesión.', ARRAY['Ejercicios de equilibrio en una sola pierna', 'Fortalecimiento de pantorrillas', 'Ejercicios propioceptivos', 'Uso de tobilleras de soporte', 'Calzado de basquetbol de calidad con soporte']),
  ('4', 'Basquetbol', 'Técnica adecuada de salto y aterrizaje', 'Una técnica correcta reduce el impacto en articulaciones y previene lesiones de rodilla y tobillo.', ARRAY['Distribuir el peso en los antepies', 'Doblar rodillas al aterrizar', 'Mantener tronco erguido', 'Aterrizar sobre ambas piernas', 'Evitar rotaciones de rodilla al aterrizar']),
  ('5', 'Tenis', 'Codo de tenista (prevención)', 'El epicondilitis lateral es común en tenistas. La prevención se enfoca en técnica y fortalecimiento.', ARRAY['Revisar la técnica de golpe', 'Usar raqueta de peso y tamaño correcto', 'Fortalecimiento del antebrazo', 'Estiramientos de muñeca y antebrazo', 'Aumentar intensidad gradualmente']),
  ('6', 'Carrera', 'Prevención de lesiones de rodilla en corredores', 'Las lesiones de rodilla son comunes en corredores. La prevención requiere atención a forma, equipo y entrenamiento.', ARRAY['Revisar la biomecánica de carrera', 'Usar zapatillas apropiadas para tu tipo de pie', 'Aumentar distancia gradualmente (regla del 10%)', 'Fortalecimiento de glúteos y caderas', 'Incluir días de descanso']);
```

#### Insertar Myths

```sql
INSERT INTO public.myths (id, myth, reality, explanation)
VALUES
  ('1', 'El dolor indica que el tratamiento está funcionando', 'El dolor es una señal de que algo está mal. No debes ejercitarte con dolor agudo.', 'Aunque cierto dolor muscular es normal después del ejercicio intenso, el dolor agudo o persistente indica una lesión que requiere descanso. Continuar ejercitándose con dolor puede empeorar la lesión.'),
  ('2', 'Debes entrenar a través del dolor ("No pain, no gain")', 'Entrenar con dolor puede empeorar la lesión y prolongar la recuperación.', 'El descanso es parte fundamental de la recuperación. Los mejores atletas saben cuándo entrenar y cuándo descansar. Un entrenamiento inteligente es más efectivo que un entrenamiento a través del dolor.'),
  ('3', 'El hielo es suficiente para toda lesión', 'El hielo es solo una parte del protocolo RICE y debe usarse correctamente.', 'El protocolo RICE (Reposo, Hielo, Compresión, Elevación) es más efectivo que hielo solo. El tiempo de aplicación es importante: máximo 15-20 minutos para evitar daño tisular. Después de 48-72 horas, el calor puede ser más beneficioso.'),
  ('4', 'Una lesión siempre requiere cirugía', 'La mayoría de lesiones deportivas se tratan exitosamente sin cirugía.', 'Aproximadamente el 80-90% de las lesiones deportivas responden bien a tratamiento conservador: reposo, fisioterapia, ejercicio progresivo. La cirugía es considerada cuando el tratamiento conservador falla.'),
  ('5', 'Puedes lesionarte jugando un deporte', 'La lesión ocurre más por falta de preparación que por el deporte en sí.', 'Los atletas lesionados frecuentemente tenían debilidades previas, falta de flexibilidad, o no tenían un calentamiento adecuado. El acondicionamiento físico previo y la técnica correcta previenen la mayoría de lesiones.'),
  ('6', 'Estirar cuando está lesionado ayuda', 'Los estiramientos agresivos en una lesión aguda pueden empeorar la inflamación.', 'Inmediatamente después de una lesión, es mejor descansar. Una vez que la inflamación aguda ha disminuido (después de 48 horas), los estiramientos suaves y controlados son beneficiosos.');
```

#### Insertar Glossary Terms

```sql
INSERT INTO public.glossary_terms (id, term, definition, example, category)
VALUES
  ('1', 'Esguince', 'Lesión de los ligamentos que conectan los huesos. Los ligamentos se estiran o se rompen parcialmente sin luxar la articulación.', 'Un esguince de tobillo ocurre cuando el pie se tuerce más allá de su rango normal y los ligamentos se estiran.', 'Tipos de lesiones'),
  ('2', 'Distensión', 'Lesión de un músculo o tendón por estiramiento excesivo. Los músculos se estiran o se rompen parcialmente.', 'Una distensión de isquiotibiales es común en atletas que corren a velocidad sin calentar adecuadamente.', 'Tipos de lesiones'),
  ('3', 'Inflamación', 'Respuesta del cuerpo ante una lesión o irritación caracterizada por enrojecimiento, calor, hinchazón y dolor.', 'La inflamación después de una lesión es normal y protector, pero si es excesiva puede limitar el movimiento.', 'Procesos de recuperación'),
  ('4', 'Tendinitis', 'Inflamación de un tendón, el tejido que conecta el músculo con el hueso. Generalmente causada por sobrecarga o uso repetitivo.', 'La tendinitis rotuliana afecta al tendón bajo la rótula, común en atletas que saltan regularmente.', 'Tipos de lesiones'),
  ('5', 'Propioceptiva', 'Capacidad del cuerpo de percibir su posición en el espacio. Es crucial para el equilibrio, la coordinación y la estabilidad.', 'Los ejercicios propioceptivos como estar de pie en una sola pierna mejoran la capacidad del tobillo para prevenir torceduras.', 'Funciones corporales'),
  ('6', 'Luxación', 'Desplazamiento completo de una articulación donde los huesos se salen de su posición normal.', 'Una luxación de hombro es más grave que un esguince porque la articulación se desalinea completamente.', 'Tipos de lesiones'),
  ('7', 'Protocolo RICE', 'Protocolo de primeros auxilios: Reposo, Hielo, Compresión, Elevación. Es el tratamiento inicial estándar para lesiones deportivas.', 'Después de un esguince de tobillo, aplicar RICE dentro de las primeras 48 horas reduce inflamación y acelera recuperación.', 'Tratamiento'),
  ('8', 'Fisioterapia', 'Tratamiento de lesiones mediante ejercicio, estiramiento y otras técnicas para restaurar función y prevenir discapacidad.', 'Un paciente con lesión de rodilla recibe fisioterapia para fortalecer los músculos alrededor de la rodilla y restaurar movimiento.', 'Tratamiento');
```

---

### 4.2 Via Supabase Admin Panel (Alternativa)

Si prefieres usar la interfaz gráfica:

1. Ve a **Supabase Dashboard** → **SQL Editor**
2. Copia y ejecuta cada script anterior (copiar/pegar en el editor)
3. Verifica que los datos se insertaron correctamente en la pestaña **Table Editor**

---

## 5. Pasos para Implementar la Migración

### Paso 1: Crear las Tablas

1. Abre tu proyecto en **Supabase Dashboard**
2. Ve a **SQL Editor**
3. Copia y ejecuta el script de creación de tablas (sección 3)
4. Verifica que las 4 tablas aparezcan en **Database** → **Tables**

### Paso 2: Insertar los Datos

1. En **SQL Editor**, copia y ejecuta cada uno de los 4 scripts de inserción (sección 4.1)
2. Ve a **Table Editor** y verifica que los datos están en cada tabla:
   - `injury_educations`: 6 registros
   - `prevention_tips`: 6 registros
   - `myths`: 6 registros
   - `glossary_terms`: 8 registros

### Paso 3: Verificar Permisos RLS (Row Level Security)

**IMPORTANTE**: Si tienes habilitado **Row Level Security (RLS)**, necesitas crear políticas para permitir lectura pública:

```sql
-- Para injury_educations
ALTER TABLE public.injury_educations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.injury_educations
  FOR SELECT USING (true);

-- Para prevention_tips
ALTER TABLE public.prevention_tips ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.prevention_tips
  FOR SELECT USING (true);

-- Para myths
ALTER TABLE public.myths ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.myths
  FOR SELECT USING (true);

-- Para glossary_terms
ALTER TABLE public.glossary_terms ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.glossary_terms
  FOR SELECT USING (true);
```

Si RLS **no está habilitado**, puedes saltar este paso.

### Paso 4: Cambiar el Flag en el Código

En `lib/features/education/data/datasources/education_datasource_impl.dart` (donde se instancia):

```dart
EducationDataSourceImpl(
  supabaseClient: supabaseClient,
  useMockData: false,  // ← Cambiar a false
)
```

### Paso 5: Pruebar la Integración

1. Ejecuta la app: `flutter run`
2. Navega a la pantalla Education
3. Verifica que los datos cargan desde Supabase (sin errores)

---

## 6. Estructura de Datos JSON

Para futuras inserciones, usa este formato JSON:

### Injury Education

```json
{
  "id": "unique-id",
  "body_location": "Nombre de zona corporal",
  "name": "Nombre de la lesión",
  "description": "Descripción detallada",
  "causes": ["causa1", "causa2", "causa3"],
  "symptoms": ["síntoma1", "síntoma2", "síntoma3"],
  "recommendations": ["recomendación1", "recomendación2"],
  "recovery_days": 21,
  "severity": "LEVE|BAJO|MEDIO|ALTO|CRÍTICO"
}
```

### Prevention Tip

```json
{
  "id": "unique-id",
  "sport": "Nombre del deporte",
  "title": "Título del tip",
  "description": "Descripción del tip",
  "tips": ["tip1", "tip2", "tip3", "tip4"]
}
```

### Myth

```json
{
  "id": "unique-id",
  "myth": "Mito/creencia popular",
  "reality": "La realidad",
  "explanation": "Explicación detallada"
}
```

### Glossary Term

```json
{
  "id": "unique-id",
  "term": "Término",
  "definition": "Definición del término",
  "example": "Ejemplo de uso",
  "category": "Categoría (Tipos de lesiones, Tratamiento, etc.)"
}
```

---

## 7. Agregar Más Datos en el Futuro

Para agregar nuevos registros después de la migración inicial:

### Opción A: Via SQL Editor (Recomendado)

```sql
INSERT INTO public.injury_educations (id, body_location, name, description, causes, symptoms, recommendations, recovery_days, severity)
VALUES
  ('7', 'Muñeca', 'Esguince de muñeca', 'Lesión de ligamentos de la muñeca', ARRAY['Caída', 'Impacto directo'], ARRAY['Dolor', 'Inflamación'], ARRAY['Hielo', 'Inmovilización'], 14, 'BAJO');
```

### Opción B: Desde la App (Requiere Implementar Endpoint)

1. Crea un endpoint administrativo en Supabase
2. Implementa un formulario en la app para agregar nuevos datos
3. Usa `supabaseClient.from('injury_educations').insert(newData)`

---

## 8. Troubleshooting

### Error: "No data returned"

- Verifica que las tablas existan en Supabase
- Verifica que los datos se insertaron correctamente
- Verifica que `useMockData: false` está configurado

### Error: "Permission denied"

- Comprueba que las políticas RLS permiten lectura pública
- Si RLS está deshabilitado, ignora este error

### Error: "Connection timeout"

- Verifica que la URL y la key de Supabase sean correctas en `main.dart`
- Comprueba tu conexión a internet

---

## 9. Resumen de Cambios

| Componente | Cambio | Estado |
|-----------|--------|--------|
| Base de datos | Crear 4 nuevas tablas | ✅ Ver Sección 3 |
| Inserción de datos | Ejecutar 4 scripts SQL | ✅ Ver Sección 4 |
| Código Flutter | Cambiar `useMockData: false` | ✅ Cambio mínimo |
| RLS Policies | Crear políticas de lectura | ⚠️ Solo si RLS está habilitado |

---

**Última actualización**: 2025-11-19
**Rama**: feature/education-module
