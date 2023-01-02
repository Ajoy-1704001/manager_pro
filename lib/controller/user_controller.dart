import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:managerpro/view/avatar.dart';
import 'package:managerpro/view/home.dart';
import 'package:managerpro/view/navigation.dart';

class UserController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var avatar = "0".obs;
  var userName = "".obs;
  Future<void> createAccount(
      String email, String password, String username) async {
    try {
      final box = GetStorage();
      box.write("oldUser", 0);
      final credential = await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await db.collection("users").doc(value.user!.uid).set({
          "id": value.user!.uid,
          "username": username,
          "avatar": avatar.value
        });
      });

      box.write("oldUser", 1);
      userName.value = username; //
      Get.to(const Avatar());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(msg: "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
            msg: "The account already exists for that email");
      }
    } catch (e) {
      print(e);
    }
  }

  //User login er khetre storage er value change kora lagbe newUser
  Future<void> userLoginByEmail(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await db
          .collection("users")
          .doc(credential.user!.uid)
          .get()
          .then((value) {
        userName.value = value.get("username");
        avatar.value = value.get("avatar");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(msg: "No user found for that email");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: "Wrong password");
      }
    }
  }

  Future<void> userLoginByGoogle() async {
    try {
      final box = GetStorage();
      box.write("oldUser", 0);
      final userCredential = await signInWithGoogle().then((value) async {
        if (value.additionalUserInfo!.isNewUser) {
          await db.collection("users").doc(value.user!.uid).set({
            "id": value.user!.uid,
            "username": value.user!.displayName,
            "avatar": avatar.value
          });
          userName.value = value.user!.displayName!;
          Get.offAll(const Avatar());
        } else {
          box.write("oldUser", 1);
          userName.value = value.user!.displayName!;
          Get.offAll(const Navigation());
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      List<String> providers =
          await auth.fetchSignInMethodsForEmail(googleUser.email);
      if (providers.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "Already registered for that email",
            toastLength: Toast.LENGTH_LONG);
        await GoogleSignIn().signOut();
        throw Exception;
      }
    }
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void saveAvater(String i) async {
    avatar.value = i;
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"avatar": avatar.value});
    Get.offAll(const Navigation());
  }
}