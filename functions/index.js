const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendReportUpdateNotification = functions.firestore
  .document('reports/{reportId}')
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    // Check if isPending or isResolved has changed to true
    if ((newValue.isPending !== previousValue.isPending && newValue.isPending) ||
        (newValue.isResolved !== previousValue.isResolved && newValue.isResolved)) {
      const status = newValue.isPending ? 'Pending' : 'Resolved';
      const payload = {
        notification: {
          title: 'Report Update',
          body: `Your report "${newValue.title}" status has changed to ${status}.`,
        },
        topic: newValue.reporter,
      };

      return admin.messaging().send(payload)
        .then(response => {
          console.log('Successfully sent message:', response);
        })
        .catch(error => {
          console.log('Error sending message:', error);
        });
    } else {
      return null;
    }
  });
