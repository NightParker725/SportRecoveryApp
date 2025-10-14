Sport Recovery App

Una aplicación móvil para la guía inmediata en el manejo de lesiones deportivas.

📋 Prerrequisitos
Antes de comenzar, asegúrate de tener instalado:
- Flutter (versión 3.0 o superior)
- Android Studio (con emulador configurado)
- Git
- SDK de Android configurado

🛠️ Pasos de Instalación
1. Clonar el Repositorio
bash
    git clone <url-del-repositorio>
    cd SportRecoveryApp

2. Obtener Dependencias
bash
    flutter pub get

3. Solucionar Problema de local.properties (Si aparece)
Si obtienes un error relacionado con local.properties:

- Opción A - Generar automáticamente:

bash
    flutter pub get

- Opción B - Manualmente:

Abre Android Studio

Ve a File > Open y selecciona la carpeta android del proyecto

Android Studio generará automáticamente el archivo

- Opción C - Crear manualmente:

Crea el archivo android/local.properties

Agrega esta línea (ajusta la ruta según tu sistema):

properties
sdk.dir=C:\\Users\\[TU_USUARIO]\\AppData\\Local\\Android\\sdk

4. Verificar Configuración
bash
    flutter doctor
    Asegúrate de que todo esté marcado como correcto (✓).

5. Ejecutar la Aplicación
- Opción A - Con emulador ya abierto:

bash
    flutter run

- Opción B - Abrir emulador y ejecutar:

bash
# Listar emuladores disponibles
    flutter emulators

# Lanzar emulador (ejemplo)
    flutter emulators --launch Pixel_4_API_33

# Ejecutar app
    flutter run

- Opción C - Desde VS Code:

Abre el proyecto en VS Code

Presiona F5 o ve a Run > Start Debugging

Selecciona el emulador cuando te lo pida


📱 Estructura del Proyecto

SportRecoveryApp/
├── lib/
│   ├── features/
│   │   ├── auth/         # Autenticación (login/registro)
│   │   └── profile/      # Perfil de usuario
│   ├── ui/               # Componentes de UI
│   └── main.dart         # Punto de entrada
├── assets/
│   └── images/           # Imágenes y recursos
└── pubspec.yaml          # Configuración y dependencias
