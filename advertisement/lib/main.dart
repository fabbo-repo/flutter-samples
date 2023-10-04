import 'package:advertisement/config/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdHelper.isSupportedPlatform) {
    await MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // BANNER AD
  BannerAd? _bannerAd;
  // INTERSTITIAL AD
  InterstitialAd? _interstitialAd;
  // REWARDED AD
  RewardedAd? _rewardedAd;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter % 3 == 0) {
        onThreePoints(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // BANNER AD
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _showRewardedAd,
            tooltip: 'Ad',
            child: const Icon(Icons.ad_units),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (AdHelper.isSupportedPlatform) {
      _loadBannerAd();
      _loadInterstitialAd();
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    if (AdHelper.isSupportedPlatform) {
      _bannerAd?.dispose();
      _interstitialAd?.dispose();
      _rewardedAd?.dispose();
    }
    super.dispose();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pop(context);
            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          Future.delayed(Duration(seconds: 5), () {
            _loadInterstitialAd();
          });
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void onThreePoints(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ad'),
          content: Text('An ad will be openned each 3 points'),
          actions: [
            ElevatedButton(
              child: Text('close'.toUpperCase()),
              onPressed: () {
                if (_interstitialAd != null) {
                  _interstitialAd?.show();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
          Future.delayed(Duration(seconds: 5), () {
            _loadRewardedAd();
          });
        },
      ),
    );
  }

  void _showRewardedAd() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Need a hint?'),
            content: Text('Watch an Ad to get a hint!'),
            actions: [
              TextButton(
                child: Text('cancel'.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('ok'.toUpperCase()),
                onPressed: () async {
                  Navigator.pop(context);
                  await _rewardedAd?.show(
                    onUserEarnedReward: (_, reward) {
                      debugPrint("REWARDED");
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
