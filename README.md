Aquí tienes la traducción al inglés de tu README completo:

---

# Hacom Frontend App

[![Flutter](https://img.shields.io/badge/Flutter-3.35.2-blue?logo=flutter\&logoColor=white)](https://flutter.dev)

[![Build](https://github.com/DavidGomezOv/hacom_frontend_app/actions/workflows/flutter_ci.yaml/badge.svg)](https://github.com/tu_usuario/hacom_frontend_app/actions/workflows/flutter_ci.yml)

---

## 📝 Description

Flutter application for vehicle supervision and geolocation functionalities.
Implements Clean Architecture by feature, navigation via routes, state management with BLoC and Cubits, maps and geolocation, authentication and session management with JWT, unit tests and widget tests.

---

## 📦 Project Structure

```
lib/
├── app.dart
├── core/
│   ├── di/
│   │   └── injector.dart
│   ├── errors/
│   │   └── server_failure.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── api_endpoints.dart
│   ├── router/
│   │   └── app_router.dart
│   └── services/
│       └── location_service.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── local/
│   │   │       │   ├── auth_local_datasource_impl.dart
│   │   │       │   └── auth_local_datasource.dart
│   │   │       └── remote/
│   │   │           ├── auth_remote_datasource_impl.dart
│   │   │           └── auth_remote_datasource.dart
│   │   ├── domain/
│   │   │   └── auth_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_cubit.dart
│   │       │   └── auth_state.dart
│   │       ├── login_page.dart
│   │       └── widgets/
│   │           └── login_text_form_field_widget.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── dashboard_page.dart
│   │       └── widgets/
│   │           ├── dashboard_item_button_widget.dart
│   │           └── logout_confirmation_dialog.dart
│   ├── map/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── map_marker_entity.dart
│   │   └── presentation/
│   │       └── map_page.dart
│   ├── places/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── remote/
│   │   │   │       ├── places_remote_datasource_impl.dart
│   │   │   │       └── places_remote_datasource.dart
│   │   │   └── places_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── place_entity.dart
│   │   │   │   └── places_response_entity.dart
│   │   │   └── places_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── places_cubit.dart
│   │       └── places_page.dart
│   ├── splash/
│   │   └── presentation/
│   │       └── splash_page.dart
│   └── supervisor/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── remote/
│       │   │       ├── supervisor_remote_datasource_impl.dart
│       │   │       └── supervisor_remote_datasource.dart
│       │   └── supervisor_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── vehicle_entity.dart
│       │   │   └── vehicles_response_entity.dart
│       │   └── supervisor_repository.dart
│       └── presentation/
│           ├── bloc/
│           │   └── supervisor_cubit.dart
│           └── supervisor_page.dart
├── main.dart
└── shared/
    ├── cubit/
    │   ├── paginated_cubit.dart
    │   ├── paginated_response.dart
    │   └── paginated_state.dart
    ├── utils/
    │   └── form_validators.dart
    └── widgets/
        ├── base_page.dart
        ├── common_button.dart
        ├── common_list_item.dart
        └── infinite_scroll_list_with_pagination.dart
```

---

## 🛠 Requirements

* Flutter >= 3.35.2
* Dart >= 3.0
* Android Studio / Xcode
* Git

---

## 🚀 Installation

**1. Clone the repository**

```bash
git clone https://github.com/DavidGomezOv/hacom_frontend_app.git
cd hacom_frontend_app
```

**2. Install dependencies**

```bash
dart pub get
```

**3. Generate files**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Configure environment variables**

Create a `.env` file in the project root:

```env
BASE_URL=https://api.example.com
```

**5. Configure Google Maps API Key**

* **iOS:** In `Debug.xcconfig` and `Release.xcconfig`:

```text
GOOGLE_MAPS_API_KEY=your_api_key_here
```

* **Android:** In `local.properties`:

```text
GOOGLE_MAPS_API_KEY=your_api_key_here
```

---

## 🏃‍♂️ Run the app

```bash
flutter run
```

---

## ✅ Tests

* Run tests:

```bash
flutter test
```

* Analyze errors:

```bash
dart analyze --fatal-warnings
```

* Format code:

```bash
dart format --output=none --set-exit-if-changed .
```

* View coverage:

```bash
dart test --coverage
```
