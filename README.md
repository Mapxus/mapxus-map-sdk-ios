# MapxusMapSDK_iOS

## 1. About Mapxus Map

Mapxus Map SDK is a set of call interface for developing indoor map. Developers can easily install map features in their own IOS application, including displaying map, changing map style, map interaction, drawing on the map, searching building, searching POI, route planning, etc.

### 1.1 Minimum IOS Version

The Mapxus Maps SDK for iOS is deployed on iOS 9 and above.

### 1.2 Get an API key

Please contact us for api Key and secret。



## 2. Install Mapxus Map SDK

First of all, please create a project for your APP. Then, integrate your SDK through the following steps.

#### 2.1 Automatical Integration

You can integrate through cocoapods. Add the following code in your Podfile:

```objectivec
target 'MapxusMapSample' do
  use_frameworks!
  pod 'MapxusMapSDK', '~> 2.4.0'
end
```

#### 2.2 Manual Integration

#### 2.2.1 Add MapxusMapSDK and its Dependencies

**Copy** or **drag** **MapxusMapSDK.framework**, **AFNetworking.framework**, **YYModel.framework**, and **Mapbox.framework** file into project folder and add them in **General**->**Embedded Binaries** as shown in the picture. In addition, Mapbox.framework can be downloaded [here](https://www.mapbox.com/install/ios/).

AFNetworking.framework, YYModel.framework can also be managed by cocoapods or Carthage, but you have to generate **dynamic dependencies**. 

![image](https://dpw.maphive.cloud/images/digitalMap/ios/2.0.0/20180525164611.png)

#### 2.2.2 Configure Your Porject

1. Open **info.plist** file, and add **MGLMapboxMetricsEnabledSettingShownInApp**. Set Type as Boolean, and value YES。
2. If you need to position, add **Privacy - Location Always Usage Description** or **Privacy - Location When In Use Usage Description** as value so as to acctivate position function.
3. You can remove the simulator of AFNetworking.framework and YYModel.framework by copy-frameworks of Carthage. Configure Run Script as  the following picture:![image](https://dpw.maphive.cloud/images/digitalMap/ios/2.0.0/20180702062028.png)

or remove it by writing Shell Script yourself.

#### 2.3 Create Your First Map

Register your map in **AppDelegate**:

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[MXMMapServices sharedServices] registerWithApiKey:@"your apiKey" secret:@"your secret"];

    return YES;

}
```

Add your map in ViewController（**Remarks:  `delegate` of `MGLMapView` is  not allowed to be `nul` **）：

```objectivec
#import "SimpleMapViewController.h"
@import Mapbox;
@import MapxusMapSDK;

@interface SimpleMapViewController () <MGLMapViewDelegate>

@property (nonatomic, strong) MGLMapView *mapView;
@property (nonatomic, strong) MapxusMap *map;

@end

@implementation SimpleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nameStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    self.map = [[MapxusMap alloc] initWithMapView:self.mapView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}


- (MGLMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MGLMapView alloc] init];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.304716516178253, 114.16186609400843);
        _mapView.zoomLevel = 16;
        _mapView.delegate = self;
    }
    return _mapView;
}

@end
```