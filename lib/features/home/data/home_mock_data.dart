class HomeBook {
  const HomeBook({required this.title, required this.coverUrl});

  final String title;
  final String coverUrl;
}

class HomeBorrowRequest {
  const HomeBorrowRequest({required this.memberName, required this.bookTitle});

  final String memberName;
  final String bookTitle;
}

class HomeActiveLoan {
  const HomeActiveLoan({
    required this.memberName,
    required this.bookTitle,
    required this.daysUntilDue,
  });

  final String memberName;
  final String bookTitle;
  final int daysUntilDue;
}

class HomeReadingCirclePost {
  const HomeReadingCirclePost({
    required this.memberName,
    required this.discussionTopic,
    required this.quote,
    required this.bookTitle,
    required this.timeAgo,
    required this.reflectionCount,
  });

  final String memberName;
  final String discussionTopic;
  final String quote;
  final String bookTitle;
  final String timeAgo;
  final int reflectionCount;
}

class HomeDashboardData {
  const HomeDashboardData({
    required this.greeting,
    required this.memberName,
    required this.memberAvatarUrl,
    required this.archivedLabel,
    required this.currentlyReadingTitle,
    required this.totalVolumes,
    required this.publicVolumes,
    required this.privateVolumes,
    required this.recentBooks,
    required this.activeCirculationCount,
    required this.pendingRequest,
    required this.activeLoan,
    required this.readingCirclePost,
    required this.discoverTitleCount,
  });

  final String greeting;
  final String memberName;
  final String memberAvatarUrl;
  final String archivedLabel;
  final String currentlyReadingTitle;
  final int totalVolumes;
  final int publicVolumes;
  final int privateVolumes;
  final List<HomeBook> recentBooks;
  final int activeCirculationCount;
  final HomeBorrowRequest pendingRequest;
  final HomeActiveLoan activeLoan;
  final HomeReadingCirclePost readingCirclePost;
  final int discoverTitleCount;
}

const homeMockData = HomeDashboardData(
  greeting: 'Good evening,',
  memberName: 'Layla',
  memberAvatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAfZqFH8SPCOFTMH2JW6t1llPI-eYKBWT0oAGFp35aVMM37kmzfNuPrl9v8EoZtpyj51a_kc9XGsspddjDd5y66Up-Ee2Zkmv4NaoqlC2NwKChVH9z7U5cIiFoOF0KeY4682pkzClTu3GoNPsf8BSp0xO0lvmQcig72yyVQ2uvB59ywLhEzTihrepj5CZWsNZQQVqgeYb00_Rz0uHoif8S2m-1i_MH5U_riS8a8uOLp',
  archivedLabel: 'Archived Today',
  currentlyReadingTitle: 'The Shadow of the Wind',
  totalVolumes: 24,
  publicVolumes: 18,
  privateVolumes: 6,
  recentBooks: [
    HomeBook(
      title: 'The Shadow of the Wind',
      coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBqEVlbnIXhbj-1lHjqe3zBjGNsUD5vccUsKTzQ4VD55KIMZvdFXuvDy4uvC1vjDKiVIV_tpOf_f1gIdm0KblU4PgaysYhCpgoQULs--dst0Y_YcSatDb2PM7_JcniMQew_wS55zJ0v8RY4hwfVDsHzZQqYKHv4gIpcZmy42nYI5vNmgNNyjjKl_k8WnqxSSltVvevsyjjAZvEsLbt8O3IbYlDoenetMxv7Azeisjwr',
    ),
    HomeBook(
      title: 'The Book of Disquiet',
      coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCEObPj0-YGrCC1-9ulxwQRK70hRaw3-_v1TpC1c-_BIGftlY65xGLg6z-q4fv7m8KmXfGCRQTBAzfzhbFrCWLmmEsq3M2Z8UYUqCYUm86JPQqxM9wxnfw0JVHwyEUT5lS1GwJQWGLAjysgIJ7HaS9r3ikHJmnIGmhmFRZdSUlL6CycOIAKjsgFuenNONO2Ky1A-_XURjIV6T7ObY3btBIfsTuTa3SFcEgQ-_tLaqer',
    ),
    HomeBook(
      title: 'Labyrinths',
      coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMw1eFOVVTdd2iAkzj-kWNU_zpaS6qRZisf63RBtYNDkBOxdAIuz3D_RROphrL1rdwfqONc8Mzmkyf22Z1lxqmQ3bWK3M5kK-ZuENG8Q2Vw1FoguBhEyqxnzyxWYvZpNQRHSwOCzTNmbvf86CE8DD_gnUio7DX8qW7O4hSU_5HbuR2jzgd0dF8Fu3rbsbXxPvQ4Gpni7IDnGfaHXCX5Np81GZ6AX5C7p9S5bxyBWWA',
    ),
    HomeBook(
      title: 'Invisible Cities',
      coverUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDQrOFIdXEAwNkdwp4E9fXmsMn2GbhTMkHJYDbrunB9vdU3SJjKWX56PrIXl5L1ZYr_dJHecLqla0HB_Cs4rKymvA61fl-xkCmEtTZ4OYIpB8tgj75YnZ6it35xUfYfgt-WCMHVvLLKUZvpshUBwrkgQzL8y9NXr_vSsqKWd1mniFygja4DTcs2M1WcpXeGDEedVPIanPbQKZQV6AgslUhIzdMcSQXc18LhmNgnN4po',
    ),
  ],
  activeCirculationCount: 2,
  pendingRequest: HomeBorrowRequest(
    memberName: 'Omar',
    bookTitle: 'Kafka on the Shore',
  ),
  activeLoan: HomeActiveLoan(
    memberName: 'Sarah',
    bookTitle: 'Ficciones',
    daysUntilDue: 5,
  ),
  readingCirclePost: HomeReadingCirclePost(
    memberName: 'Karim Mansour',
    discussionTopic: 'discussing Italo Calvino',
    quote: 'With cities, it is as with dreams: everything imaginable can be dreamed, but even the most unexpected dream is a rebus that conceals a desire...',
    bookTitle: 'Invisible Cities',
    timeAgo: '18m ago',
    reflectionCount: 7,
  ),
  discoverTitleCount: 142,
);
