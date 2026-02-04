# SecureWallet-iOS


SecureWallet-iOS is a fintech-grade iOS project demonstrating a secure wallet and payout pipeline built with Clean Architecture, MVVM-C, and strict Test-Driven Development (TDD).

The project is designed to showcase production-quality engineering practices suitable for regulated financial systems. It intentionally mirrors how real-world fintech iOS platforms are structured, reviewed, and audited.

---

## 🎯 Project Goals

- Demonstrate fintech-grade iOS architecture
- Enforce correctness for money-like data
- Apply strict Clean Architecture boundaries
- Use MVVM-C for scalable navigation
- Practice Test-Driven Development from day one
- Design for auditability, testability, and long-term maintainability

---

## 🏗 Architecture Overview

The project is divided into three primary modules:

```text
SecureWalletApp     → iOS Application (MVVM-C)
SecureWalletDomain  → Pure business logic (no frameworks)
SecureWalletData    → Infrastructure & implementations
```


### Dependency Rules

- App → Domain ✅
- App → Data ✅
- Data → Domain ✅
- Domain → App ❌
- Domain → Data ❌

These rules are enforced using separate framework targets.

---

## 🧠 Domain Layer (Single Source of Truth)

The `SecureWalletDomain` module contains:

- Entities (Wallet, Money, Ledger)
- Value Objects (Currency, Amount)
- Use Cases (business rules only)
- Repository protocols
- Explicit domain errors

Rules:
- No SwiftUI
- No UIKit
- No Combine
- No networking
- No persistence
- No Apple system APIs

The Domain module is fully testable in isolation.

---

## 🔌 Data Layer (Infrastructure)

The `SecureWalletData` module provides:

- Repository implementations
- REST API client abstraction
- Secure storage (Keychain)
- Cryptography boundaries

Rules:
- Depends on Domain
- Implements Domain protocols
- Fully mockable
- Replaceable per environment

---

## 🎨 App Layer (MVVM-C)

The `SecureWallet` app target contains:

- SwiftUI Views
- ViewModels (`@Observable`)
- Coordinators for navigation and side effects
- Dependency container

Rules:
- ViewModels contain no business logic
- Coordinators orchestrate flows only
- UI reacts to state, never decides financial rules

---

## 🧪 Testing Strategy (TDD)

- Tests are written before implementation
- Domain logic is 100% unit tested
- Infrastructure is tested with mocks
- No Apple system APIs are used directly in tests

Test targets:
- SecureWalletDomainTests
- SecureWalletDataTests
- SecureWalletTests

---

## 🔐 Fintech Principles

- Correctness over convenience
- Explicit error handling
- No silent failures
- Deterministic behavior
- Money is treated as hostile input

---

## 🚧 Project Status

This project is intentionally developed in phases:

- ✅ Architecture & module setup
- ⏳ Domain modeling with TDD (in progress)
- ⏳ Infrastructure implementation
- ⏳ Minimal UI integration

---


