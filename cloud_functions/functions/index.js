const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

exports.sendGifts = functions.https.onCall((data, context) => {
	const productNames = data.productNames;
	const from = data.from;
	const to = data.to;
	const giftId = data.id;
	const date = admin.firestore.FieldValue.serverTimestamp();

	db.doc(`users/${from}/gifts/${giftId}`).set({
    "productNames": productNames,
    "date": date,
    "from": from,
    "to": to,
    });

	db.doc(`users/${to}/gifts/${giftId}`).set({
    "productNames": productNames,
    "date": date,
    "from": from,
    "to": to,
    });
});

exports.sendGiftNotification = functions.firestore
    .document("users/{userId}/gifts/{giftId}")
    .onCreate(async(snapshot, context) => {
      const date = admin.firestore.FieldValue.serverTimestamp();
      const userId = context.params.userId;
      const productNames = snapshot.data().productNames;
      const from = snapshot.data().from;
      const to = snapshot.data().to;

      // send notification only to the gift receiver
      if(userId == to){
        const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
        const tokens = [];
        querySnapshot.forEach((tokenDoc) => {
          console.log(`${tokenDoc.data().token}`);
          tokens.push(tokenDoc.data().token);
      });

        if(tokens.length > 0){
            const snapshot = await db.doc(`users/${from}`).get();
            const fromName = snapshot.data().userName;

            const payload = {
                notification : {
                	title: "Gift Received",
                	body: `Gift received from ${fromName},
click here to see more information.`,
                    sound: "default",
                },
                data: {
                	click_action: "Flutter_NOTIFICATION_CLICK"
                },
            };

            db.collection(`users/${userId}/notifications`).add({
            	"date": date,
            	"content": `Gift received from ${fromName},
click here to see more information.`,
                "title": "Gift Received",
            });

            return fcm.sendToDevice(tokens, payload);

        }

     
    }

    });

exports.sendSellNotification = functions.firestore
    .document("users/{userId}/bills/{billId}")
    .onCreate(async(snapshot, context) => {
      const date = admin.firestore.FieldValue.serverTimestamp();
      const userId = context.params.userId;
      const productName = snapshot.data().productName;
      const buyerName = snapshot.data().buyerName;
      const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
      const tokens = [];
      querySnapshot.forEach((tokenDoc) => {
        console.log(`${tokenDoc.data().token}`);
        tokens.push(tokenDoc.data().token);
      });

      if(tokens.length > 0){
      	console.log(`not empty tokens ${tokens.length}`);
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

  }

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

exports.sendPointsNotification = functions.https.onCall(async(data, context) => {
  // get data from the mobile app
  const userId = data.userId;
  const userName = data.userName;
  const pointsAmount = data.pointsAmount;
  const date = admin.firestore.FieldValue.serverTimestamp();
  const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
  const tokens = [];
  querySnapshot.forEach((tokenDoc) => {
          tokens.push(tokenDoc.data().token);
      });

  if(tokens.length > 0){
    const payload = {
        notification : {
            title: "Points Received",
            body: `${pointsAmount} points received from ${userName},`,
            sound: "default",
        },
        data: {
            click_action: "Flutter_NOTIFICATION_CLICK"
      	},
      };

      db.collection(`users/${userId}/notifications`).add({
        "date": date,
        "content": `${pointsAmount} points received from ${userName},`,
        "title": "Points Received",
  });

      return fcm.sendToDevice(tokens, payload);
  }

}










);

exports.deleteOldItems = functions.firestore
    .document('stories')
    .onWrite(async (change, context) => {
        const querySnapshot = await db.collection('stories').where('createdAt', '>', Date.now()).get();
        const promises = [];
        querySnapshot.forEach((doc) => {
            promises.push(doc.ref.delete());
        });
        return Promise.all(promises);
    });
