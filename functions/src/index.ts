import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const env = functions.config();

import algoliasearch from "algoliasearch";

const client = algoliasearch(env.algolia.appid, env.algolia.apikey);
const itemIndex = client.initIndex("item_search");
const index = client.initIndex("collection_search");

exports.indexItem = functions.firestore
    .document("Items/{itemId}")
    .onCreate((snap, context) =>{
      const data = snap.data();
      const objectID = snap.id;
      return itemIndex.saveObject({
        objectID,
        ...data,
      });
    });

exports.unindexItem = functions.firestore
    .document("Items/{itemId}")
    .onDelete((snap, context) => {
      const objectId = snap.id;
      return itemIndex.deleteObject(objectId);
    });

exports.updateItem = functions.firestore
    .document("Items/{itemId}")
    .onUpdate((change, context) => {
      const item = change.after.data();
      item.objectID = change.after.id;
      return itemIndex.saveObject(item);
    });

exports.indexCollection = functions.firestore
    .document("Collections/{collectionId}")
    .onCreate((snap, context) =>{
      const data = snap.data();
      const objectID = snap.id;
      return index.saveObject({
        objectID,
        ...data,
      });
    });

exports.unindexCollection = functions.firestore
    .document("Collections/{collectionId}")
    .onDelete((snap, context) => {
      const objectId = snap.id;
      return index.deleteObject(objectId);
    });

exports.updateCollection = functions.firestore
    .document("Collections/{collectionId}")
    .onUpdate((change, context) => {
      const collection = change.after.data();
      collection.objectID = change.after.id;
      return index.saveObject(collection);
    });
