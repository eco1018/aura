# 🌿 aura

**aura** is an immersive, emotionally intelligent iOS app for users practicing Dialectical Behavior Therapy (DBT). Designed with fluid motion, organic UI, and a personalized DBT diary card system, aura supports self-awareness, emotion regulation, and skill-based healing — with future-ready AI insights and real-time coaching.

> "Healing is not linear — but it can be beautiful."


---

## 👥 Project Roles

| Role            | Description                                                                 |
|-----------------|-----------------------------------------------------------------------------|
| **@ella (Junior iOS Developer)** | Responsible for core app functionality: authentication, onboarding, diary card, reminders, navigation architecture, and UI/UX polish |
| **@Andrew.N (Senior AI/ML Developer)** | Responsible for all AI systems including DBT Chat Coach, crisis detection, pattern recognition, intelligent skill suggestions, and progress tracking |

---

## 📖 Table of Contents

- [✨ Features](#-features)
- [🧠 AI/ML Roadmap](#-aiml-roadmap)
- [🔧 Tech Stack](#-tech-stack)
- [📐 Architecture](#-architecture)
- [🎨 Design Language](#-design-language)
- [🚀 Installation](#-installation)
- [🤝 Contributing](#-contributing)
- [🛡 Disclaimer](#-disclaimer)
- [📬 Contact](#-contact)
- [📘 Full Developer Documentation](#-full-developer-documentation)

---

## ✨ Core Features

### 🧠 DBT Diary Card
- **Actions** – 2 fixed + 3 user-defined
- **Urges** – 3 fixed + 2 user-defined
- **Emotions** – 6 selected in onboarding
- **Skills Used** – DBT-based interventions
- **Goals Progress** – Yes/No
- **Medications** – Yes/No tracking
- **Daily Reflection Note** – Optional journaling

### ✍️ Personalized Onboarding
- Name, age, gender
- User-defined goals, actions, urges, emotions
- Morning & evening reminder times

### 🔔 Push Notifications
- Local reminders for morning/evening check-ins
- Deep-link directly into DiaryCard flow

---

## 🧠 AI/ML Roadmap

- DBT Chat Coach with real-time validation and skill suggestions
- Mood trend analysis from diary entries
- Skill recommendation engine based on past entries
- Crisis Mode triggers and safety protocols
- Therapist summary exports
- Habit stacking, gamification, and voice journaling (planned)

---

## 🔧 Tech Stack

| Tech              | Purpose                                |
|-------------------|----------------------------------------|
| **SwiftUI**        | Declarative iOS UI                    |
| **Firebase Auth**  | Secure user login                     |
| **Firestore**      | User + diary data storage             |
| **SwiftData**      | Local persistence (if needed)         |
| **Core Animation** | Smooth transitions & organic visuals  |
| **UserNotifications** | Local push notifications           |
| **OpenAI API**     | (Planned) DBT chat coach backend      |
| **Firebase Functions** | (Planned) Data analysis pipelines |

---

## 📐 Architecture

- Single entrypoint in `RootView`
- Navigation driven by `AuthViewModel.shared`
- Folder structure organized by app domain/slice

---

## 🎨 Design Language

- Ephemeral UI with breathing gradients and organic motion
- Emotionally intelligent UX with DBT-inspired tone
- No cartoon visuals — light-filled and intuitive instead

---

## 🚀 Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/aura.git
   ```

2. Open in Xcode 15+

3. Set up Firebase:
   - Create Firebase project
   - Enable Firestore & Auth
   - Add `GoogleService-Info.plist` to Xcode root

4. Run on simulator or iOS device

---

## 🤝 Contributing

🚧 Private development in progress  
Contribution guidelines coming soon.

---

## 🛡 Disclaimer

aura is a support tool for DBT practice — **not a substitute for licensed therapy** or emergency care.

---

## 📬 Contact

**💌 General Inquiries:** hello@auraapp.dev  
**iOS Developer:** [You]  
**AI Developer:** [Your Brother]

---

## 📘 Full Developer Documentation

For detailed chapters on architecture, authentication, onboarding, AI features, and more, check out the full dev documentation:

👉 [View Full Documentation →](./docs/index.md)
