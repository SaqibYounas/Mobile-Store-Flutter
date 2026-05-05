# LuxeCart — Flutter Mobile Store

A modern e-commerce mobile app built in Flutter with a Supabase backend.
Customers browse products by dynamic categories, add to cart with toast
feedback, and check out via card or cash-on-delivery. An admin role can
manage the product catalog and order pipeline from the same app.

The codebase is organized for readability and reuse: every screen is a
thin shell that composes single-purpose widget files under
`lib/src/view/widget/<feature>/`.

---

## Table of Contents

1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Folder Structure](#folder-structure)
4. [Screens](#screens)
5. [Architecture](#architecture)
6. [Backend & Data Model](#backend--data-model)
7. [Theming (Light / Dark)](#theming-light--dark)
8. [Setup & Run](#setup--run)
9. [Building the APK](#building-the-apk)
10. [Notes & Limitations](#notes--limitations)

---

## Features

### UI / UX

- **Modern Material 3 design** with a centralized indigo / purple brand
  palette and consistent typography.
- **Light + dark theme** with a one-tap toggle in the home header and
  profile screen. The choice is persisted via `SharedPreferences` and
  defaults to the OS preference.
- **Right-side toast notifications** (`AppToast`) used app-wide for
  success, error, and info feedback. Toasts auto-dismiss after 4 seconds.
- **Smooth navigation** via GetX named routes; product cards open detail
  pages with a fade-through OpenContainer animation.
- **Pull-to-refresh** on every list screen (products, orders, admin).

### Authentication

- **Email + password** sign-in / sign-up via Supabase Auth.
- **Forgot password** flow — sends a Supabase password-reset email and
  surfaces an inline confirmation banner once delivered.
- **Email update** with verification — Supabase sends a confirmation link
  to the new address; the local `users` row mirrors after the user
  confirms.
- **Role-based routing** — admins land on the admin dashboard, customers
  on the home screen. Cached in `SessionService` so cold starts route
  immediately without a network round-trip.

### Product Catalog

- **Dynamic categories** pulled from the backend (distinct values from
  the `products.category` column). Rendered as horizontal pill buttons
  on the home screen.
- **Live updates** via Supabase Realtime — newly added or deactivated
  products appear/disappear without a manual refresh.
- **Featured row** on the home screen, plus full grid below.
- **Debounced search** that runs a client-side filter immediately and a
  full-text remote search 300 ms after the last keystroke.
- **Wishlist / favorites** managed locally with reactive `RxList`.

### Cart & Checkout

- **Add to cart** with a right-side success toast and automatic back
  navigation from the product detail page (no manual close button).
- **Quantity stepper** with stock-cap validation (toast warning on limit
  reached).
- **Swipe-to-remove** with a confirmation dialog.
- **Two payment methods**: card (online) and cash-on-delivery, with an
  animated card preview that mirrors the user's input.
- **Stock decrement** is enforced by a database trigger on order
  insertion.

### Admin Panel

- **Dashboard** with a gradient hero banner and three live stat tiles
  (total products, active products, total orders).
- **Product list** with row actions: toggle active, toggle featured,
  edit, delete. Soft-confirm dialog on delete.
- **Add / Edit Product form** in a bottom sheet with sectioned fields
  (Basics, Description, Pricing & Stock, Visibility) and inline
  validation.
- **All Orders** screen with status-filter chips and per-order status
  changes.
- **Realtime sync** — the admin product list streams changes from
  Supabase, no manual refresh needed.

### Performance & Code Quality

- **Single-source design tokens** — colors and text styles live in
  `lib/src/core/`.
- **GetX reactive state** keeps rebuilds scoped to the widgets that
  actually depend on a value.
- **Theme-aware widgets** read from `Theme.of(context)` so light/dark
  toggles repaint automatically.
- **Const constructors everywhere they help** to skip rebuilds.
- **Modular widget files** — each public widget lives in its own file
  under `lib/src/view/widget/<feature>/`.

---

## Tech Stack

| Package | Why it's here |
| --- | --- |
| **flutter** + **Material 3** | Cross-platform UI toolkit; M3 gives modern surfaces and color schemes. |
| **get** ^4.6.6 | Routing, dependency injection, and reactive state in one package — small footprint, good ergonomics. |
| **supabase_flutter** ^2.12.4 | Auth, Postgres database, Realtime streams. Avoids hand-rolling a backend. |
| **shared_preferences** ^2.0.19 | Caches the logged-in user profile + theme mode for fast cold starts. |
| **flutter_rating_bar** ^4.0.1 | Star rating widget on the product detail screen. |
| **animations** ^2.0.11 | `OpenContainer` and `PageTransitionSwitcher` for the polished navigation feel. |
| **intl** ^0.19.0 | Date formatting on order screens. |
| **collection** ^1.18.0 | Utility iterables. |

Removed during the cleanup pass (no longer used): `stylish_bottom_bar`,
`smooth_page_indicator`, `font_awesome_flutter`. Replaced by the
custom `ModernBottomBar` and Material icons.

---

## Folder Structure

```
lib/
├── main.dart                          # Entry point + Supabase init + theme wiring
└── src/
    ├── config/
    │   └── app_routes.dart           # All GetX named routes + per-route bindings
    ├── constants/
    │   ├── database_constants.dart
    │   └── supabase_config.dart      # Supabase URL + anon key
    ├── controller/                   # Reactive state controllers (GetX)
    │   ├── auth_controller.dart
    │   ├── cart_controller.dart
    │   ├── favorites_controller.dart
    │   ├── order_controller.dart
    │   ├── product_controller.dart   # Coordinator that delegates to the three below
    │   ├── product_list_controller.dart
    │   ├── admin_controller.dart
    │   └── theme_controller.dart     # Light / dark toggle + persistence
    ├── core/
    │   ├── app_color.dart            # All color tokens (light + dark surfaces, brand)
    │   ├── app_data.dart             # Static placeholder text + soft pastel colors
    │   ├── app_theme.dart            # Light + dark `ThemeData` (Material 3)
    │   ├── app_toast.dart            # Right-side toast helper (success/error/info)
    │   ├── app_typography.dart       # Centralized text styles
    │   ├── middleware/
    │   │   └── admin_guard.dart      # Route guard for admin-only pages
    │   └── services/                 # Supabase API wrappers
    │       ├── auth_service.dart
    │       ├── order_service.dart
    │       ├── payment_service.dart
    │       ├── product_service.dart
    │       └── session_service.dart  # `SharedPreferences`-backed session cache
    ├── model/                        # Pure data classes (Product, Order, etc.)
    │   ├── bottom_tab.dart
    │   ├── numerical.dart
    │   ├── order.dart
    │   ├── order_item.dart
    │   ├── payment.dart
    │   ├── payment_method.dart
    │   ├── product.dart
    │   └── user_model.dart
    └── view/
        ├── animation/                # Animation wrappers
        │   ├── open_container_wrapper.dart
        │   └── page_transition_switcher_wrapper.dart
        ├── admin/
        │   ├── admin_dashboard_screen.dart   # Shell — composes widgets below
        │   ├── admin_orders_screen.dart      # Shell
        │   └── widgets/
        │       ├── admin_chip.dart
        │       ├── admin_drawer.dart
        │       ├── admin_hero_header.dart
        │       ├── admin_order_card.dart
        │       ├── admin_product_form.dart
        │       ├── admin_product_row.dart
        │       ├── admin_search_bar.dart
        │       ├── admin_stat_tile.dart
        │       ├── admin_stats_row.dart
        │       ├── discount_type_selector.dart
        │       └── order_status_filter_chips.dart
        ├── screen/                   # Top-level screens (thin shells)
        │   ├── auth_screen.dart
        │   ├── cart_screen.dart
        │   ├── email_update_screen.dart
        │   ├── favorite_screen.dart
        │   ├── forgot_password_screen.dart
        │   ├── home_screen.dart
        │   ├── orders_screen.dart
        │   ├── payment_screen.dart
        │   ├── product_detail_screen.dart
        │   ├── product_list_screen.dart
        │   └── profile_screen.dart
        └── widget/                   # Reusable widgets — one purpose per file
            ├── app_card.dart                # Theme-aware elevated card
            ├── auth/                        # Auth-specific
            │   ├── auth_error_banner.dart
            │   ├── auth_form_card.dart
            │   ├── auth_gradient_submit.dart
            │   ├── auth_header.dart
            │   └── auth_text_field.dart
            ├── cart/                        # Cart-specific
            │   ├── cart_bottom_section.dart
            │   ├── cart_item_card.dart
            │   └── cart_product_thumb.dart
            ├── category_buttons.dart        # Dynamic category pill row
            ├── circle_icon_button.dart      # Reusable
            ├── empty_cart.dart
            ├── empty_state.dart             # Reusable empty / error state
            ├── form_section.dart            # Reusable form section card
            ├── form_text_field.dart         # Reusable themed text field
            ├── gradient_button.dart         # Reusable brand button
            ├── home/
            │   └── modern_bottom_bar.dart   # Custom 5-tab bottom nav
            ├── outlined_text_field.dart     # Reusable (used on payment)
            ├── payment/                     # Payment-specific
            │   ├── card_form.dart
            │   ├── card_preview.dart
            │   ├── cod_pane.dart
            │   ├── order_summary_card.dart
            │   └── payment_method_selector.dart
            ├── price_text.dart
            ├── product_detail/              # Product detail-specific
            │   ├── product_buy_bar.dart
            │   ├── product_category_tag.dart
            │   ├── product_detail_image.dart
            │   ├── product_feature_tile.dart
            │   └── product_rating_row.dart
            ├── product_grid/                # Product grid-specific
            │   ├── product_grid_badges.dart
            │   ├── product_grid_footer.dart
            │   ├── product_grid_image.dart
            │   └── product_grid_item.dart
            ├── product_grid_view.dart       # Composes product_grid/*
            ├── product_list/                # Product list-specific
            │   ├── featured_product_card.dart
            │   ├── product_list_header.dart
            │   └── product_search_field.dart
            ├── profile/                     # Profile-specific
            │   ├── profile_hero.dart
            │   ├── profile_tile.dart
            │   └── theme_toggle_tile.dart
            ├── quantity_stepper.dart        # Reusable -/+ stepper
            ├── section_title.dart           # Reusable section header
            └── status_badge.dart            # Reusable order/payment status pill
```

**Why this layout?** Each public widget lives in one file. Screens are
thin shells that compose those widgets, so you can refactor the
internals of, say, `CartItemCard` without ever opening `cart_screen.dart`.

---

## Screens

| Screen | File | What it does |
| --- | --- | --- |
| **Auth** | `screen/auth_screen.dart` | Toggleable sign-in / sign-up form on a purple gradient. Includes a "Forgot password?" link. |
| **Forgot Password** | `screen/forgot_password_screen.dart` | Sends a Supabase reset link; shows a confirmation banner. |
| **Email Update** | `screen/email_update_screen.dart` | Requests a Supabase verification email for a new address; mirrors back into the `users` row after confirmation. |
| **Home** | `screen/home_screen.dart` | Customer shell with a 5-tab `ModernBottomBar`. |
| **Shop (Product List)** | `screen/product_list_screen.dart` | Greeting header, search, dynamic categories, featured row, product grid. |
| **Product Detail** | `screen/product_detail_screen.dart` | Hero image, category tag, rating, specs, feature tiles, sticky buy bar. |
| **Wishlist** | `screen/favorite_screen.dart` | Saved products grid. |
| **Cart** | `screen/cart_screen.dart` | Swipe-to-remove items, quantity stepper, sticky checkout panel. |
| **Orders (mine)** | `screen/orders_screen.dart` | History of the customer's orders with status badges. |
| **Profile** | `screen/profile_screen.dart` | Name + email card, email update, password reset, theme toggle, logout. |
| **Checkout / Payment** | `screen/payment_screen.dart` | Delivery info + payment method selector (online / COD) with animated card preview. |
| **Admin Dashboard** | `admin/admin_dashboard_screen.dart` | Stats row + product table with row actions. |
| **Admin Orders** | `admin/admin_orders_screen.dart` | Filter chips + order cards with status update menu. |

---

## Architecture

### State management — GetX

| Controller | Purpose |
| --- | --- |
| `ThemeController` | Manages `ThemeMode` and persists it via `SharedPreferences`. |
| `AuthController` | Sign-in, sign-up, password reset, email change, sign-out. |
| `ProductController` | Coordinator that delegates to the three below. |
| `ProductListController` | Catalog, search, featured, dynamic categories, live stream. |
| `CartController` | Add / remove / increase / decrease, total recalculation. |
| `FavoritesController` | Toggle and list saved products. |
| `OrderController` | Customer's own orders. |
| `AdminController` | Admin product CRUD + order list + status updates. |

Controllers are `Get.lazyPut` registered in `app_routes.dart` so they
only spin up when the user navigates to a screen that needs them.

### Service layer

Static classes that wrap Supabase calls so controllers stay free of
direct `_supabase.from(...)` calls:

- `AuthService` — Supabase Auth + role lookup
- `ProductService` — read/write/stream products
- `OrderService` — `placeOrder`, `myOrders`, `allOrders`, `updateStatus`
- `PaymentService` — write payment rows linked to an order
- `SessionService` — `SharedPreferences` cache of the active user

---

## Backend & Data Model

The app talks to Supabase. Tables (managed via `supabase_schema.sql`):

| Table | Purpose |
| --- | --- |
| `users` | Mirrors `auth.users` with `name`, `email`, `role` (`user` / `admin`). Inserted by a DB trigger on signup. |
| `products` | Catalog. Has `is_active`, `is_featured`, `category`, `discount_type`, `discount_value`, `stock_quantity`. |
| `orders` | One per checkout. References `user_id`, has `status` enum. |
| `order_items` | Line items per order. A trigger decrements `products.stock_quantity` on insert. |
| `payments` | One per paid order, with masked card data when paid online. |

**Row-Level Security (RLS)** is enforced server-side:
- Customers see only `is_active = true` products and their own orders.
- Admins (role = `admin`) see all rows.

The app never relies on client-side checks for authorization; the role
is just a UI hint to choose which screens to show.

Supabase config lives in [lib/src/constants/supabase_config.dart](lib/src/constants/supabase_config.dart) — replace the
URL + anon key with your own project's values.

---

## Theming (Light / Dark)

- Both themes are built from a single Material 3 `ThemeData` factory in
  [lib/src/core/app_theme.dart](lib/src/core/app_theme.dart) so they stay in sync.
- The `ThemeController` reads / writes the user's choice to
  `SharedPreferences` under the key `theme_mode` (`light` / `dark` /
  `system`).
- Two toggle entry points:
  1. The sun/moon icon next to the greeting on the **Home** tab.
  2. The **Appearance** row on the **Profile** screen.
- Default mode is `system` — falls back to the OS preference until the
  user picks one explicitly.
- Brand surfaces (auth gradient, drawer hero, gradient buttons,
  promotional cards) intentionally stay fixed across themes for a
  consistent brand identity.

---

## Setup & Run

### Prerequisites

- Flutter SDK ≥ 3.0, < 4.0 (Dart 3+)
- Android Studio + Android SDK 36, NDK 28.2.13676358
- A Supabase project (free tier is fine)

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd flutter-main
flutter pub get
```

### 2. Configure Supabase

1. Create a project at [supabase.com](https://supabase.com).
2. Run the SQL schema in your Supabase SQL editor (the project ships
   with the table definitions in `supabase_schema.sql` — adapt as
   needed).
3. Copy your Project URL and anon key into
   [lib/src/constants/supabase_config.dart](lib/src/constants/supabase_config.dart).

### 3. Promote a user to admin

After signing up via the app, run this in the Supabase SQL editor:

```sql
update public.users set role = 'admin' where email = 'you@example.com';
```

Sign out and back in to see the admin dashboard.

### 4. Run

```bash
flutter run                    # debug build on the connected device
flutter run --release          # release-mode performance test
```

---

## Building the APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

The APK lands at:

```
build/app/outputs/flutter-apk/app-release.apk
```

Install on a connected device:

```bash
flutter install
```

### Build configuration

- **`android/app/build.gradle.kts`** sets `minSdk = 21`, `compileSdk =
  36`, `targetSdk = 36`, and enables `multiDexEnabled = true` for
  large dependency graphs.
- The release build is signed with the **debug keystore** by default
  so `flutter run --release` and `flutter build apk` install on devices
  without extra setup. Replace this with a real upload keystore for
  Play Store submission.
- `android.permission.INTERNET` and `ACCESS_NETWORK_STATE` are declared
  in [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml).

### "App not installed" troubleshooting

The most common causes:
1. A previously-installed build was signed with a different key —
   uninstall the old version first.
2. Device API level is below `minSdk = 21` — bump the device or lower
   `minSdk`.
3. NDK version mismatch — install `28.2.13676358` via Android Studio's
   SDK Manager, or remove the explicit `ndkVersion` in
   `android/app/build.gradle.kts` to let Flutter pick.

---

## Notes & Limitations

- **App ID** is still the Flutter default `com.example.app`. Change it
  before publishing to the Play Store (`android/app/build.gradle.kts` →
  `applicationId` and `namespace`, plus the Kotlin package path).
- The release APK uses the **debug signing key** for convenience. Swap
  in a proper keystore (`key.properties` + `signingConfigs` block)
  before publishing.
- **Card details** entered on the payment screen are stored only as
  cardholder name + last four / expiry month-year, never the full card
  number. For real card processing, integrate a PSP (Stripe, etc.)
  rather than persisting raw card data.
- **Email update + password reset** rely on Supabase's email delivery —
  configure SMTP in your Supabase project for production-quality emails.
- The product catalog is intentionally simple: one `category` string per
  product. For a richer taxonomy you'd want a separate `categories`
  table with foreign-key references.

---

## License

Private project — all rights reserved unless noted otherwise.
