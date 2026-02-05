# Bills Carousel - Flutter Clean Architecture

A production-ready Flutter application showcasing **Clean Architecture** with **Feature-First** structure, **GetX** state management, and **Dio** networking.

## 🏗️ Architecture Overview

### Clean Architecture Layers

```
lib/
 ├── core/                          # Shared utilities & infrastructure
 │    ├── network/
 │    │    └── dio_client.dart      # Reusable Dio HTTP client
 │    └── performance/
 │         └── frame_drop_tracker.dart  # Performance monitoring
 │
 ├── features/                      # Feature-first organization
 │    └── bills_carousel/
 │         ├── data/                # Data Layer
 │         │    ├── models/         # JSON serializable models
 │         │    ├── datasources/    # Remote/Local data sources
 │         │    └── repositories/   # Repository implementations
 │         │
 │         ├── domain/              # Business Logic Layer
 │         │    ├── entities/       # Pure business objects
 │         │    └── repositories/   # Repository contracts
 │         │
 │         └── presentation/        # UI Layer
 │              ├── controller/     # GetX controllers
 │              ├── widgets/        # Reusable UI components
 │              └── pages/          # Screen widgets
 │
 └── main.dart                      # App entry point & DI setup
```

## 🎯 Key Features

### 1. **Clean Architecture Principles**
- ✅ **Separation of Concerns**: Domain, Data, and Presentation layers
- ✅ **Dependency Inversion**: Domain layer has no dependencies
- ✅ **Single Responsibility**: Each class has one clear purpose
- ✅ **Testability**: Easy to mock and test each layer

### 2. **State Management (GetX)**
- Reactive state with `Rx` types
- Dependency injection with `Get.lazyPut`
- Automatic memory management
- Clean controller lifecycle

### 3. **Networking (Dio)**
- Centralized HTTP client configuration
- Request/Response logging
- Timeout handling
- Clean error handling

### 4. **Performance Optimization**
- Frame drop tracking with `SchedulerBinding`
- Const constructors where possible
- Optimized rebuild prevention
- Smooth 60fps animations

### 5. **UI Features**
- **Carousel Mode**: Vertical PageView with smooth animations (>2 bills)
- **Static Mode**: Simple list view (≤2 bills)
- **3D Flip Animation**: Rotating tag text
- **Gradient Cards**: Beautiful bill card designs
- **Responsive**: Adapts to different screen sizes

## 📦 Dependencies

```yaml
dependencies:
  get: ^4.6.6        # State management
  dio: ^5.4.0        # HTTP client
```

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Build for Release
```bash
flutter build apk --release
```

## 🔧 Configuration

### API Integration

Currently using **mock data**. To integrate with a real API:

1. Update `DioClient` base URL in `main.dart`:
```dart
Get.lazyPut<DioClient>(
  () => DioClient(baseUrl: 'https://your-api.com'),
  fenix: true,
);
```

2. Switch to real API in `bills_remote_ds.dart`:
```dart
// Change from:
final billModels = await _remoteDataSource.fetchMockBills();

// To:
final billModels = await _remoteDataSource.fetchBills();
```

## 📱 UI Modes

### Carousel Mode (>2 bills)
- Vertical scrolling PageView
- Scale and opacity effects
- Smooth page transitions
- Current index tracking

### Static Mode (≤2 bills)
- Simple ListView
- No carousel animations
- Better for fewer items

## 🎨 UI Components

### BillCard
- Gradient background based on status
- Bank icon and name
- Masked card number
- Amount display
- Pay Now CTA button
- Status tag (Paid/Pending/Overdue)
- Flip tag animation

### FlipTag
- 3D rotation animation
- Conditional flipping based on `flipperConfig`
- Smooth AnimatedSwitcher transitions

### VerticalCarousel
- PageView.builder with vertical scroll
- Scale effect for background cards
- Opacity animation
- No frame drops

## 🧪 Testing

The architecture supports easy testing:

```dart
// Example: Testing BillsController
final mockRepository = MockBillsRepository();
final controller = BillsController(mockRepository);

// Test loading state
expect(controller.isLoading.value, false);

// Test fetch
await controller.fetchBills();
expect(controller.bills.length, greaterThan(0));
```

## 📊 Performance Monitoring

Use `FrameDropTracker` to monitor performance:

```dart
final tracker = FrameDropTracker();
tracker.startTracking();

// ... perform operations ...

tracker.stopTracking();
print(tracker.getReport());
// Output: {totalFrames: 120, droppedFrames: 2, dropRate: 1.67%, ...}
```

## 🏆 Best Practices Implemented

1. **Null Safety**: Full null-safe implementation
2. **Const Constructors**: Used wherever possible
3. **Immutability**: Domain entities are immutable
4. **Error Handling**: Comprehensive try-catch blocks
5. **Code Organization**: Clear folder structure
6. **Naming Conventions**: Descriptive and consistent
7. **Comments**: Clear documentation
8. **Performance**: Optimized for 60fps

## 📝 Code Quality

- ✅ No lint warnings
- ✅ Follows Flutter style guide
- ✅ Production-ready code
- ✅ Maintainable and scalable
- ✅ Clean separation of concerns

## 🔄 Data Flow

```
User Action
    ↓
BillsPage (UI)
    ↓
BillsController (GetX)
    ↓
BillsRepository (Interface)
    ↓
BillsRepositoryImpl
    ↓
BillsRemoteDataSource
    ↓
DioClient
    ↓
API / Mock Data
```

## 🎯 Future Enhancements

- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Implement caching layer
- [ ] Add offline support
- [ ] Add pull-to-refresh
- [ ] Add pagination
- [ ] Add bill payment integration
- [ ] Add analytics tracking

## 📄 License

This project is created for demonstration purposes.

---

**Built with ❤️ using Flutter, Clean Architecture, GetX, and Dio**
