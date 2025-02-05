# Flutter Project: DevPaul ToDo App

DevPaul ToDo is a responsive Flutter app (Web & Android) for activity management. It features Firebase Auth, Firestore, and Storage integration, and leverages DeepSeek AI to generate step-by-step solution suggestions based on task details.

This repository contains a cross-platform application (Web & Android) developed in **Flutter** for efficient activity management. The app allows users to **create, view, edit, and filter** tasks while synchronizing data with **Firebase** for authentication, secure storage, and media hosting.

---

## Main Features

1. **Firebase Integration**  
   - Secure activity storage with Firestore.  
   - User authentication via Firebase Auth.  
   - Media hosting using Firebase Storage.

2. **Activity Management**  
   - Register tasks with details such as type, description, due date/time, and classification (Urgent, Important, Not urgent, Not important).  
   - Edit and update activities seamlessly.

3. **DeepSeek AI Integration**  
   - Automatically generates step-by-step solution suggestions for each task by calling the DeepSeek AI API based on the task's type and description.

---

## Getting Started

1. **Clone the repository**  

   ```bash
   git clone https://github.com/usuario/flutter-asistencias-diego-lopez.git
   cd flutter-asistencias-diego-lopez
   ```

2. **Instalar Dependencias**

   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
- Crea un proyecto en Firebase Console.
- Añade una aplicación Android y/o Web según corresponda.
- Descarga el archivo google-services.json (Android) y/o firebaseConfig (Web) y colócalo en la carpeta adecuada:
  - Android: /android/app/
  - Web: /web/
- Actualiza los archivos de configuración de tu proyecto para reflejar la información de tu app en Firebase.

4. **Ejecutar la Aplicación**
- En Android, conecta tu dispositivo o usa un emulador y corre el siguiente comando:
   ```bash
   flutter run
   ```
- Para web, usa el siguiente comando para iniciar el servidor de desarrollo:
   ```bash
   flutter run -d chrome
   ```

---
## Uso de la Aplicación
- Pantalla de Inicio de Sesión (opcional)
Autenticación para garantizar el acceso solo a usuarios autorizados (instructores/administradores).

- Registro de Asistencia
1. Ingresa la Cédula del estudiante.
2. Si ya existe el estudiante en la base de datos, se autocompletarán los campos de Nombre y Teléfono.
3. Selecciona el Tipo de Clase (adaptación, ética, técnicas, práctica, marco legal, taller).
4. Registra la Fecha/Hora y la Cantidad de Horas.
5. Recopila la Firma del estudiante.
6. Guarda el registro en Firebase.

- Visualización y Reportes (Web)
  - Accede a la versión web para consultar todos los registros.
  - Filtra por rango de fechas, tipo de clase, estudiante, etc.
  - Visualiza los detalles de cada asistencia y exporta (módulo adicional) la información en PDF.

## Project Structure

```vbnet
flutter-asistencias-diego-lopez/
├── android/
├── ios/
├── web/
├── lib/
│   ├── models/
│   ├── services/
│   ├── pages/
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```
- assets/: Contains images, icons, and screenshots used in the application.
- lib/: Main source code of the application.
- core/validators/: Contains input validation logic.
- domain/entities/: Defines data models.
- presentation/: UI layer with providers, shared components, and views.
- providers/: State management providers.
- shared/: Reusable widgets and components.
- views/: Different views for large, medium, and small screens.
- web/: Web-specific configurations and assets.
- test/: Contains unit and widget tests.
- pubspec.yaml: Project dependencies and configurations.

## Technologies Used
- Flutter: UI toolkit for building natively compiled applications.
- Dart: Programming language optimized for UI.
- Google Fonts: For custom typography.
- url_launcher: To handle URL launching for the contact form.
- Flutter Localization: For multilingual support.

## Contributing
Contributions are welcome! Follow these steps to get started:

1. **Fork the Repository**

2. **Create a Feature Branch

   ```bash
     git checkout -b feature/YourFeatureName
   ```
3. **Commit Your Changes**

   ```bash
     git commit -m "Add some feature"
   ```
4. **Push to the Branch**

   ```bash
     git push origin feature/YourFeatureName
   ```
   This command will launch the portfolio in your default web browser.
5. **OPen a Pull Request**

## License
This project is licensed under the MIT License.

## Contact
Developed by:
- Paul Realpe
- Jimmy Realpe

Email: co.devpaul@gmail.com

Phone: 3148580454

<a  href="https://devpaul.pro">https://devpaul.pro/</a>

Feel free to reach out for any inquiries or collaborations!