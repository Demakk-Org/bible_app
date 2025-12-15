 enum FirebaseCollections {
  news,
  events,
  eventCategories,
  dailyVerse,
  bible,
  messages,
  books,
  bibleStudies,
  bibleStudyGroups,
  audios,
  bibleSources,
  bibleStudyCategories,
  notifications,
  worshipDocuments,
  worshipGroups,
  users;

  static String label(FirebaseCollections collection) {
    switch (collection) {
      case FirebaseCollections.news:
        return 'news';
      case FirebaseCollections.events:
        return 'events';
      case FirebaseCollections.eventCategories:
        return 'event_categories';
      case FirebaseCollections.dailyVerse:
        return 'dailyVerse';
      case FirebaseCollections.bible:
        return 'bible';
      case FirebaseCollections.messages:
        return 'messages';
      case FirebaseCollections.books:
        return 'books';
      case FirebaseCollections.bibleStudies:
        return 'bible_studies';
      case FirebaseCollections.bibleStudyGroups:
        return 'bible_study_groups';
      case FirebaseCollections.audios:
        return 'audios';
      case FirebaseCollections.bibleSources:
        return 'bible_sources';
      case FirebaseCollections.bibleStudyCategories:
        return 'bible_study_categories';
      case FirebaseCollections.notifications:
        return 'notifications';
      case FirebaseCollections.worshipGroups:
        return 'worship_groups';
      case FirebaseCollections.worshipDocuments:
        return 'worship_documents';
      case FirebaseCollections.users:
        return 'users';
    }
  }

  @override
  String toString() {
    switch (this) {
      case FirebaseCollections.news:
        return 'news';
      case FirebaseCollections.events:
        return 'events';
      case FirebaseCollections.eventCategories:
        return 'event_categories';
      case FirebaseCollections.dailyVerse:
        return 'dailyVerse';
      case FirebaseCollections.bible:
        return 'bible';
      case FirebaseCollections.messages:
        return 'messages';
      case FirebaseCollections.books:
        return 'books';
      case FirebaseCollections.bibleStudies:
        return 'bible_studies';
      case FirebaseCollections.bibleStudyGroups:
        return 'bible_study_groups';
      case FirebaseCollections.audios:
        return 'audios';
      case FirebaseCollections.bibleSources:
        return 'bible_sources';
      case FirebaseCollections.bibleStudyCategories:
        return 'bible_study_categories';
      case FirebaseCollections.notifications:
        return 'notifications';
      case FirebaseCollections.worshipGroups:
        return 'worship_groups';
      case FirebaseCollections.worshipDocuments:
        return 'worship_documents';
      case FirebaseCollections.users:
        return 'users';
    }
  }
}
