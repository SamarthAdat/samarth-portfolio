/// A tiny service locator used by the composition root.
///
/// Deliberately dependency-free: registrations are created once in
/// `lib/app/di/injection_container.dart` and resolved only at composition
/// points (the app widget). No layer below presentation ever touches it.
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  final Map<Type, Object> _singletons = <Type, Object>{};
  final Map<Type, Object Function()> _factories = <Type, Object Function()>{};

  /// Registers an eagerly created, shared instance.
  void registerSingleton<T extends Object>(T instance) {
    _singletons[T] = instance;
  }

  /// Registers a builder that produces a new instance on every [get] call.
  void registerFactory<T extends Object>(T Function() builder) {
    _factories[T] = builder;
  }

  /// Registers a builder whose result is created on first use and then cached.
  void registerLazySingleton<T extends Object>(T Function() builder) {
    _factories[T] = () {
      final T instance = builder();
      _singletons[T] = instance;
      _factories.remove(T);
      return instance;
    };
  }

  T get<T extends Object>() {
    final Object? singleton = _singletons[T];
    if (singleton != null) return singleton as T;

    final Object Function()? factory = _factories[T];
    if (factory != null) return factory() as T;

    throw StateError(
      'No registration found for $T. '
      'Register it in the injection container before use.',
    );
  }

  bool isRegistered<T extends Object>() =>
      _singletons.containsKey(T) || _factories.containsKey(T);

  /// Clears every registration. Intended for tests.
  void reset() {
    _singletons.clear();
    _factories.clear();
  }
}

/// Shorthand for the global locator instance.
ServiceLocator get sl => ServiceLocator.instance;
