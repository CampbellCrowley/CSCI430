import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String auth_name;
String auth_email;
String auth_imageUrl;
Future<User> signInWithGoogle() async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      // Store the retrieved data
      auth_name = user.displayName;
      auth_email = user.email;
      auth_imageUrl = user.photoURL;

      // Only taking the first part of the auth_name, i.e., First Name
      if (auth_name.contains(" ")) {
        auth_name = auth_name.substring(0, auth_name.indexOf(" "));
      }

      return user;
    }

    return null;
  } catch (error) {
    print(error);
  }
}

Future<bool> isUserLoggedIn() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var user = await _firebaseAuth.currentUser;
  print(user.displayName);
  return user != null;
}

Future<void> signOutGoogle() async {
  // await googleSignIn.signOut();
  await googleSignIn.disconnect();
  print("User Signed Out");
}
