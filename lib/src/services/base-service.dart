import 'package:cloud_firestore/cloud_firestore.dart';

class BaseFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new document to a collection
  Future<DocumentReference<Map<String, dynamic>>> addItem(String collectionName, Map<String, dynamic> data) async {
    return await _db.collection(collectionName).add(data);
  }

  // Update an existing document
  Future<void> updateItem(String collectionName, String docId, Map<String, dynamic> data) async {
    await _db.collection(collectionName).doc(docId).update(data);
  }

  // Delete a document
  Future<void> deleteItem(String collectionName, String docId) async {
    await _db.collection(collectionName).doc(docId).delete();
  }

  // Read a single document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getItem(String collectionName, String docId) async {
    return await _db.collection(collectionName).doc(docId).get();
  }

  // Fetch all documents from a collection
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getItems(String collectionName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db.collection(collectionName).get();
    return snapshot.docs;
  }

  // Get a collection reference
  CollectionReference<Map<String, dynamic>> getCollection(String collectionName) {
    return _db.collection(collectionName);
  }
}
