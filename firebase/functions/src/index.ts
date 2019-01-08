import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

admin.initializeApp(functions.config().firebase);

exports.onLikeCat = functions.firestore
    .document('/likes/{likeId}')
    .onCreate((snapshot, context) => {
        let catId, userId;
        [catId, userId] = context.params.likeId.split(':');

        const db = admin.firestore();
        const catRef = db.collection('cats').doc(catId);
        db.runTransaction(t => {
            return t.get(catRef)
                .then(doc => {
                    t.update(catRef, {
                        like_counter: (doc.data().like_counter || 0) + 1
                    });
                })
        }).then(result => {
            console.log('Increased aggregate cat like counter.');
        }).catch(err => {
            console.log('Failed to increase aggregate cat like counter.', err);
        });
    });

exports.onUnlikeCat = functions.firestore
    .document('/likes/{likeId}')
    .onDelete((snapshot, context) => {
        let catId, userId;
        [catId, userId] = context.params.likeId.split(':');

        const db = admin.firestore();
        const catRef = db.collection('cats').doc(catId);
        return db.runTransaction(t => {
            return t.get(catRef)
                .then(doc => {
                    t.update(catRef, {
                        like_counter: (doc.data().like_counter || 0) - 1
                    });
                })
        }).then(result => {
            console.log('Decreased aggregate cat like counter.');
        }).catch(err => {
            console.log('Failed to decrease aggregate cat like counter.', err);
        });
    });
