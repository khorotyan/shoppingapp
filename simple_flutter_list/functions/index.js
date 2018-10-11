const functions = require('firebase-functions');
const cors = require('cors')({ origin: true });
const Busboy = require('busboy');
const os = require('os');
const path = require('path');
const fs = require('fs');
const firebaseAdmin = require('firebase-admin');
const uuid = require('uuid/v4');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const gcconfig = {
    projectId: 'flutter-shopping-ce8bc',
    keyFileName: 'flutter-shopping.json'
};

const gcs = require('@google-cloud/storage')(gcconfig);

firebaseAdmin.initializeApp({ credential: firebaseAdmin.credential.cert(require('./flutter-shopping.json')) });

exports.storeImage = functions.https.onRequest((req, res) => {
    return cors(req, res, () => {
        if (req.method !== 'POST') {
            return res.status(500).json({ message: 'Not allowed' });
        }

        if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
            return res.status(401).json({ error: 'Unauthorized' });
        }

        let idToken = req.headers.authorization.split('Bearer ')[1];
        let uploadData;
        let oldImagePath;

        const busboy = new Busboy({ headers: req.headers });

        busboy.on('file', (fieldName, file, fileName, encoding, mimeType) => {
            const filePath = path.join(os.tmpdir(), fileName);
            uploadData = { filePath: filePath, type: mimeType, name: fileName };
            file.pipe(fs.createWriteStream(filePath));
        });

        busboy.on('field', (fieldName, value) => {
            oldImagePath = decodeURIComponent(value);
        });

        busboy.on('finish', () => {
            const bucket = gcs.bucket('flutter-shopping-ce8bc.appspot.com');
            const id = uuid();
            let imagePath = 'images/' + id + '-' + uploadData.name;

            if (oldImagePath) {
                imagePath = oldImagePath;
            }

            return firebaseAdmin
                .auth()
                .verifyIdToken(idToken)
                .then(decodedToken => {
                    return bucket.upload(uploadData.filePath, {
                        uploadType: 'media',
                        destination: imagePath,
                        metadata: {
                            metadata: {
                                contentType: uploadData.type,
                                firebaseStorageDownloadTokens: id
                            }
                        }
                    });
                })
                .then(() => {
                    return res.status(201).json({
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/' +
                            bucket.name +
                            '/o/' +
                            encodeURIComponent(imagePath) +
                            '?alt=media&token=' +
                            id,
                        imagePath: imagePath
                    });
                })
                .catch(error => {
                    return res.status(500).json({ error: 'Unauthorized' });
                });
        });

        return busboy.end(req.rawBody);
    });
});

exports.deleteImage = functions.database.ref('/products/{productId}').onDelete(snapshot => {
    const imageData = snapshot.val();
    const imagePath = imageData.imagePath;

    const bucket = gcs.bucket('flutter-shopping-ce8bc.appspot.com');

    return bucket.file(imagePath).delete();
});
