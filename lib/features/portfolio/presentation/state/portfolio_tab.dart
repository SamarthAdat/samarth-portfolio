/// The four sections of the main panel.
///
/// Navigation is a presentation concern, so the tab lives here rather than in
/// the domain, together with the copy shown in its header.
enum PortfolioTab {
  about(
    label: 'About',
    title: 'About Me',
    subtitle: 'Who I am and how I build products',
  ),
  resume(
    label: 'Resume',
    title: 'Resume',
    subtitle: 'Experience, education, and technical depth',
  ),
  portfolio(
    label: 'Portfolio',
    title: 'Portfolio',
    subtitle: 'Selected work and measurable outcomes',
  ),
  contact(label: 'Contact', title: 'Contact', subtitle: '');

  /// Text on the tab button.
  final String label;

  /// Heading above the section body.
  final String title;

  /// Eyebrow line above the heading; empty means it is omitted.
  final String subtitle;

  const PortfolioTab({
    required this.label,
    required this.title,
    required this.subtitle,
  });
}
