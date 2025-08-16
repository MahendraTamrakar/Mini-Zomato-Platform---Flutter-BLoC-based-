# Mini Zomato Platform (Flutter + BLoC)

A Flutter application built with clean architecture and the BLoC pattern, simulating a mini food delivery platform. It offers customer-facing features like restaurant browsing, menu selection, cart management, and order placement—all powered by mock data for ease of testing.

---

##  Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture & Project Structure](#architecture--project-structure)
- [Setup & Run Instructions](#setup--run-instructions)
- [State Management (BLoC)](#state-management-bloc)

---

## Project Overview
This project demonstrates a simplified version of a food delivery app focusing on clean architecture:
- Well-structured layers for maintainability and scalability.
- Use of the **BLoC pattern** to separate UI and business logic.
- Mock data providers to simulate backend APIs.

---

## Features
- **Authentication:** Mock user login flow.
- **Restaurant Browsing:** View a curated list of restaurants.
- **Menu Viewing:** Explore menus organized by categories (appetizers, salads, mains, desserts, etc.).
- **Cart Management:** Add and remove items from the cart.
- **Order Flow:** Place orders and review order history.
- **Utilizes Clean Architecture:** Keep UI, state management, and data access clearly separated.

---

## Architecture & Project Structure

lib/
│
├── bloc/                       # State management (BLoC for each feature)
│   ├── auth/                   # Authentication (login/logout states & events)
│   ├── cart/                   # Cart logic (add/remove items, total price)
│   ├── menu/                   # Menu logic (fetch, filter, availability)
│   ├── order/                  # New order creation, checkout handling
│   ├── order_history/          # Fetch & show user’s past orders
│   └── restaurant_list/        # Restaurant list fetching
│
├── core/                       # Core utilities, enums, constants
│   └── utils/
│       ├── enums_utils.dart    # Enums (MenuCategory, OrderStatus, etc.)
│       └── routes.dart         # Centralized navigation routes
│
├── data/                       
│                               # Mock/real API providers
│                               
│
├── models/                     # Data models
│   ├── user_model.dart
│   ├── menu_item_model.dart
│   ├── restaurant_model.dart
│   └── order_model.dart
│
├── presentation/               # UI Layer
│   └── user_app/               # Customer-facing app
│       ├── screens/            # Full pages (Login, Home, Cart, etc.)
│       └── widgets/            # Reusable UI components (buttons, cards, etc.)
│
├── repositories/               # Concrete repo implementations
│
└── main.dart                   # Entry point (MaterialApp, MultiBlocProvider)

---

This layered design enforces a clean flow: **UI → BLoC → Repository → Data Provider**.

---

## Setup & Run Instructions

1. **Clone the repo**

    ```bash
    git clone https://github.com/MahendraTamrakar/Mini-Zomato-Platform---Flutter-BLoC-based-.git
    cd Mini-Zomato-Platform---Flutter-BLoC-based-
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Run the app**

    ```bash
    flutter run
    ```

---

## State Management (BLoC)

Each functional area is managed by its own BLoC:

- `AuthBloc` — Handles user authentication flows.
- `RestaurantListBloc` — Fetches and provides restaurant data.
- `MenuBloc` — Serves menu information filtered by restaurant.
- `CartBloc` — Manages cart items and updates.
- `OrderBloc` — Handles placing new orders.
- `OrderHistoryBloc` — Retrieves user’s past order data.

UI components listen for state changes via `BlocBuilder` and dispatch actions like `LoginRequested`, `AddToCart`, or `PlaceOrder`.

---

## Mock Data Implementation

Mock data ensures you can run the app without backend dependencies:
- Located under `lib/data/`
- Includes JSON for **restaurants**, **menu items**.
- Repositories parse this data into strongly-typed models (`RestaurantModel`, `MenuItemModel`, etc.).
- Easy to replace with APIs or Firebase in future development.

---




