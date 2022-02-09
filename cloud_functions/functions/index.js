const functions = require("firebase-functions");
const admin = require("firebase-admin");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

exports.sendSellNotification = functions.firestore
    .document("users/{userId}/bills/{billId}")
    .onCreate(async(snapshot, context) => {
      const date = admin.firestore.FieldValue.serverTimestamp();
      const userId = context.params.userId;
      const productName = snapshot.data().productName;
      const buyerName = snapshot.data().buyerName;
      console.log(`${productName} and ${buyerName} and usre is ${userId}`);
      const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
      const tokens = [];
      querySnapshot.forEach((tokenDoc) => {
        console.log(`${tokenDoc.data().token}`);
        tokens.push(tokenDoc.data().token);
      });


      const payload = {
      	notification : {
      		title: "Product Sold",
      		body: `A product you added ${productName} has been sold to ${buyerName},
click to see more info, and start the shipping proccess`,
      		sound: "default",
      	},
      	data: {
           click_action: "Flutter_NOTIFICATION_CLICK"
      	},
      };

      db.collection(`users/${userId}/notifications`).add({
        "date": date,
        "content": `Product ${productName} you added has been sold to ${buyerName},
click here to see more information.`,
        "title": "Product Sold",
  });


      return fcm.sendToDevice(tokens, payload);
    });

exports.sendBills = functions.https.onCall((data, context) => {
  // get data from the mobile app
  const sellerId = data.sellerId;
  const isRequested = data.isRequested;
  const billId = data.billId;
  const date = admin.firestore.FieldValue.serverTimestamp();
  const amount = data.amount;
  const productName = data.productName;
  const productPrice = data.productPrice;
  const productColor = data.productColor;
  const productSize = data.productSize;
  const vat = data.vat;
  const shippingCost = data.shippingCost;
  const shipTo = data.shipTo;
  const buyerName = data.buyerName;
  const buyerEmail = data.buyerEmail;
  const buyerPhoneNumber = data.buyerPhoneNumber;
  const buyerCountry = data.buyerCountry;
  const buyerCity = data.buyerCity;
  const buyerLongitude = data.buyerLongitude;
  const buyerLatitude = data.buyerLatitude;

  db.doc(`users/${sellerId}/bills/${billId}`).set({
    "buyerPhoneNumber": buyerPhoneNumber,
    "date": date,
    "isRequested": isRequested,
    "productSize": productSize,
    "amount": amount,
    "productPrice": productPrice,
    "productColor": productColor,
    "buyerName": buyerName,
    "productName": productName,
    "buyerEmail": buyerEmail,
    "buyerLatitude": buyerLatitude,
    "buyerLongitude": buyerLongitude,
    "vat": vat,
    "shipTo": shipTo,
    "buyerCity": buyerCity,
    "buyerCountry": buyerCountry,
    "shippingCost": shippingCost,
  });

  db.doc(`users/${sellerId}`).update({
    "points": admin.firestore.FieldValue.increment(250),
  });

  return [date];
});
