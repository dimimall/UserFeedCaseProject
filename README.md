# UserFeedCaseProject

# 📱 User Feed App (iOS)

An iOS application that displays a list of users fetched from a remote API, built with **Clean Architecture** and **MVP**, with a strong focus on **testability**, **modularity**, and **scalability**.

---

## 🚀 Features

* Fetch users from remote API
* Display users (name, email, avatar)
* Pagination support (`limit` / `skip`)
* Image loading & caching (memory + disk)
* Local caching (offline-first approach)
* Pull-to-refresh
* Error handling & loading states
* Future: Comments per user

---

## 🏗 Architecture

The project follows **Clean Architecture principles**, inspired by the EssentialFeed case study.

```
Presentation (MVP)
│
├─ ViewControllers
├─ Presenters
└─ ViewModels
        │
        ▼
Domain
│
├─ Entities (User)
├─ Use Cases
└─ Repository Protocols
        │
        ▼
Data
│
├─ Repository Implementations
├─ Remote Data Sources (API)
├─ Local Data Sources (Cache)
└─ Mappers (DTO → Domain)
        │
        ▼
Infrastructure
│
├─ URLSessionHTTPClient
├─ Disk & Memory Cache
└─ File System
```

---

## 🧠 Design Decisions

* **Clean Architecture**: separation of concerns, independent layers, high testability
* **MVP**: passive views, presenters handle UI logic
* **Repository Pattern**: abstracts data sources and enables caching strategies

---

## 🌐 API

Uses the public API:

https://dummyjson.com/users

---

## 💾 Caching Strategy

* **Users**: disk cache (cache-first, then refresh)
* **Images**: memory + disk cache (avoids duplicate downloads)

---

## 🧪 Testing

Focus on unit and integration testing using:

* Dependency Injection
* Test Doubles (Spies & Stubs)
* URLProtocol mocking (URLSession)
* Isolated component testing

---

## 📂 Project Structure

```
UserFeedFramework
├─ UsersFeature
├─ UsersAPI
├─ UsersCache
└─ UsersPresentation

UserFeedApp
├─ UI
├─ CompositionRoot
└─ SceneDelegate
```

---

## 🧱 Technologies

Swift • UIKit • URLSession • XCTest • Clean Architecture • MVP

---

## 📌 Future Improvements

* Add Comments feature
* Add Search support
* Improve cache expiration policy
* Add UI tests
* SwiftUI version

---

## ✨ Author

Dimitra Malliarou – iOS Developer
