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

        const snapshot = await db.doc(`users/${from}`).get();
        const fromName = snapshot.data().userName;

        db.collection(`users/${userId}/notifications`).add({
          "date": date,
          "content": `Gift received from ${fromName},
click here to see more information.`,
          "title": "Gift Received",
        });

        if(tokens.length > 0){

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

      db.collection(`users/${userId}/notifications`).add({
        "date": date,
        "content": `Product ${productName} you added has been sold to ${buyerName},
click here to see more information.`,
        "title": "Product Sold",
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
  const senderName = data.senderName;
  const pointsAmount = data.pointsAmount;
  const date = admin.firestore.FieldValue.serverTimestamp();

  const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
  const tokens = [];
  querySnapshot.forEach((tokenDoc) => {
          tokens.push(tokenDoc.data().token);
      });

  db.collection(`users/${userId}/notifications`).add({
    "date": date,
    "content": `${pointsAmount} points received from ${senderName},`,
    "title": "Points Received",
  });

  if(tokens.length > 0){
    const payload = {
        notification : {
            title: "Points Received",
            body: `${pointsAmount} points received from ${senderName},`,
            sound: "default",
        },
        data: {
            click_action: "Flutter_NOTIFICATION_CLICK"
      	},
      };

      return fcm.sendToDevice(tokens, payload);
  }

}

);

exports.deleteExpiredStories = functions.pubsub.schedule("every 1 hours").onRun(async(context) => {
  const now = admin.firestore.Timestamp.now();
  const ts = admin.firestore.Timestamp.fromMillis(now.toMillis() - 86400000); // 24 hours in milliseconds = 86400000

  const snap = await db.collection("stories").where("createdAt", "<", ts).get().then((querySnapshot)=>{
    querySnapshot.forEach((doc) => {
       doc.ref.delete();
    });
  });
});

exports.onDeleteStory = functions.firestore
    .document("stories/{storyId}")
    .onDelete(async(snapshot, context) => {
      const storyId = context.params.storyId;
      const folderName = `Stories/${storyId}`;
      console.log(`${folderName}`);
      return admin.storage().bucket().deleteFiles({prefix: folderName});
    });

exports.onDeleteUser = functions.firestore
    .document("users/{userId}")
    .onDelete(async(snapshot, context) => {
      const userId = context.params.userId;
      const folderName = `${userId}`;
      return admin.storage().bucket().deleteFiles({prefix: folderName});
    });

exports.onDeletePersonOffer = functions.firestore
    .document("offers/{offerId}")
    .onDelete(async(snapshot, context) => {
      const offerId = context.params.offerId;
      const userId = snapshot.data().offerOwnerId;
      const folderName = `${userId}/offers/${offerId}`;
      console.log(`${folderName}`);
      return admin.storage().bucket().deleteFiles({prefix: folderName});
    });

exports.onDeleteCompanyOffer = functions.firestore
    .document("company offers/{offerId}")
    .onDelete(async(snapshot, context) => {
      const offerId = context.params.offerId;
      const userId = snapshot.data().offerOwnerId;
      const folderName = `${userId}/offers/${offerId}`;
      console.log(`${folderName}`);
      return admin.storage().bucket().deleteFiles({prefix: folderName});
    });

exports.onMessageRecieved = functions.firestore
    .document("chats/{chatId}/Messages/{messageId}")
    .onCreate(async(snapshot, context) => {
      //get message info
      const chatId = context.params.chatId;
      const messageId = context.params.messageId;
      const senderId = snapshot.data().sender;

      const isRead = snapshot.data().isRead;

      console.log(`is read ${isRead}`);

      //get chat users ids
      const chatSnapshot = await db.doc(`chats/${chatId}`).get();
      const firstUserId = chatSnapshot.data().firstUserId;
      const secondUserId = chatSnapshot.data().secondUserId;

      const receiverId = senderId == firstUserId ? secondUserId : firstUserId;

      return db.doc(`users/${receiverId}/unreadMessages/${messageId}`).set({
        'msgId': messageId,
        'chatType': 'chat',
      });
    });

exports.onGroupMessageRecieved = functions.firestore
    .document("group chats/{groupId}/Messages/{messageId}")
    .onCreate(async(snapshot, context) => {
      //get message info
      const groupId = context.params.groupId;
      const messageId = context.params.messageId;
      const senderId = snapshot.data().sender;

      //const isRead = snapshot.data().isRead;

     // console.log(`is read ${isRead}`);

      //get chat users ids
      const chatSnapshot = await db.doc(`group chats/${groupId}`).get();
      const usersId = chatSnapshot.data().usersId;

      const index = usersId.indexOf(senderId);
      usersId.splice(index, 1);

      usersId.forEach((userId) => {
        db.doc(`users/${userId}/unreadMessages/${messageId}`).set({
          'msgId': messageId,
          'chatType': 'group',
        });
      });
      
    });

exports.onOfferLiked = functions.firestore
    .document("offers/{offerId}")
    .onUpdate(async(change, context) => {
      // Retrieve the current and previous value
      const data = change.after.data();
      const previousData = change.before.data();

      // We'll only update if the likes has increased 5 times.
      if (data.likes.length == previousData.likes.length || 
        data.likes.length < previousData.likes.length ||
        data.likes.length % 5 != 0) {
        console.log("no update needed");
        return null;
      }

      const offerOwnerId = data.offerOwnerId;

      return db.doc(`users/${offerOwnerId}`).update({
        'points': admin.firestore.FieldValue.increment(1),
      });

    });


exports.onCompanyOfferLiked = functions.firestore
    .document("company offers/{offerId}")
    .onUpdate(async(change, context) => {
      // Retrieve the current and previous value
      const data = change.after.data();
      const previousData = change.before.data();

      // We'll only update if the likes has increased 5 times.
      if (data.likes.length == previousData.likes.length || 
        data.likes.length < previousData.likes.length ||
        data.likes.length % 5 != 0) {
        console.log("no update needed");
        return null;
      }

      const offerOwnerId = data.offerOwnerId;

      return db.doc(`users/${offerOwnerId}`).update({
        'points': admin.firestore.FieldValue.increment(1),
      });

    });


exports.updatePackage = functions.pubsub.schedule("every 1 hours").onRun(async(context) => {
  const now = admin.firestore.Timestamp.now();
  const ts = admin.firestore.Timestamp.fromMillis(now.toMillis() - 86400000); // 24 hours in milliseconds = 86400000

  const querySnapshot = await db.collection("subscriptions").where("lastUpdated", "<", ts).get();
  querySnapshot.forEach((doc) => {
    //check if it's a free package
    if(doc.data().packageName == 'Free Package'){
      const uId = doc.id;
      const chatDays = doc.data().chatInDays;
      if(chatDays > 0){
      return db.doc(`subscriptions/${uId}`).update({
        'chatInDays': admin.firestore.FieldValue.increment(-1),
        'lastUpdated': admin.firestore.Timestamp.now(),
      });
    }
  }

    //else it's a paid package
    else{
      const uId = doc.id;
      const expires = doc.data().expires > 0 ? doc.data().expires - 1 : doc.data().expires;
      const chatInDays = doc.data().chatInDays > 0 ? doc.data().chatInDays - 1 : doc.data().chatInDays;
      const storyInDays = doc.data().storyInDays > 0 ? doc.data().storyInDays - 1 : doc.data().storyInDays;

      if(expires == 0){
        return db.doc(`subscriptions/${uId}`).update({
          'expires': 0,
          'chatInDays': 0,
          'storyInDays': 0,
          'storyCount': 0,
          'products': 0,
          'posts': 0,
          'images': 0,
          'videos': 0,
          'lastUpdated': admin.firestore.Timestamp.now(),
        });
      }else {
        return db.doc(`subscriptions/${uId}`).update({
          'expires': expires,
          'chatInDays': chatInDays,
          'storyInDays': storyInDays,
          'lastUpdated': admin.firestore.Timestamp.now(),
        });
      }
    }
  });
});

exports.onPackageNearlyEnds = functions.firestore
    .document("subscriptions/{userId}")
    .onUpdate(async(change, context) => {
      const userId = context.params.userId;

      const data = change.after.data();

      if(data.expires > 5){

        return null;
      }

      //get user device token
      const querySnapshot = await db.collection(`users/${userId}/device tokens`).get();
      const tokens = [];
      querySnapshot.forEach((tokenDoc) => {
        tokens.push(tokenDoc.data().token);
      });

      if(data.expires == 0){
        const date = admin.firestore.FieldValue.serverTimestamp();
        db.collection(`users/${userId}/notifications`).add({
          "date": date,
          "content": `Your subscription is expired, renew it to reopen all features.`,
          "title": "Package Expired",
        });

        if(tokens.length > 0){
          const payload = {
            notification : {
              title: "Package Expired",
              body: `Your subscription is expired, renew it to reopen all features.`,
              sound: "default",
            },
            data: {
              click_action: "Flutter_NOTIFICATION_CLICK"
            },
          };
          return fcm.sendToDevice(tokens, payload);
        }
      }else{
        const date = admin.firestore.FieldValue.serverTimestamp();
        db.collection(`users/${userId}/notifications`).add({
          "date": date,
          "content": `Your subscription will end in ${data.expires} days.`,
          "title": "Package Nearly Ends",
        });

        if(tokens.length > 0){
          const payload = {
            notification : {
              title: "Package Nearly Ends",
              body: `Your subscription will end in ${data.expires} days.`,
              sound: "default",
            },
            data: {
              click_action: "Flutter_NOTIFICATION_CLICK"
            },
          };
          return fcm.sendToDevice(tokens, payload);
        }
      }
    });



exports.whenChatCreated = functions.firestore
    .document("chats/{chatId}")
    .onCreate(async(snapshot, context) => {

      const chatId = context.params.chatId;
      const firstUserId = snapshot.data().firstUserId;
      const secondUserId = snapshot.data().secondUserId;

      await db.doc(`users/${firstUserId}/user chats/${chatId}`).set({
        "roomId": chatId,
      });

      return db.doc(`users/${secondUserId}/user chats/${chatId}`).set({
        "roomId": chatId,
      });
    });


exports.whenGroupChatCreated = functions.firestore
    .document("group chats/{groupChatId}")
    .onCreate(async(snapshot, context) => {

      const groupChatId = context.params.groupChatId;
      const usersId = snapshot.data().usersId;

      return usersId.forEach((userId) => {
        db.doc(`users/${userId}/user group chats/${groupChatId}`).set({
        "groupId": groupChatId,
      });

    });
    });