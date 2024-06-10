import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsplus_finance/core/app/app_export.dart';
import 'package:dsplus_finance/core/utils/progress_dialog_utils.dart';
import 'package:dsplus_finance/data/models/login/post_login_req.dart';
import 'package:dsplus_finance/data/models/login/post_login_resp.dart';
import 'package:dsplus_finance/data/models/register/post_register_req.dart';
import 'package:dsplus_finance/data/models/register/post_register_resp.dart';
import 'package:dsplus_finance/firebase_options.dart';
import 'package:dsplus_finance/presentation/home_page/models/transactions_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ApiClient {
  // Initialize Firebase
  static Future<void> initializeFirebase() async =>
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///method can be used for checking internet connection
  ///returns [bool] based on availability of internet
  Future<void> isNetworkConnected() async {
    if (!await NetworkInfo().isConnected()) {
      throw NoInternetException('No Internet Found!');
    }
  }

  Future<PostLoginResp> createLogin({required PostLoginReq user}) async {
    try {
      ProgressDialogUtils.showProgressDialog();
      await isNetworkConnected();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      ProgressDialogUtils.hideProgressDialog();

      // Retrieve user data from Firestore
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      PostLoginRespData loginData = PostLoginRespDataMapper.fromMap(
          snapshot.data() as Map<String, dynamic>);

      loginData.id = userCredential.user!.uid;

      if (snapshot.exists) {
        return PostLoginResp(data: loginData);
      } else {
        return PostLoginResp();
      }
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<PostRegisterResp> createRegister(
      {required PostRegisterReq user}) async {
    try {
      ProgressDialogUtils.showProgressDialog();
      await isNetworkConnected();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );

      Map<String, dynamic> currentUser = user.toJson();

      currentUser['id'] = userCredential.user!.uid;

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(currentUser, SetOptions(merge: true));

      ProgressDialogUtils.hideProgressDialog();

      PostRegisterResp postRegisterResp = PostRegisterResp(
          data: Data(
              name: user.name,
              email: user.email,
              password: user.password,
              id: userCredential.user!.uid,
              role: user.role,
              username: user.username,
              profile: user.profile));
      return postRegisterResp;
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Stream<List<TransactionsModel>> getAllTransactions() {
    try {
      // ProgressDialogUtils.showProgressDialog();
      // await isNetworkConnected();
      // List<TransactionsModel> firebaseModelList = [];
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';

      var transactions =
          _firestore.collection('users').doc(userID).collection('transactions');

      return transactions.snapshots().map(
        (event) {
          return event.docs.map((e) {
            var data = e.data();
            return TransactionsModel.fromJson(data, e.id);
          }).toList();

          // for (var docSnapshot in event.docs) {
          //   firebaseModelList.add(TransactionsModel.fromJson(
          //       docSnapshot.data()));
          // }
          // return firebaseModelList;
        },
      );
      // ProgressDialogUtils.hideProgressDialog();
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

////////////////////////////////////////////////////////////////////////////////////////
  ///
  Future<TransactionsModel> addTransactions(
      TransactionsModel transaction) async {
    // Future<void> addTransactions(TransactionsModel transaction) async {
    try {
      String userID = FirebaseAuth.instance.currentUser?.uid ?? '';

      var transactionsRef = _firestore
        .collection('users')
        .doc(userID)
        .collection('transactions')
        .doc(); // Get a reference to a new document
    String transactionID = transactionsRef.id; // Get the generated ID

    // Set the transaction ID in the transaction model
    transaction = transaction.copyWith(id: transactionID);

    // Set the transaction data in Firestore along with the generated ID
    await transactionsRef.set(transaction.toJson());

    print("Transaction added to Firestore successfully with ID: $transactionID");

      return transaction;
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();

      Logger.log(
        error.toString(),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
