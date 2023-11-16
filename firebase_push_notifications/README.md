# firebase_push_notifications

1. Go to Firebase console and create an Android App, follow the steps and setup the project.
2. Get debug certificate and add it to firebase app.

~~~
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
~~~

> Password: android

3. Create app.env file

[DOCS](https://firebase.google.com/docs/cloud-messaging/flutter/client)
