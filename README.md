<p align="center">
  <img src="images/icon.png" width="96" alt="Grocerio logo" />
</p>

<h1 align="center">Grocerio</h1>
<p align="center"><b>Flutter Grocery E-Commerce — Customer App</b></p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Stripe-Payments-635BFF?logo=stripe&logoColor=white" />
  <img src="https://img.shields.io/badge/State%20Management-Provider-13B9AA" />
</p>

A customer-facing grocery shopping app built with **Flutter** and **Firebase**. Users can browse fresh produce by category, grab exclusive offers, manage a cart, apply coupons, check out securely with **Stripe**, and track their order history — all in a clean, responsive interface.

---

## 📱 Screenshots

| Sign In | Create Account | Home |
|---|---|---|
| <img src="screenshots/signin.jpeg" width="220"/> | <img src="screenshots/signup.jpeg" width="220"/> | <img src="screenshots/home.jpeg" width="220"/> |

| Categories & Offers | Cart | Orders |
|---|---|---|
| <img src="screenshots/home_categories.jpeg" width="220"/> | <img src="screenshots/cart.jpeg" width="220"/> | <img src="screenshots/orders.jpeg" width="220"/> |

| Profile | Coupons & Offers | Personal Information |
|---|---|---|
| <img src="screenshots/profile.jpeg" width="220"/> | <img src="screenshots/coupons.jpeg" width="220"/> | <img src="screenshots/personal_info.jpeg" width="220"/> |

---

## ✨ Features

- **Authentication** — email/password sign up and sign in via Firebase Authentication
- **Home & discovery** — featured banner, exclusive offers, and browsing by category (fruits, vegetables, sweets, and more)
- **Product catalog** — pricing, live discounts, and stock-aware product cards
- **Cart** — quantity controls, per-item subtotal, and item removal, persisted per authenticated user
- **Coupons & offers** — dedicated screen to view and copy active promo codes (e.g. `SAVE20`, `SUMMERSALE`)
- **Checkout** — secure payment sheet powered by Stripe
- **Orders** — full order history with status (`PAID`, `CANCELLED`) and per-order item counts and totals
- **Profile** — editable personal information (name, email, phone, delivery address) with Firebase-backed sync
- **Session handling** — persistent login state and sign-out flow

---

## 🛠️ Tech Stack

| Area | Technology |
|---|---|
| Mobile framework | Flutter |
| Language | Dart (`^3.11.1`) |
| Authentication | `firebase_auth` |
| Database | `cloud_firestore` |
| Storage | `firebase_storage` |
| State management | `provider` |
| Payments | `flutter_stripe` |
| Environment config | `flutter_dotenv` |
| UI | Material 3, `carousel_slider` |
| Formatting | `intl` |

---

## 🏗️ Architecture

The app follows a lightweight **MVVM-style** separation between data models, providers/view models, and views:

```
lib/
├── Providers/
│   ├── cart_provider.dart
│   └── user_providers.dart
├── models/
│   ├── cart_model.dart
│   ├── category_model.dart
│   ├── coupon_model.dart
│   ├── order_model.dart
│   ├── order_product_model.dart
│   ├── product_model.dart
│   ├── promo_banner_model.dart
│   └── user_model.dart
├── viewModel/
│   ├── auth_view_model.dart
│   ├── cart_viewModel.dart
│   ├── categories_view_model.dart
│   ├── checkout_veiw_model.dart
│   ├── common_veiw_model.dart
│   ├── coupon_view_model.dart
│   ├── order_veiw_model.dart
│   ├── product_view_model.dart
│   ├── promo_banner_view_model.dart
│   └── user_view_model.dart
├── views/
│   ├── auth/
│   ├── buttonNav/
│   ├── checkout/
│   ├── coupons/
│   ├── products/
│   └── widgets/
├── firebase_options.dart
└── main.dart
```

### Firestore data

```
users/
  {userId}/
    cart/

products/
categories/
coupons/
promos/
banners/
orders/
```

### Shared backend model

The customer app talks to Firebase directly and reads/writes the same collections that a companion admin tool would manage:

```
Customer Flutter App ──▶ Firebase Authentication
                     ──▶ Cloud Firestore
                     ──▶ Firebase Storage
                     ──▶ Stripe Checkout
```

> **Companion admin app:** Grocerio is paired with a dedicated **Admin Management Panel** (web) for managing orders, products, promos, banners, categories, and coupons, plus a dashboard overview of store activity — link to be added here once the repository is public.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK compatible with Dart `^3.11.1`
- Android Studio and/or Xcode
- An emulator/simulator or physical device
- A Firebase project (Authentication + Firestore + Storage enabled)
- A Stripe account (test keys)

Check your environment:
```bash
flutter doctor
```

### 1. Clone the repository
```bash
git clone https://github.com/RamaNael/grocerio-customer-app.git
cd grocerio-customer-app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
The app initializes Firebase using `lib/firebase_options.dart`. To connect your own Firebase project, install the FlutterFire CLI and regenerate the config:
```bash
flutterfire configure
```
Make sure **Authentication**, **Cloud Firestore**, and **Storage** are enabled for your project.

### 4. Configure environment variables
```bash
cp .env.example .env
```
Then add your Stripe **publishable** key:
```
STRIPE_PUBLISH_KEY=pk_test_your_publishable_key_here
```
`.env` is git-ignored and must never be committed.

### 5. Run the app
```bash
flutter run
```

---

## 🔒 Payment Security

> **Important:** a Stripe **secret key must never be embedded in a mobile app.**

The current checkout flow builds the PaymentIntent on the client for demo purposes. Before shipping to production, move PaymentIntent creation to a trusted backend (e.g. Firebase Cloud Functions or a small Node/Express API) and have the app request only the client secret needed by Stripe's mobile SDK. Never commit a `STRIPE_SECRET_KEY` — rotate it immediately if one is ever exposed.

---

## 🗺️ Roadmap

- [ ] Link the companion Admin Management Panel repository here
- [ ] Move Stripe PaymentIntent creation to a secure backend
- [ ] Add automated widget and integration tests
- [ ] Add search and product filtering
- [ ] Add push notifications for order status updates
- [ ] Add a wishlist/favorites feature
- [ ] Document Firestore security rules

---

## 👩‍💻 Author

**Rama Mansoor**
Mobile Developer | Flutter & Cross-Platform Applications

- GitHub: [@RamaNael](https://github.com/RamaNael)
- LinkedIn: [ramanael](https://linkedin.com/in/ramanael)
- Email: rama.nael.mansoor@gmail.com

---

<p align="center">Built with Flutter, Firebase, and Stripe.</p>
