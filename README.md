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
   git clone https://github.com/paulmrg-461/devpaul_todo_app.git
   cd devpaul_todo_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase configuration**
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
## Application Usage

- **Login Screen (Optional)**  
  Provides authentication to ensure access is granted only to authorized users (instructors/administrators).

- **Attendance Registration**  
  1. Enter the student's ID number.  
  2. If the student already exists in the database, the Name and Phone fields will auto-complete.  
  3. Select the Class Type (adaptation, ethics, techniques, practice, legal framework, workshop).  
  4. Record the Date/Time and the Number of Hours.  
  5. Capture the student's signature.  
  6. Save the record in Firebase.

- **Visualization and Reporting (Web)**  
  - Access the web version to review all records.  
  - Filter records by date range, class type, student, etc.  
  - View details of each attendance entry and export the information as PDF (additional module).

---

## Project Structure

```plaintext
devpaul-todo/
├── android/
├── ios/
├── web/
├── lib/
│   ├── config/
│   │   ├── global/
│   │   │   └── app_config.dart         // Global configuration variables/settings
│   │   ├── routes/
│   │   │   └── app_routes.dart         // App route definitions
│   │   └── themes/
│   │       ├── app_theme.dart          // Theme configurations (light/dark, etc.)
│   │       └── colors.dart             // Custom color definitions
│   ├── core/
│   │   ├── firebase/
│   │   │   └── firebase_options.dart   // Firebase configuration options
│   │   ├── helpers/
│   │   │   └── date_helper.dart        // Date formatting and manipulation helpers
│   │   ├── validators/
│   │   │   └── input_validator.dart    // Input validation logic
│   │   └── service_locator.dart        // Dependency injection setup
│   ├── data/
│   │   ├── datasources/
│   │   │   └── remote_data_source.dart // Remote API/Firestore data sources
│   │   ├── models/
│   │   │   └── task_model.dart         // Data model implementations
│   │   └── repositories/
│   │       └── task_repository_impl.dart  // Repository implementations interfacing with data sources
│   ├── domain/
│   │   ├── entities/
│   │   │   └── task.dart               // Core business entities/models
│   │   ├── failures/
│   │   │   └── server_failure.dart     // Error/failure definitions
│   │   ├── repositories/
│   │   │   └── task_repository.dart    // Abstract repository contracts
│   │   └── usecases/
│   │       └── get_tasks_for_day.dart  // Use case implementations for business logic
│   ├── presentation/
│   │   ├── bloc/
│   │   │   ├── task_bloc.dart          // BLoC for task management
│   │   │   ├── task_event.dart         // Events for Task BLoC
│   │   │   └── task_state.dart         // States for Task BLoC
│   │   ├── constants/
│   │   │   └── app_constants.dart      // App-wide constant values
│   │   └── ui/
│   │       ├── screens/
│   │       │   ├── home_page.dart      // Home screen for displaying tasks
│   │       │   ├── login_page.dart     // Login screen for user authentication
│   │       │   └── add_task_dialog.dart// Dialog for adding new tasks
│   │       └── widgets/
│   │           ├── custom_button.dart  // Reusable custom button widget
│   │           └── task_tile.dart      // Widget to display a single task item
│   └── main.dart                       // Application entry point
├── test/
│   ├── unit/
│   │   └── example_test.dart           // Unit tests
│   └── widget/
│       └── home_page_test.dart         // Widget tests for the UI
├── pubspec.yaml                        // Project dependencies and configuration
└── README.md                           // Project documentation
```

## Technologies Used
- Flutter: UI toolkit for building natively compiled applications.
- Dart: Programming language optimized for UI.
- Google Fonts: For custom typography.
- Firebase: Backend as a Service for mobile and web apps.
- Flutter Localization: For multilingual support.
- DeepSeek: AI responses from DeepSeek API

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
5. **Open a Pull Request**

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