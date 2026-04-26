class PortfolioData {
  static const String name = 'Samarth Vishnu Adat';
  static const String role = 'Software Engineer';
  static const String subtitle =
      'Flutter Developer • Firebase • Cloud Native Apps';
  static const String location = 'Kolhapur, Maharashtra';
  static const String email = 'samarthadat2002@gmail.com';
  static const String phone = '+91 9172935930';

  static const String about =
      'Results-driven developer with hands-on experience in cloud-native mobile applications, '
      'microservices architecture, Firebase systems, CI/CD automation, and real-world product development. '
      'I specialize in Flutter applications, Firebase-backed real-time systems, RESTful APIs, geolocation features, '
      'monitoring dashboards, and scalable backend infrastructure.';

  static const List<InfoItem> contacts = [
    InfoItem(label: 'Email', value: 'samarthadat2002@gmail.com'),
    InfoItem(label: 'Phone', value: '+91 9172935930'),
    InfoItem(label: 'Location', value: 'Kolhapur, Maharashtra'),
    InfoItem(label: 'Role', value: 'Software Engineer'),
  ];

  static const List<String> whatIDo = [
    'Build production-grade Flutter applications with clean UI, real-time data, and Firebase integrations.',
    'Design REST APIs and Firebase Cloud Functions for chats, offers, geolocation, community, and app workflows.',
    'Work with AWS EC2, Kubernetes, ALB Ingress, Prometheus, Grafana, Jenkins, and CI/CD automation.',
    'Create scalable app features including pagination, geospatial filters, analytics, Crashlytics, and cloud messaging.',
  ];

  static const List<Experience> experience = [
    Experience(
      role: 'Software Engineer',
      company: 'SaffronEdge - Tech Universe',
      duration: 'Feb 2024 - Present',
      location: 'Kolhapur, Maharashtra',
      points: [
        'Led full-stack development of the Krishi Sanskriti mobile application as team lead of an 8-member engineering group.',
        'Built a Flutter app deployed on the Play Store serving 10,000+ farmers with agri-commerce, expert consultations, farm data management, and real-time communication.',
        'Designed modular Node.js and Firebase Cloud Functions microservices for chats, offers, geolocation targeting, and community interactions.',
        'Integrated Firebase Authentication, FCM, Crashlytics, App Check, Analytics, Firestore, and Storage.',
        'Deployed and managed AWS EC2 infrastructure using Kubernetes, ALB Ingress, Prometheus, and Grafana.',
        'Built high-performance search and pagination APIs using timestamp-based infinite scroll, geospatial filters, and category filters.',
        'Reduced prior post loading time by up to 60% through optimized loading and content interleaving.',
        'Established CI/CD pipelines using Git and Jenkins for automated builds, testing, and Google Play Console updates.',
      ],
    ),
    Experience(
      role: 'Machine Learning Intern',
      company: 'Education Technology, IIT Bombay',
      duration: 'May 2023 - Oct 2023',
      location: 'Mumbai, Maharashtra',
      points: [
        'Implemented PixelCNN, a generative model for image synthesis using masked convolutions and autoregressive modeling.',
        'Worked with conditional pixel-wise probability distributions for sequential image generation.',
        'Used Google Colab, TensorFlow, and deep learning frameworks for model experimentation and debugging.',
      ],
    ),
  ];

  static const List<Project> projects = [
    Project(
      name: 'Krishi Sanskriti',
      stack: 'Flutter, Firebase, Node.js, AWS EC2, Kubernetes',
      description:
          'A production agri-tech mobile application for farmers with agri-commerce, expert consultation, farm data management, offers, chats, and community engagement.',
    ),
    Project(
      name: 'KIT’s Event Spectra',
      stack: 'Python, NLP, Flask, LangChain, OpenAI, React.js',
      description:
          'A chatbot-based event platform using OpenAI GPT-3.5 and LangChain to provide intelligent user responses.',
    ),
    Project(
      name: 'EverDry',
      stack: 'Android Studio, Java, Firebase',
      description:
          'A service and product app for Gauri Engineering Services, helping users schedule waterproofing appointments and purchase related products.',
    ),
    Project(
      name: 'PixelCNN Image Generation',
      stack: 'Python, TensorFlow, Google Colab',
      description:
          'A deep learning implementation of PixelCNN for image synthesis using masked convolutions and autoregressive generation.',
    ),
  ];

  static const List<Education> education = [
    Education(
      degree: 'Bachelor of Engineering in Computer Science and Engineering',
      institute: 'Kolhapur Institute of Technology’s College of Engineering',
      duration: '2021 - 2024',
      result: 'CGPA: 8.22 / 10.00',
    ),
    Education(
      degree: 'Diploma in Electronics and Telecommunication',
      institute: 'Government Polytechnic, Kolhapur',
      duration: '2018 - 2021',
      result: 'Percentage: 97.06%',
    ),
  ];

  static const List<String> skills = [
    'Dart',
    'Flutter',
    'JavaScript',
    'Node.js',
    'Python',
    'Java',
    'SQL',
    'NoSQL',
    'Firestore',
    'MongoDB',
    'MySQL',
    'PostgreSQL',
    'Firebase Auth',
    'Firebase Cloud Functions',
    'FCM',
    'Firebase Storage',
    'Crashlytics',
    'Firebase Analytics',
    'App Check',
    'REST APIs',
    'AWS EC2',
    'Kubernetes',
    'Prometheus',
    'Grafana',
    'Jenkins',
    'Git',
    'GitHub',
    'Google Play Console',
    'Google Maps SDK',
    'TensorFlow',
    'Google Colab',
  ];

  static const List<String> achievements = [
    '2nd Prize – Founders’ Battleground, Bangalore; awarded ₹50,000 for presenting Krishi Sanskriti as an agri-tech solution.',
    'Runner-up in a Project-Based Learning competition for data analytics.',
  ];

  static const List<String> coursework = [
    'Database Management System',
    'Mobile App Development',
    'Data Structures',
    'Cloud Computing',
  ];
}

class InfoItem {
  final String label;
  final String value;

  const InfoItem({required this.label, required this.value});
}

class Experience {
  final String role;
  final String company;
  final String duration;
  final String location;
  final List<String> points;

  const Experience({
    required this.role,
    required this.company,
    required this.duration,
    required this.location,
    required this.points,
  });
}

class Project {
  final String name;
  final String stack;
  final String description;

  const Project({
    required this.name,
    required this.stack,
    required this.description,
  });
}

class Education {
  final String degree;
  final String institute;
  final String duration;
  final String result;

  const Education({
    required this.degree,
    required this.institute,
    required this.duration,
    required this.result,
  });
}
