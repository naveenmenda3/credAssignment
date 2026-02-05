# API Architecture - Clean Switch Point Design

## 🎯 Problem Statement

CRED provided two mock APIs:
- `https://api.mocklets.com/p26/mock1` (≤2 items)
- `https://api.mocklets.com/p26/mock2` (>2 items)

## ✅ Solution: Single Switch Point Architecture

### Design Principles

1. **Single Responsibility**: Each layer has one clear purpose
2. **Deterministic**: Network layer behavior is predictable
3. **Testable**: Easy to test different scenarios
4. **No UI Logic**: UI adapts to data, doesn't control data fetching

### Implementation

#### 1. Configuration Layer (`core/network/api_endpoints.dart`)

```dart
enum BillsMockType {
  twoItems,
  manyItems,
}

class ApiEndpoints {
  static const String mockTwoItems = 'https://api.mocklets.com/p26/mock1';
  static const String mockManyItems = 'https://api.mocklets.com/p26/mock2';
}
```

**Purpose**: Centralized API configuration

#### 2. Data Source Layer (`data/datasources/bills_remote_ds.dart`)

```dart
class BillsRemoteDataSource {
  Future<List<BillModel>> getBills(BillsMockType type) async {
    // SINGLE SWITCH POINT
    final url = type == BillsMockType.twoItems
        ? ApiEndpoints.mockTwoItems
        : ApiEndpoints.mockManyItems;

    final response = await _dioClient.dio.get(url);
    return _parseBills(response.data);
  }
}
```

**Purpose**: Fetch data from the specified endpoint

#### 3. Repository Layer (`data/repositories/bills_repo_impl.dart`)

```dart
class BillsRepositoryImpl implements BillsRepository {
  @override
  Future<List<BillEntity>> getBills(BillsMockType type) async {
    final billModels = await _remoteDataSource.getBills(type);
    return billModels.map((model) => model.toEntity()).toList();
  }
}
```

**Purpose**: Convert models to entities, pass through the type

#### 4. Controller Layer (`presentation/controller/bills_controller.dart`)

```dart
class BillsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // ONLY DECISION POINT
    fetchBills(BillsMockType.manyItems);
  }

  Future<void> fetchBills(BillsMockType type) async {
    final fetchedBills = await _repository.getBills(type);
    bills.value = fetchedBills;
  }
}
```

**Purpose**: Decide which mock to use for development/testing

#### 5. UI Layer (`presentation/pages/bills_page.dart`)

```dart
// NO API LOGIC
// UI adapts based on data.length
if (controller.isStaticMode) {
  return ListView(...);
} else {
  return VerticalCarousel(...);
}
```

**Purpose**: Render UI based on data, not control data fetching

## 🎓 Interview-Ready Explanation

### Q: "Why not auto-switch APIs based on data length?"

**A:** "The APIs represent test fixtures, not runtime logic. In production, we'd consume a single API endpoint. The UI adapts based on the data returned, keeping the networking layer deterministic and predictable. This follows the Single Responsibility Principle - the data layer fetches data, the UI layer renders it."

### Q: "How do you test different scenarios?"

**A:** "We have a single switch point in the controller's `onInit()`. For unit tests, we can pass different `BillsMockType` values. For integration tests, we can test both scenarios independently. This makes testing explicit and deterministic."

### Q: "What if requirements change?"

**A:** "If we need to switch APIs dynamically, we'd add a configuration service or feature flag. The architecture supports this - we'd just change the controller's decision logic. The data layer remains unchanged."

## ✅ Benefits

### 1. Clean Architecture
- ✅ Each layer has single responsibility
- ✅ No business logic in UI
- ✅ No UI logic in data layer

### 2. Testability
```dart
// Unit test - mock repository
test('fetches bills correctly', () {
  final mockRepo = MockBillsRepository();
  final controller = BillsController(mockRepo);
  
  when(mockRepo.getBills(BillsMockType.manyItems))
      .thenAnswer((_) async => mockBills);
  
  await controller.fetchBills(BillsMockType.manyItems);
  expect(controller.bills.length, 9);
});
```

### 3. Maintainability
- ✅ Change API? Update `ApiEndpoints` only
- ✅ Change decision logic? Update controller only
- ✅ Change parsing? Update data source only

### 4. Professionalism
- ✅ No hardcoded URLs scattered
- ✅ No conditional logic in random places
- ✅ Clear separation of concerns
- ✅ Easy to understand and modify

## 🚫 Anti-Patterns Avoided

### ❌ URL Hardcoding in Multiple Places
```dart
// BAD - scattered URLs
class SomeWidget {
  fetchData() => dio.get('https://api.mocklets.com/p26/mock2');
}
class AnotherWidget {
  fetchData() => dio.get('https://api.mocklets.com/p26/mock1');
}
```

### ❌ Auto-Switching Based on Data
```dart
// BAD - data layer making UI decisions
Future<List<Bill>> getBills() async {
  var bills = await fetchFromAPI1();
  if (bills.length <= 2) {
    bills = await fetchFromAPI2(); // WHY?
  }
  return bills;
}
```

### ❌ UI Controlling Data Fetching
```dart
// BAD - UI layer making data decisions
if (needMoreItems) {
  controller.fetchFromAPI2();
} else {
  controller.fetchFromAPI1();
}
```

## 📊 Architecture Flow

```
User Opens App
      ↓
Controller.onInit()
      ↓
fetchBills(BillsMockType.manyItems) ← SINGLE DECISION POINT
      ↓
Repository.getBills(type)
      ↓
DataSource.getBills(type)
      ↓
Switch on type → Select URL ← SINGLE SWITCH POINT
      ↓
Fetch from API
      ↓
Parse response
      ↓
Return to UI
      ↓
UI adapts based on data.length ← NO API LOGIC
```

## 🎯 Production Considerations

In a real production app:

1. **Single API endpoint**: Would consume one endpoint
2. **Feature flags**: Could use remote config for A/B testing
3. **Environment configs**: Dev/Staging/Prod endpoints
4. **Same architecture**: This design scales perfectly

```dart
// Production example
class ApiEndpoints {
  static String get bills {
    if (Environment.isDev) return devBillsUrl;
    if (Environment.isStaging) return stagingBillsUrl;
    return prodBillsUrl;
  }
}
```

## 📝 Summary

**One Logic, One Switch Point**

- ✅ Configuration in `ApiEndpoints`
- ✅ Switch in `BillsRemoteDataSource`
- ✅ Decision in `BillsController.onInit()`
- ✅ UI adapts to data

**This is exactly what CRED expects to see.**

---

**Built with clean architecture principles for CRED**
