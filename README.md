# Our Cool Project

*Short description what the project is about*

## Background

<p align="center">
  <img alt="Hack4Rail Logo" src="img/hack4rail-logo.jpg" width="220"/>
  <img alt="Lithium+" src="img/lithium_plus.png" width="500"/>
</p>

This project has been initiated during the [Hack4Rail 2025](https://hack4rail.event.sbb.ch/en/), a joint hackathon organised by the railway companies SBB, ÖBB, and DB in partnership with the OpenRail Association.

---

## Backend

The backend is developed in Python 3 and is located in the `backend/` directory. It handles all business logic, data management, and provides REST APIs for the frontend.

**Technologies & Structure:**
- Language: Python 3
- Dependencies are managed via `poetry` (see `pyproject.toml` and `poetry.lock`).
- Key files:
  - `configs.py`: Central configuration file for the backend.
  - `fleet_overview.py`: Main logic for managing and providing fleet and vehicle data.
  - `fleet_overview.json`: Example or production data for fleets and vehicles.

**Features:**
- Management and aggregation of fleet and vehicle data.
- Provides endpoints for the frontend (e.g., fleet overview, vehicle details).
- Easily extendable for additional data sources or logic.

**Getting Started:**
1. Set up a Python environment (e.g., with `venv` or `poetry`).
2. Install dependencies:
   ```bash
   poetry install
   ```
3. Start the backend:
   ```bash
   python backend/fleet_overview.py
   ```

---

## Frontend

The frontend is a modern web app built with Flutter (Dart) and is located in the `frontend/poc/` directory. It visualizes fleet and vehicle data and communicates with the backend via HTTP.

**Technologies & Structure:**
- Framework: Flutter (Dart)
- Main directory: `frontend/poc/`
- Key files and folders:
  - `lib/`: Main source code of the app
    - `fahrzeug_dashboard/`: Components and models for the vehicle view
    - `fleets_dashboard/`: Components and models for the fleet view
    - `app_router.dart`: Routing logic for navigation
    - `main.dart`: Entry point of the app
  - `web/`: Web-specific resources (e.g., `index.html`)
  - `pubspec.yaml`: Dependencies and project configuration

**Features:**
- Clear presentation of fleets and individual vehicles.
- Interactive dashboards with charts and status indicators.
- Communication with the backend to display up-to-date data.
- Responsive design for various screen sizes.

**Getting Started:**
1. Install the Flutter SDK.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Start the app in the browser:
   ```bash
   flutter run -d chrome
   ```

---

## Install

*How can a user install the software?*

## License

<!-- If you decide for another license, please change it here, and exchange the LICENSE file -->

The content of this repository is licensed under the [Apache 2.0 license](LICENSE).
