import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dsplus_finance/presentation/attachements/common/firebare_storage_repository.dart';
import 'package:dsplus_finance/presentation/attachements/models/banner.dart'
    as model;
import 'package:image_picker/image_picker.dart';

class BannerController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createBanner({
    required XFile image,
    required String description,
    required double amount,
    required String status,
    required transactionID,
  }) async {
    // final DocumentReference ref;

    final DocumentReference ref2;

    // ref = firestore
    //     .collection('users')
    //     .doc(firebaseAuth.currentUser!.uid)
    //     .collection('transactions')
    //     .doc(transactionID)
    //     .collection('attachments')
    //     .doc();

    ref2 = firestore
        // .collection('users')
        // .doc(firebaseAuth.currentUser!.uid)
        .collection('transactions')
        .doc(transactionID)
        .collection('attachments')
        .doc();

    String imageUrl = await storeFileToFirebase(
      'attachments/${ref2.id}',
      File(image.path),
    );

    model.Banner banner = model.Banner(
      id: ref2.id,
      imageUrl: imageUrl,
      description: description,
      amount: amount,
      status: status,

      // creatorId: firebaseAuth.currentUser!.uid,
      // shopListId: [firebaseAuth.currentUser!.uid],
      // isApproved: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await ref2.set(banner.toMap()).catchError((error) {
      debugPrint(error);
    });

    // await ref2.set(banner.toMap()).catchError((error) {
    //   debugPrint(error);
    // });
  }

////////////////////////////////////////////////////////////////////////////////////////////////
  Stream<List<model.Banner>> fetchBanner({
    required String transactionID,
  }) {
    return firestore
        // .collection('users')
        // .doc(firebaseAuth.currentUser!.uid)
        .collection('transactions')
        .doc(transactionID.isNotEmpty
            ? transactionID
            : null) // If transactionID is empty, null is passed to generate a new ID
        .collection('attachments')
        // .where('creatorId', isEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots()
        .map(
      (event) {
        List<model.Banner> banners = [];
        for (var document in event.docs) {
          banners.add(model.Banner.fromMap(document.data()));
        }
        return banners;
      },
    );
  }

  Future deleteBanner({
    required String transactionID,
    required String attachmentId,
  }) async {
    final DocumentReference ref;
    ref = firestore
        // .collection('users')
        // .doc(firebaseAuth.currentUser!.uid)
        .collection('transactions')
        .doc(transactionID)
        .collection('attachments')
        .doc(attachmentId);

    await deleteFileStorage('attachments/$attachmentId');

    // 'seller/${firebaseAuth.currentUser!.uid}/banner/$attachmentId');

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }
}
