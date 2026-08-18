# samarth-portfolio

A Flutter web portfolio for Samarth Adat, organised with clean architecture.

## Architecture

Dependencies point inwards. The domain layer knows nothing about Flutter, HTTP,
or where content is stored; the data layer implements the contracts the domain
declares; the presentation layer talks only to use cases.

```
presentation  ──▶  domain  ◀──  data
    (UI)         (contracts)   (implementations)
```

| Layer | Location | Holds |
| --- | --- | --- |
| Core | `lib/core/` | `Result`, `Failure`/exception types, use case contract, service locator, theme, config, shared widgets |
| Domain | `lib/features/portfolio/domain/` | Entities, repository interfaces, use cases, validators — pure Dart |
| Data | `lib/features/portfolio/data/` | Content payload, models with `fromJson`/`toEntity`, data sources, repository implementations |
| Presentation | `lib/features/portfolio/presentation/` | Controllers (`ChangeNotifier`), page, widgets grouped per section |
| App | `lib/app/` | Root widget and the composition root (`injection_container.dart`) |

### Rules the code follows

- **Errors never escape their layer.** Data sources throw `AppException`s;
  repositories translate them into `Failure`s and return `Result<T>`. Nothing
  above the data layer uses `try/catch`.
- **The domain has no Flutter import.** Entities carry meaning
  (`MetricKind.audience`), and `presentation/mappers/portfolio_icons.dart`
  decides which icon renders it.
- **Content is data, not markup.** Every string, project, and metric lives in
  `data/datasources/local/portfolio_content.dart`, shaped like a JSON document.
  Moving to a CMS or API means changing one data source.
- **Validation lives in the domain.** `ContactMessageValidator` backs both the
  form fields and the `SendContactMessage` use case, so they cannot disagree.
- **The service locator is used only at composition points**, never inside a
  widget or a repository.

## Particle background

`lib/core/widgets/particle_background/` draws the constellation behind the
page — drifting dots linked into a mesh, with lines that follow the cursor and
a gentle push away from it.

| File | Role |
| --- | --- |
| `particle_style.dart` | Every tunable number: density, speed, link distance, colours, interaction strength |
| `particle.dart` | One dot's position, velocity, and radius |
| `particle_field.dart` | The simulation — pure Dart, unit tested, using a uniform grid so linking stays near-linear rather than checking every pair |
| `particle_field_painter.dart` | Canvas drawing |
| `particle_background.dart` | The widget: ticker, pointer tracking, reduced-motion handling |

Adjust the look through `ParticleStyle` — either edit
`ParticleStyle.constellation()` or pass a custom instance:

```dart
ParticleBackground(
  style: const ParticleStyle.constellation(),
  child: /* page content */,
)
```

Notes:

- The pointer is tracked by a `MouseRegion` wrapping the whole subtree, so
  hovering over the cards still feeds the effect while taps, scrolls, and the
  cards' own hover states pass through untouched.
- The layer is wrapped in a `RepaintBoundary`, so its per-frame repaint does
  not touch the rest of the UI.
- It respects the platform's reduced-motion setting: the field is still drawn,
  it just holds still.
- Because it animates continuously, widget tests covering this page advance
  time with `tester.pump(duration)`; `pumpAndSettle` would wait forever.

## Updating content

Edit `lib/features/portfolio/data/datasources/local/portfolio_content.dart`.
Keys are validated on read, so a typo fails loudly with the offending key name
instead of rendering a blank section.

## Commands

```bash
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
flutter build web --release
```
