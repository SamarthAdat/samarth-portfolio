/// The raw portfolio payload.
///
/// Shaped exactly like a JSON document so that swapping this constant for an
/// asset file, a CMS response, or an API call means changing only the local
/// data source — models, repositories, and widgets stay untouched.
const Map<String, dynamic> kPortfolioContent = <String, dynamic>{
  'profile': <String, dynamic>{
    'fullName': 'Samarth Vishnu Adat',
    'role': 'Software Engineer',
    'subtitle': 'Flutter Developer • Firebase • Cloud Native Apps',
    'location': 'Kolhapur, Maharashtra',
    'email': 'samarthadat2002@gmail.com',
    'phone': '+91 9172935930',
    'initials': 'SA',
    'channels': <Map<String, dynamic>>[
      <String, dynamic>{
        'type': 'email',
        'label': 'EMAIL',
        'displayValue': 'samarthadat2002@gmail.com',
        'actionUrl': 'mailto:samarthadat2002@gmail.com',
      },
      <String, dynamic>{
        'type': 'phone',
        'label': 'PHONE',
        'displayValue': '+91 9172935930',
        'actionUrl': 'tel:+919172935930',
      },
      <String, dynamic>{
        'type': 'location',
        'label': 'LOCATION',
        'displayValue': 'Kolhapur, Maharashtra',
        'actionUrl': null,
      },
      <String, dynamic>{
        'type': 'github',
        'label': 'GITHUB',
        'displayValue': 'https://github.com/samarthadat',
        'actionUrl': 'https://github.com/samarthadat',
      },
      <String, dynamic>{
        'type': 'linkedIn',
        'label': 'LINKEDIN',
        'displayValue': 'https://www.linkedin.com/in/samarthadat/',
        'actionUrl': 'https://www.linkedin.com/in/samarthadat',
      },
    ],
  },
  'about': <String, dynamic>{
    'badgeLabel': 'Engineering Profile',
    'headline': 'Building scalable mobile products with clear product impact.',
    'summary':
        'Software engineer focused on building cloud-native mobile products from concept to scale. '
        'I work across Flutter apps, Firebase and Node.js microservices, Kubernetes-based infrastructure, '
        'and CI/CD pipelines that keep releases fast, stable, and production-ready.',
    'coreSkillCount': 16,
    'metrics': <Map<String, dynamic>>[
      <String, dynamic>{
        'kind': 'audience',
        'value': '10k+',
        'label': 'Farmers using production app',
      },
      <String, dynamic>{
        'kind': 'performance',
        'value': '60%',
        'label': 'Faster post loading performance',
      },
      <String, dynamic>{
        'kind': 'leadership',
        'value': '8',
        'label': 'Engineers led on core product',
      },
      <String, dynamic>{
        'kind': 'award',
        'value': 'INR 50k',
        'label': 'Startup competition award',
      },
    ],
    'valuePropositions': <Map<String, dynamic>>[
      <String, dynamic>{
        'area': 'mobile',
        'title': 'Mobile Apps',
        'description':
            'Design and ship production Flutter apps with polished UX, real-time features, and measurable product impact.',
      },
      <String, dynamic>{
        'area': 'backend',
        'title': 'Backend APIs',
        'description':
            'Build modular backend services with Node.js and Firebase Cloud Functions for chat, offers, geolocation, and community flows.',
      },
      <String, dynamic>{
        'area': 'cloud',
        'title': 'Cloud Systems',
        'description':
            'Deploy and monitor cloud infrastructure using AWS EC2, Kubernetes, ALB Ingress, Prometheus, and Grafana.',
      },
      <String, dynamic>{
        'area': 'analytics',
        'title': 'Analytics',
        'description':
            'Improve reliability through search optimization, pagination, analytics, Crashlytics, and CI/CD release pipelines.',
      },
    ],
  },
  'resume': <String, dynamic>{
    'intro':
        'A concise view of my delivery track record, education, and technical depth across mobile, backend, and cloud systems.',
    'highlights': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Current Role',
        'value': 'Software Engineer',
        'detail': 'SaffronEdge · Since Feb 2024',
      },
      <String, dynamic>{
        'title': 'Production Impact',
        'value': '10,000+ Users',
        'detail': 'Krishi Sanskriti on Play Store',
      },
      <String, dynamic>{
        'title': 'Performance Win',
        'value': '60% Faster',
        'detail': 'Post loading optimization',
      },
    ],
    'experiences': <Map<String, dynamic>>[
      <String, dynamic>{
        'role': 'Software Engineer',
        'company': 'SaffronEdge - Tech Universe',
        'duration': 'Feb 2024 - Present',
        'location': 'Kolhapur, Maharashtra',
        'points': <String>[
          'Led full-stack development of the Krishi Sanskriti mobile application as team lead of an 8-member engineering group.',
          'Built a Flutter app deployed on the Play Store serving 10,000+ farmers with agri-commerce, expert consultations, farm data management, and real-time communication.',
          'Designed modular Node.js and Firebase Cloud Functions microservices for chats, offers, geolocation targeting, and community interactions.',
          'Integrated Firebase Authentication, FCM, Crashlytics, App Check, Analytics, Firestore, and Storage.',
          'Deployed and managed AWS EC2 infrastructure using Kubernetes, ALB Ingress, Prometheus, and Grafana.',
          'Built high-performance search and pagination APIs using timestamp-based infinite scroll, geospatial filters, and category filters.',
          'Reduced prior post loading time by up to 60% through optimized loading and content interleaving.',
          'Established CI/CD pipelines using Git and Jenkins for automated builds, testing, and Google Play Console updates.',
        ],
      },
      <String, dynamic>{
        'role': 'Machine Learning Intern',
        'company': 'Education Technology, IIT Bombay',
        'duration': 'May 2023 - Oct 2023',
        'location': 'Mumbai, Maharashtra',
        'points': <String>[
          'Implemented PixelCNN, a generative model for image synthesis using masked convolutions and autoregressive modeling.',
          'Worked with conditional pixel-wise probability distributions for sequential image generation.',
          'Used Google Colab, TensorFlow, and deep learning frameworks for model experimentation and debugging.',
        ],
      },
    ],
    'education': <Map<String, dynamic>>[
      <String, dynamic>{
        'degree': 'Bachelor of Engineering in Computer Science and Engineering',
        'institute':
            'Kolhapur Institute of Technology’s College of Engineering',
        'duration': '2021 - 2024',
        'result': 'CGPA: 8.22 / 10.00',
      },
      <String, dynamic>{
        'degree': 'Diploma in Electronics and Telecommunication',
        'institute': 'Government Polytechnic, Kolhapur',
        'duration': '2018 - 2021',
        'result': 'Percentage: 97.06%',
      },
    ],
    'skills': <String>[
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
    ],
    'coursework': <String>[
      'Database Management System',
      'Mobile App Development',
      'Data Structures',
      'Cloud Computing',
    ],
    'achievements': <String>[
      '2nd Prize, Founders’ Battleground (Bangalore); awarded ₹50,000 for presenting Krishi Sanskriti.',
      'Runner-up in a project-based learning competition for data analytics.',
    ],
  },
  'projects': <String, dynamic>{
    'intro':
        'Selected product work across agri-tech, conversational AI, service digitization, and ML experimentation.',
    'impactMetrics': <Map<String, dynamic>>[
      <String, dynamic>{
        'kind': 'audience',
        'value': '10k+',
        'label': 'Farmers Served',
      },
      <String, dynamic>{
        'kind': 'leadership',
        'value': '8',
        'label': 'Engineers Led',
      },
      <String, dynamic>{
        'kind': 'performance',
        'value': '60%',
        'label': 'Faster Loads',
      },
      <String, dynamic>{
        'kind': 'award',
        'value': 'INR 50k',
        'label': 'Founders Award',
      },
    ],
    'items': <Map<String, dynamic>>[
      <String, dynamic>{
        'name': 'Krishi Sanskriti',
        'category': 'agriTech',
        'role': 'Team Lead and Full-Stack Engineer',
        'duration': 'Feb 2024 - Present',
        'isFeatured': true,
        'summary':
            'A production agri-tech platform on Flutter and Firebase, built for farmers with commerce, expert consultations, real-time chat, and community workflows.',
        'outcome':
            'Deployed on Play Store and actively used by 10,000+ farmers.',
        'stack': <String>[
          'Flutter',
          'Node.js',
          'Firebase',
          'AWS EC2',
          'Kubernetes',
          'Prometheus',
        ],
        'highlights': <String>[
          'Led an 8-member engineering team and owned end-to-end delivery.',
          'Designed modular microservices and Cloud Functions for chats, offers, and geolocation targeting.',
          'Integrated Firebase Auth, FCM, Crashlytics, App Check, and Analytics.',
          'Cut feed loading time by up to 60% via optimized pagination and content interleaving.',
        ],
      },
      <String, dynamic>{
        'name': 'PixelCNN Image Generation',
        'category': 'machineLearning',
        'role': 'ML Internship Project',
        'duration': 'IIT Bombay | May 2023 - Oct 2023',
        'isFeatured': false,
        'summary':
            'Implemented autoregressive image synthesis using masked convolutions and pixel-wise conditional probability modeling.',
        'outcome':
            'Built and trained experimental deep-learning pipelines in Google Colab.',
        'stack': <String>['Python', 'TensorFlow', 'Google Colab'],
        'highlights': <String>[
          'Implemented PixelCNN architecture for sequential image generation.',
          'Strengthened model debugging and experimentation workflows on cloud notebooks.',
        ],
      },
      <String, dynamic>{
        'name': 'Sarth Ayurveda — Clinic Management System',
        'category': 'healthcare',
        'role': 'Freelance Product Engineer',
        'duration': 'Freelance · Live',
        'isFeatured': false,
        'summary':
            'Built a complete clinic operations platform by replacing paper-based workflows with a Flutter, Firebase, and GCP system.',
        'outcome':
            'Live production system with doctor and patient dashboards, digital prescriptions, billing, and automated reminders.',
        'stack': <String>[
          'Flutter',
          'Dart',
          'Firebase',
          'GCP',
          'WhatsApp API',
          'Realtime DB',
          'PDF Generation',
        ],
        'highlights': <String>[
          'Implemented complete patient history and records on Firebase Realtime DB.',
          'Added appointment reminders through WhatsApp API integrations.',
          'Digitized prescriptions and invoicing with PDF export workflows.',
          'Replaced manual paper workflow with zero manual data entry.',
        ],
      },
      <String, dynamic>{
        'name': 'KIT\'s Event Spectra',
        'category': 'conversationalAi',
        'role': 'Project Lead',
        'duration': 'Academic Team Project',
        'isFeatured': false,
        'summary':
            'Built an intelligent event-assistant chatbot and coordinated a 5-member team for seamless product integration.',
        'outcome':
            'Enabled contextual event Q&A using LangChain with OpenAI GPT-3.5.',
        'stack': <String>[
          'Python',
          'Flask',
          'NLP',
          'LangChain',
          'OpenAI',
          'React.js',
        ],
        'highlights': <String>[
          'Led planning and execution across backend, model integration, and UI workflows.',
          'Improved user support quality through prompt-driven conversational responses.',
        ],
      },
      <String, dynamic>{
        'name': 'EverDry',
        'category': 'services',
        'role': 'Android Developer',
        'duration': 'Client Product Build',
        'isFeatured': false,
        'summary':
            'Created a service and product app for Gauri Engineering Services to move offline waterproofing operations online.',
        'outcome':
            'Made appointments and product discovery available through a single mobile interface.',
        'stack': <String>['Java', 'Android Studio', 'Firebase'],
        'highlights': <String>[
          'Digitized booking flow for waterproofing consultation and scheduling.',
          'Expanded market reach with online product listing and inquiry journeys.',
        ],
      },
    ],
  },
};
