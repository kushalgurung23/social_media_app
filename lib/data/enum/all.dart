enum NavigationItems {
  home,
  termsAndConditions,
  privacyPolicy,
  language,
  logOut
}

enum NewsPostFrom { newsPostList, newsPostDescription }

// WHETHER WE TOGGLED SERVICES POSTS SAVE FROM
enum ServiceToggleType {
  allService,
  recommendService,
  bookmarkService,
  searchedAndFilteredServices
}

enum ServicesFilterType { search, filter }

enum ProfileTopicType { myTopic, bookmarkTopic }

// WHEN NEWS POSTS ARE LIKED FROM EITHER NEWS POST OR CREATED POST
enum NewsPostActionFrom { newsPost, createdPost }
