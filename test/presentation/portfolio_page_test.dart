import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:samarth_portfolio/core/widgets/particle_background/particle_background.dart';
import 'package:samarth_portfolio/core/di/service_locator.dart';
import 'package:samarth_portfolio/core/theme/app_theme.dart';
import 'package:samarth_portfolio/app/di/injection_container.dart';
import 'package:samarth_portfolio/features/portfolio/presentation/controllers/contact_form_controller.dart';
import 'package:samarth_portfolio/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:samarth_portfolio/features/portfolio/presentation/pages/portfolio_page.dart';

void main() {
  late PortfolioController portfolioController;
  late ContactFormController contactFormController;

  setUp(() {
    sl.reset();
    configureDependencies();
    portfolioController = sl.get<PortfolioController>();
    contactFormController = sl.get<ContactFormController>();
  });

  tearDown(() {
    portfolioController.dispose();
    contactFormController.dispose();
    sl.reset();
  });

  /// The particle background animates continuously, so frames never stop
  /// scheduling and `pumpAndSettle` would time out. Tests advance time
  /// explicitly instead — long enough to finish the tab transition.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> pumpPage(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: PortfolioPage(
          controller: portfolioController,
          contactFormController: contactFormController,
        ),
      ),
    );
    await settle(tester);
  }

  testWidgets('renders the sidebar and the About tab on desktop', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, size: const Size(1400, 1400));

    expect(find.text('Samarth Vishnu Adat'), findsOneWidget);
    expect(find.text('About Me'), findsOneWidget);
    expect(find.text('How I Create Value'), findsOneWidget);
    expect(find.text('Core Toolchain'), findsOneWidget);
  });

  testWidgets('switches to each tab', (WidgetTester tester) async {
    await pumpPage(tester, size: const Size(1400, 1400));

    await tester.tap(find.text('Resume'));
    await settle(tester);
    expect(find.text('Professional Experience'), findsOneWidget);
    expect(find.text('Download Resume'), findsOneWidget);

    await tester.tap(find.text('Portfolio'));
    await settle(tester);
    expect(find.text('Project Case Studies'), findsOneWidget);
    expect(find.text('Krishi Sanskriti'), findsOneWidget);

    await tester.tap(find.text('Contact'));
    await settle(tester);
    expect(find.text('Send Message'), findsWidgets);
  });

  testWidgets('shows validation errors for an empty contact form', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, size: const Size(1400, 1600));

    await tester.tap(find.text('Contact'));
    await settle(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Message'));
    await settle(tester);

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Enter a subject'), findsOneWidget);
    expect(find.text('Enter your message'), findsOneWidget);
  });

  testWidgets('renders a single scrolling column on mobile', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, size: const Size(600, 1200));

    expect(find.text('Samarth Vishnu Adat'), findsOneWidget);
    expect(find.text('About Me'), findsOneWidget);
  });

  testWidgets('paints the particle background behind the content', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, size: const Size(1400, 1400));

    expect(find.byType(ParticleBackground), findsOneWidget);

    // The background must sit under the layout, not over it.
    final Stack stack = tester.widget<Stack>(
      find.descendant(
        of: find.byType(ParticleBackground),
        matching: find.byType(Stack),
      ).first,
    );
    expect(stack.children.first, isA<RepaintBoundary>());
  });

  testWidgets('background does not swallow taps meant for the content', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester, size: const Size(1400, 1400));

    // Hovering feeds the effect; the tab underneath must still react.
    final TestGesture pointer = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    addTearDown(pointer.removePointer);
    await pointer.addPointer(location: tester.getCenter(find.text('Resume')));
    await settle(tester);

    await tester.tap(find.text('Resume'));
    await settle(tester);

    expect(find.text('Professional Experience'), findsOneWidget);
  });
}
