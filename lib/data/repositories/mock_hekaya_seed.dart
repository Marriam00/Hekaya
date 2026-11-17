import '../models.dart';

class MockHekayaSeed {
  MockHekayaSeed({
    required this.profiles,
    required this.books,
    required this.bookNotes,
    required this.requests,
    required this.loans,
    required this.posts,
    required this.comments,
    required this.currentProfileId,
    required this.defaultVisibility,
  });

  final List<Profile> profiles;
  final List<Book> books;
  final List<BookNote> bookNotes;
  final List<BorrowRequest> requests;
  final List<Loan> loans;
  final List<Post> posts;
  final List<Comment> comments;
  final String currentProfileId;
  final BookVisibility defaultVisibility;

  factory MockHekayaSeed.create() {
    final now = DateTime.now();
    final profiles = <Profile>[
      Profile(
        id: 'layla',
        displayName: 'Layla Al-Khatib',
        bio: 'A reader of magical realism and Mediterranean history.',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAfZqFH8SPCOFTMH2JW6t1llPI-eYKBWT0oAGFp35aVMM37kmzfNuPrl9v8EoZtpyj51a_kc9XGsspddjDd5y66Up-Ee2Zkmv4NaoqlC2NwKChVH9z7U5cIiFoOF0KeY4682pkzClTu3GoNPsf8BSp0xO0lvmQcig72yyVQ2uvB59ywLhEzTihrepj5CZWsNZQQVqgeYb00_Rz0uHoif8S2m-1i_MH5U_riS8a8uOLp',
        createdAt: DateTime(2024, 1, 12),
      ),
      Profile(
        id: 'karim',
        displayName: 'Karim Mansour',
        bio:
            'Archivist of magical realism and Mediterranean history. '
            'Coffee drinker, late-night annotator.',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAc5DJXLYouIh9GbWolY6JRugBDuGGkiFbpKXNlFw_pgN6mXTtNICRzaGvMbwMM0gIw4DQN8Oty1xXK1-e66J4MgPnvSJ1vt9uP7yirWz8OlMSqf6t6n9qGtxpEbRexlWrzvM5cHUSrEBPLATLtACrR67sf26S7Z7UH5I5w-ra-LLDVQnjNbDBWdQ3rAz7ozgWCG--QCC22oW6NSgTbW4RplF0gfdkA0JbvbIBm_HIz',
        createdAt: DateTime(2023, 10, 4),
      ),
      Profile(
        id: 'omar',
        displayName: 'Omar Farooq',
        bio: 'Collector of modern fiction and quiet mornings.',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAcHOwX907eLqGqy1tshtAYdl876PLAynuGsZDXO5kKSjGahqgEzMwoev_Gls2itAR8Xxnhk8pCmow-FxzkJdvssdKYUqR8zc2PM7jUcYp8-y85kwzBiLp5FTb5VYIvSY8goDSdJWq4fsus79bUUH-IjU-YtQHzqtn8wxmzkzlA3gCPVz2Qv0X5UxPbK6NHvpS11SCw0dOdZFJCx9S7060gxusvzPFT5BTuP4G8c-lf',
        createdAt: DateTime(2024, 3, 8),
      ),
      Profile(
        id: 'sarah',
        displayName: 'Sarah Chen',
        bio: 'Stories, translations, and the places between them.',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuARnOm-u-BTJLteLdESWa4HF8TIHo5v0vYDGDtd0bbSixEVcsvz_O2KHtoQO47Gkj3WalgGV0wDVaJNqP1YFWZsr7TxItyjzWUOIoAYlS8baJmXJnNODq9zJ24coqhWnKW1izvpmiN3nCgim4QOiZtoEXwxTthc4Z7EyIeVWJDHJUinHPs8JkRMYv2CiAfl3iOl1qhyBm6BsR93GICFak7tAhJVrnYF5t98nVilUOjO',
        createdAt: DateTime(2024, 2, 20),
      ),
    ];

    final books = <Book>[
      Book(
        id: 'shadow-of-the-wind',
        ownerId: 'layla',
        title: 'The Shadow of the Wind',
        author: 'Carlos Ruiz Zafón',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBqEVlbnIXhbj-1lHjqe3zBjGNsUD5vccUsKTzQ4VD55KIMZvdFXuvDy4uvC1vjDKiVIV_tpOf_f1gIdm0KblU4PgaysYhCpgoQULs--dst0Y_YcSatDb2PM7_JcniMQew_wS55zJ0v8RY4hwfVDsHzZQqYKHv4gIpcZmy42nYI5vNmgNNyjjKl_k8WnqxSSltVvevsyjjAZvEsLbt8O3IbYlDoenetMxv7Azeisjwr',
        description: 'A mystery hidden in the forgotten books of Barcelona.',
        genre: 'Mystery',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.reading,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Book(
        id: 'book-of-disquiet',
        ownerId: 'layla',
        title: 'The Book of Disquiet',
        author: 'Fernando Pessoa',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCEObPj0-YGrCC1-9ulxwQRK70hRaw3-_v1TpC1c-_BIGftlY65xGLg6z-q4fv7m8KmXfGCRQTBAzfzhbFrCWLmmEsq3M2Z8UYUqCYUm86JPQqxM9wxnfw0JVHwyEUT5lS1GwJQWGLAjysgIJ7HaS9r3ikHJmnIGmhmFRZdSUlL6CycOIAKjsgFuenNONO2Ky1A-_XURjIV6T7ObY3btBIfsTuTa3SFcEgQ-_tLaqer',
        description: 'Fragments of thought, solitude, and the city of Lisbon.',
        genre: 'Philosophy',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.toRead,
        createdAt: now.subtract(const Duration(days: 8)),
      ),
      Book(
        id: 'labyrinths',
        ownerId: 'layla',
        title: 'Labyrinths',
        author: 'Jorge Luis Borges',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCMw1eFOVVTdd2iAkzj-kWNU_zpaS6qRZisf63RBtYNDkBOxdAIuz3D_RROphrL1rdwfqONc8Mzmkyf22Z1lxqmQ3bWK3M5kK-ZuENG8Q2Vw1FoguBhEyqxnzyxWYvZpNQRHSwOCzTNmbvf86CE8DD_gnUio7DX8qW7O4hSU_5HbuR2jzgd0dF8Fu3rbsbXxPvQ4Gpni7IDnGfaHXCX5Np81GZ6AX5C7p9S5bxyBWWA',
        description: 'Stories about time, infinity, and imagined worlds.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.finished,
        createdAt: now.subtract(const Duration(days: 14)),
      ),
      Book(
        id: 'ficciones',
        ownerId: 'layla',
        title: 'Ficciones',
        author: 'Jorge Luis Borges',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCmu6quQXNkQh8mctnCekjp5BJ-2jXOn82kq3FrdzNst5w0ZJZMH6vcC_w30mNeUiU85way0sHdps4zbTfJ5qUV6fOLk1Qwp_J6AZJkGNvnNGETTb_SRfINUGe2lNiMdpQ00GhDQh0adsMfxC-wQ9lowJy2w-qyZPydvv2xLQzruuSvIXWrPcZNViLdt5nXdSjSByiFX_zSpDEHmD7luVxNFj20-WX7Xfker-X6k3kN',
        description: 'A collection of stories by Jorge Luis Borges.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.finished,
        createdAt: now.subtract(const Duration(days: 21)),
      ),
      Book(
        id: 'kafka-on-the-shore',
        ownerId: 'layla',
        title: 'Kafka on the Shore',
        author: 'Haruki Murakami',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuArvaynL9_2uwl4uSTUspWNrJ8Thll9zUJnjDnelayMe3256uTAjvNlqQ5yWJRwImP8-LXp4xO0MYuIYkhUFK2HkcI8gWOwWzJPL2g7ov98hR0DPEER-ySgDyGqyK-kJf4QoxMLPBRbjToIgzKo7EP06IsyfWvWkn_isTiojS6YS10t3e_elnjD6Z0vji5UtANhEPOh-ub9jTyub52x1GEbEISYnNjS81B65uY4DzcK',
        description: 'A dreamlike journey through memory and identity.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.toRead,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Book(
        id: 'gentleman-in-moscow',
        ownerId: 'layla',
        title: 'A Gentleman in Moscow',
        author: 'Amor Towles',
        coverUrl: '',
        description: 'A novel of confinement, friendship, and time.',
        genre: 'Historical Fiction',
        visibility: BookVisibility.private,
        allowLending: false,
        readingStatus: ReadingStatus.toRead,
        createdAt: now.subtract(const Duration(days: 40)),
      ),
      Book(
        id: 'invisible-cities',
        ownerId: 'karim',
        title: 'Invisible Cities',
        author: 'Italo Calvino',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDcUk2KYkXgq_FURrfe2c1L3ewPMQDUTjp6KafzeQAAh_BVr46wEySgjC8JDqvNW1HUlWplvVc-bDDt4QQ1lvilEPo_RvMmSInm7iWVA2eJOHqgZ1sAMn2hCORWqbmFCVI3OPHVw489673xSjIAl_rlcyC5RZlhppAwfp8WcuhDB4q_tYG_xtu6ORCpgln5TAUyJsZhGh_zPpmfv3AimF-pKX-o_l7LvvRB46QRMLUD',
        description: 'A traveler recounts the cities of an imagined empire.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.reading,
        createdAt: now.subtract(const Duration(days: 11)),
      ),
      Book(
        id: 'master-and-margarita',
        ownerId: 'karim',
        title: 'The Master and Margarita',
        author: 'Mikhail Bulgakov',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAw_ElpSOsYg5BPk09ldumZaubJG9_3JAjs5JGz06o4bHCeifZyhOA3quEYJ4iB5Hj35xZMMLY6pIhQLr06zYDaxR_9vkIXoXlP7f8_uJ7pFp0AK_DHjWyPxMxbmnO6Q0pRb3IRQRSVGy3X2aZv2C1fKr8_tDnmujpJgXKt09ILKrOHpPNdv_CZjz4KMv_qlGYPsKAwZO99CTT7NquqU1IFx1fDm8dh326godqFaiSS',
        description: 'Satire, love, and the fantastic in Soviet Moscow.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.finished,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Book(
        id: 'orlando',
        ownerId: 'sarah',
        title: 'Orlando',
        author: 'Virginia Woolf',
        coverUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA3x5pyMmNHkNC2ahHH4r4e-0FtaWbM910vyveWN8EfXCv0HaXq6Fz_l9BJYeuWfAzdKMNvyQecemg1_Fc-BtoHD2PTiZLTRd3prA5q7LrZNroUTS517hWWi_pbdFP3CvdH4qi-vlso1NgDelbC6C2S463Q_eEa28yNhCjojCiKR0c4ObmvOnqO9byf1_9bmkR6X59msaNV6WUWxjzfoISdwFWUCQg3lMD68_ABKSRM',
        description: 'A playful biography that travels across centuries.',
        genre: 'Fiction',
        visibility: BookVisibility.public,
        allowLending: true,
        readingStatus: ReadingStatus.toRead,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];

    final requests = <BorrowRequest>[
      BorrowRequest(
        id: 'request-omar-kafka',
        bookId: 'kafka-on-the-shore',
        requesterId: 'omar',
        ownerId: 'layla',
        message: 'I would love to read this for our next circle discussion.',
        status: BorrowRequestStatus.pending,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      BorrowRequest(
        id: 'request-layla-master',
        bookId: 'master-and-margarita',
        requesterId: 'layla',
        ownerId: 'karim',
        message: 'Could I borrow this for the weekend?',
        status: BorrowRequestStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    final loans = <Loan>[
      Loan(
        id: 'loan-ficciones',
        bookId: 'ficciones',
        borrowerId: 'sarah',
        ownerId: 'layla',
        status: LoanStatus.active,
        borrowedAt: now.subtract(const Duration(days: 9)),
        expectedReturnAt: now.add(const Duration(days: 5)),
        returnedAt: null,
      ),
      Loan(
        id: 'loan-invisible-cities',
        bookId: 'invisible-cities',
        borrowerId: 'layla',
        ownerId: 'karim',
        status: LoanStatus.active,
        borrowedAt: now.subtract(const Duration(days: 8)),
        expectedReturnAt: now.add(const Duration(days: 6)),
        returnedAt: null,
      ),
    ];

    final posts = <Post>[
      Post(
        id: 'post-karim-invisible-cities',
        authorId: 'karim',
        bookId: 'invisible-cities',
        content:
            'With cities, it is as with dreams: everything imaginable can '
            'be dreamed, but even the most unexpected dream is a rebus that '
            'conceals a desire. What does your favorite city in Calvino '
            'reveal about its traveler?',
        type: PostType.thought,
        createdAt: now.subtract(const Duration(minutes: 18)),
      ),
      Post(
        id: 'post-layla-invisible-cities',
        authorId: 'layla',
        bookId: 'invisible-cities',
        content:
            'Revisiting Calvino’s Invisible Cities tonight. How many of us '
            'read a book once for the story, and the second time for the city '
            'it builds in our thoughts?',
        type: PostType.thought,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Post(
        id: 'post-sarah-translation',
        authorId: 'sarah',
        bookId: null,
        content:
            'Which Borges translation do you find most faithful to his '
            'philosophical cadence?',
        type: PostType.question,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    final comments = <Comment>[
      Comment(
        id: 'comment-karim-1',
        postId: 'post-karim-invisible-cities',
        authorId: 'layla',
        content: 'I keep returning to Zaira and the memories held in objects.',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      Comment(
        id: 'comment-sarah-1',
        postId: 'post-karim-invisible-cities',
        authorId: 'sarah',
        content: 'The city changes each time the traveler tells it.',
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      Comment(
        id: 'comment-omar-1',
        postId: 'post-karim-invisible-cities',
        authorId: 'omar',
        content: 'For me it is the city that remembers every departure.',
        createdAt: now.subtract(const Duration(minutes: 10)),
      ),
      Comment(
        id: 'comment-karim-2',
        postId: 'post-karim-invisible-cities',
        authorId: 'karim',
        content: 'That image of the city as memory has stayed with me too.',
        createdAt: now.subtract(const Duration(minutes: 8)),
      ),
      Comment(
        id: 'comment-layla-2',
        postId: 'post-karim-invisible-cities',
        authorId: 'layla',
        content: 'Perhaps every map is also a map of what we miss.',
        createdAt: now.subtract(const Duration(minutes: 6)),
      ),
      Comment(
        id: 'comment-sarah-2',
        postId: 'post-karim-invisible-cities',
        authorId: 'sarah',
        content: 'I would love to compare notes over the final chapter.',
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
      Comment(
        id: 'comment-omar-2',
        postId: 'post-karim-invisible-cities',
        authorId: 'omar',
        content: 'A lovely question for our next reading circle.',
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      Comment(
        id: 'comment-karim-layla-1',
        postId: 'post-layla-invisible-cities',
        authorId: 'karim',
        content: 'I remember lending you this copy. The margins are yours now.',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      Comment(
        id: 'comment-sarah-layla-1',
        postId: 'post-layla-invisible-cities',
        authorId: 'sarah',
        content: 'The second reading always finds a different city.',
        createdAt: now.subtract(const Duration(minutes: 40)),
      ),
    ];

    return MockHekayaSeed(
      profiles: profiles,
      books: books,
      bookNotes: const [
        BookNote(
          id: 'note-ficciones',
          bookId: 'ficciones',
          content: 'A favorite copy to revisit when the evenings turn quiet.',
        ),
      ],
      requests: requests,
      loans: loans,
      posts: posts,
      comments: comments,
      currentProfileId: 'layla',
      defaultVisibility: BookVisibility.public,
    );
  }
}
