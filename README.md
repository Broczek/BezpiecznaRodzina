# Safe Family - Safety Zones Module

This Flutter application is a solution to a recruitment task requiring the development of a "Safety Zones" module for a family safety mobile app. The project demonstrates a comprehensive approach, integrating not just zone management but also a foundational system for user and device management, built with a clean architecture and modern Flutter practices.

## Features

-   **User Authentication**: A complete, mock-backend registration and login flow.
-   **Family Management**: Functionality to add, edit, and manage family members (sub-users) and their associated devices.
-   **Multi-Step Zone Creation**: An intuitive, multi-step wizard for creating and editing safety zones.
-   **Interactive Map Interface**: A core feature allowing users to define zones by searching for addresses or directly placing and resizing them on a Google Map.
-   **Dynamic User-Zone Assignment**: Seamlessly link family members to zones and receive notifications (feature mocked).
-   **Role-Based Access Control**: Differentiates between `Admin` and `Viewer` roles to control access to features.
-   **Multi-Language Support (i18n)**: The app supports English, Polish, German, and Spanish.
-   **Theming**: Includes a dynamic theme system with support for both light and dark modes.

## Architecture & Technical Decisions

The application is built using the **BLoC (Business Logic Component)** pattern to ensure a clear separation between the UI and business logic. This promotes testability and maintainability.

### Core Components

-   **State Management (`flutter_bloc`)**:
    -   `AuthBloc`: Manages the global authentication state (logged in/out).
    -   `RegistrationBloc`: Handles the complex state of the multi-step registration flow.
    -   `FamilyBloc`: Manages the state for the list of family members (sub-users), including CRUD operations.
    -   `ZonesBloc`: Manages the state for safety zones and listens to `FamilyBloc` to keep user assignments synchronized.

-   **Navigation (`go_router`)**:
    -   A declarative, URL-based routing solution is used for all navigation.
    -   It includes a `redirect` logic that protects routes based on the user's authentication status from the `AuthBloc`.
    -   `ShellRoute` is used to provide a persistent `BottomNavigationBar` for the main authenticated sections of the app.

-   **Dependency Injection (`get_it`)**:
    -   Used as a service locator to provide singleton instances of BLoCs and the `AuthRepository` throughout the widget tree, decoupling the layers of the application.

-   **Backend (Mocked)**:
    -   The entire backend is mocked using an in-memory `AuthRepository`. This repository simulates a database for users, devices, and zones, allowing the application to be fully functional without a live server. This approach was chosen to focus on the frontend architecture and user experience as per the task requirements.

### Application Flow & Design Philosophy

The development process was guided by the decision to create a cohesive and robust system, rather than just implementing the minimum required features.

1.  **User & Device Management as the Foundation**: The process started with building a comprehensive user management system. The registration flow was designed not just to create a main account, but as a setup wizard to add devices and assign "sub-users" (family members) to them. This ensures that the core entities of the application (users and their devices) are established first, providing a solid base for other features.

2.  **Interactive, Map-First Zone Creation**: For the core "Safety Zones" feature, an interactive, map-centric approach was prioritized over simple forms. This provides a superior user experience, allowing users to visually define a zone's center and radius directly on a map, with immediate visual feedback. The integration with the Google Places API for address search and reverse geocoding further enhances usability.

3.  **Cohesive and Interconnected Logic**: The final architectural step was to tightly integrate the user and zone systems. The `ZonesBloc` listens to state changes from the `FamilyBloc`. When a user's zone assignments are modified (e.g., when editing a family member), the `ZonesBloc` automatically updates the corresponding zone's data to reflect which users are assigned to it. This creates a single, coherent system where data remains consistent across different features.

## How to Run the Application

1.  **Prerequisites**:
    -   Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
    -   You have an editor like VS Code or Android Studio set up for Flutter development.

2.  **Add Google Maps API Key**:
    -   Open the file `lib/features/zones/data/places_services.dart`.
    -   Replace the placeholder `YOUR_API_KEY_HERE` with your actual Google Maps API key.
    -   Follow the platform-specific setup for Google Maps in Flutter:
        -   [Android Setup](https://pub.dev/packages/google_maps_flutter#android)
        -   [iOS Setup](https://pub.dev/packages/google_maps_flutter#ios)

3.  **Clone & Run**:
    ```bash
    # Clone the repository
    git clone https://github.com/Broczek/BezpiecznaRodzina.git into BezpiecznaRodzina
    cd BezpiecznaRodzina

    # Get dependencies
    flutter pub get

    # Run the application
    flutter run
    ```

## AI Collaboration

AI tools were utilized throughout the development process to enhance productivity and code quality, in line with the task requirements:

-   **Code Generation**: AI assisted in generating boilerplate code for BLoCs, states, events, and model classes.
-   **Problem Solving**: Used to debug complex issues, such as implementing the custom map marker rendering and the `DraggableScrollableSheet` logic.
-   **Refactoring & Optimization**: AI provided suggestions for improving code structure, simplifying logic, and adhering to Dart best practices.
-   **Documentation**: AI was used to generate a significant portion of the code comments (including these) and to structure this README file, ensuring clarity and completeness.

## Backend Mocking Analysis
In line with the project requirements, the backend has been fully mocked to allow the application to be tested and demonstrated without a live server. A hybrid approach was chosen for this simulation:

- `MockApiInterceptor`: A Dio interceptor is used to catch initial GET requests for data like the list of zones, devices, and user permissions. This simulates the initial state fetched from a server when the application starts.

- `AuthRepository` as an In-Memory Database: For all state-changing operations (POST, PUT, DELETE), the logic is handled directly within the AuthRepository. The repository acts as a single source of truth, managing lists of users and zones in memory.

This approach was deliberately chosen to:

- **Isolate Data Logic**: It keeps all data manipulation logic contained within the AuthRepository, making the BLoCs and UI completely unaware of whether they are communicating with a real backend or a mock one.

- **Focus on Frontend Architecture**: It allowed for a greater focus on building robust frontend logic, state management, and UI without the complexity of a fully simulated network layer for all CRUD operations.

While the requirements mentioned mocking endpoints for themes (`/api/themes`) and language packs (`/api/i18n`), these were implemented locally within the app's design system and localization packages, respectively. This decision was made to streamline development and concentrate on the core functionalities of user and zone management.
