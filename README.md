# SecureWallet-iOS


SecureWallet-iOS is a fintech-grade iOS project demonstrating a secure wallet and payout pipeline built with Clean Architecture, MVVM-C, and strict Test-Driven Development (TDD).

The project is designed to showcase production-quality engineering practices suitable for regulated financial systems. It intentionally mirrors how real-world fintech iOS platforms are structured, reviewed, and audited.

---
 
## 🎯 Project Goals

- Demonstrate fintech-grade iOS architecture
- Demonstrate fintech-grade iOS architecture
- Enforce strict correctness for money-like data
- Guarantee financial invariants via deterministic replay
- Apply Clean Architecture with strict module boundaries
- Use MVVM + Coordinator for scalable UI flows
- Practice Test-Driven Development from day one
- Design for auditability, determinism, and long-term maintainability

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
The domain module contains all financial rules and invariants.

## Core Components

### CoinAmount
- Immutable value object storing milliCoins  
- Prevents negative values  
- Safe arithmetic operations  

### LedgerEntry
- Immutable entity  
- Credit / Debit direction  
- Timestamped  

### Wallet (Aggregate Root)
- Owns append-only ledger  
- Balance is derived, never stored  
- Enforces all financial invariants  

### WalletRecord
- Deterministic persistence representation  

### WalletStore
- Protocol boundary for persistence  

## Financial Invariants Enforced

- Balance is never stored directly  
- Balance can never be negative  
- Debit greater than balance throws  
- Debit equal to balance succeeds  
- Failed debit does not mutate state  
- Ledger entries are append-only  
- Duplicate entry IDs are ignored (idempotency)  
- Wallet state is reconstructed via deterministic replay  

The domain is fully unit tested and framework-agnostic.

---

# 💾 Data Layer (Infrastructure)

`SecureWalletData`

Provides concrete implementations of domain protocols.

## Core Data Persistence

- `CoreDataStack` abstraction  
- `CoreDataWalletStore` conforming to `WalletStore`  
- Strict ordering via `orderIndex`  
- No balance persistence  
- Replay-based rehydration  
- Infrastructure errors wrapped as `WalletStoreError`  

## Deterministic Save Strategy

1. Convert `Wallet` → `WalletRecord`  
2. Delete existing entries  
3. Recreate entries in deterministic order  
4. Save atomically  

## Deterministic Load Strategy

1. Fetch entries sorted by `orderIndex`  
2. Map to domain entities  
3. Rehydrate via `Wallet.fromRecord`  
4. Wrap replay failures as persistence errors  

This guarantees integrity and corruption detection.

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

# 🧪 Testing Strategy (Strict TDD)

Testing is treated as a design constraint.

## Domain Tests

- 100% unit test coverage  
- All financial invariants verified  
- Edge cases validated (overdraft, idempotency, replay safety)  

## Persistence Tests

- Contract tests reused across implementations  
- In-memory store tests  
- Core Data integration tests  
- Disk-backed durability test verifying persistence across stack reinitialization  

All tests are deterministic, isolated, and reproducible.

No Apple system APIs are used directly inside tests.

---

# 🎨 App Layer (MVVM + Coordinator)

`SecureWalletApp`

- SwiftUI views  
- ViewModels without business logic  
- Coordinators orchestrating side effects only  
- Dependency injection container  

UI reacts to state.  
It does not enforce financial rules.

---

# 🔐 Fintech Engineering Principles

- Correctness over convenience  
- Deterministic state reconstruction  
- Explicit error propagation  
- No silent failures  
- Idempotent operations  
- Infrastructure isolation  
- Audit-friendly architecture  

Money is treated as hostile input.

---

# 🚧 Project Status

- ✅ Architecture and module boundaries established  
- ✅ Fully validated wallet domain  
- ✅ Deterministic Core Data persistence  
- ✅ Integration and durability tests  
- ⏳ In-memory Core Data stack for contract parity  
- ⏳ Security abstraction (Keychain + encryption)  
- ⏳ REST payout integration  
- ⏳ Minimal UI integration  

---

SecureWallet-iOS focuses on engineering rigor rather than feature breadth.  
It is designed to demonstrate how financial systems should be built on iOS: deterministic, testable, and auditable.


