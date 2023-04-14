abstract class AppStates{}

class AppInitialState extends AppStates{}

// Get UserData
class GetUserLoadingState extends AppStates{}

class GetUserSuccessState extends AppStates{}

class GetUserErrorState extends AppStates{
  final String error;
  GetUserErrorState(this.error);
}

// Get AllUserData
class GetAllUsersLoadingState extends AppStates{}

class GetAllUsersSuccessState extends AppStates{}

class GetAllUsersErrorState extends AppStates{
  final String error;
  GetAllUsersErrorState(this.error);
}

// Get PostData
class GetPostLoadingState extends AppStates{}

class GetPostSuccessState extends AppStates{}

class GetPostErrorState extends AppStates{}

// Like Post
class LikePostSuccessState extends AppStates{}

class LikePostErrorState extends AppStates{}

/////////////////
class ChangeBottomNavState extends AppStates{}

class NewPostState extends AppStates{}

class GetProfileImageSuccessState extends AppStates{}
class GetProfileImageErrorState extends AppStates{}

class GetCoverImageSuccessState extends AppStates{}
class GetCoverImageErrorState extends AppStates{}

class UploadProfileImageSuccessState extends AppStates{}
class UploadProfileImageErrorState extends AppStates{}

class UploadCoverImageSuccessState extends AppStates{}
class UploadCoverImageErrorState extends AppStates{}



class UserUpdateLoadingState extends AppStates{}
class UserUpdateErrorState extends AppStates{}

// Create Post
class CreatePostLoadingState extends AppStates{}
class CreatePostSuccessState extends AppStates{}
class CreatePostErrorState extends AppStates{}

class RemovePostImageState extends AppStates{}

class GetPostImageSuccessState extends AppStates{}
class GetPostImageErrorState extends AppStates{}

// Send And Get Message
class SendMessageSuccessState extends AppStates{}
class SendMessageErrorState extends AppStates{}

class GetMessageSuccessState extends AppStates{}