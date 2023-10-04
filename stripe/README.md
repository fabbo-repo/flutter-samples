# payment

[Test account](https://dashboard.stripe.com/test/apikeys)

### Android setup:

* In android/app/build.gradle

~~~
...
defaultConfig {
    ...
    minSdkVersion 21
    ...
}
...
~~~

* In android/app/src/main/res/values/styles.xml and android/app/src/main/res/values-night/styles.xml

~~~
...
<resources>
    <!-- Theme applied to the Android Window while ... -->
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    ...
    <style name="NormalTheme" parent="Theme.MaterialComponents">
...
~~~

* In android/app/src/main/kotlin/com/example/payment/MainActivity.kt

~~~
...
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
}
~~~

### Ios setup:

Using XCode in Runner folder, set Deployment info to IOS 12.0

### Testing Credit Cards

https://stripe.com/docs/testing