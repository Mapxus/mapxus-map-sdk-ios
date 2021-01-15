# MapxusMapSDK_iOS

## 1. About Mapxus Map

Mapxus Map SDK is a set of call interface for developing indoor map. Developers can easily call Mapxus indoor map services and data in their iOS applications, to expanded the usage scenarios of geographic applications.

### 1.1 Minimum iOS Version

The Mapxus Map SDK for iOS is deployed on iOS 9 and above.

### 1.2 Get an API Key

Please contact us for api Key and secret。



## 2. Project Integration

### 2.1 Automatical Integration Using Cocoapods

1. Open the terminal, navigate to your project root directory, which is as same as project's file(.xcodeproj) . Create Profile using command：

```objectivec
pod init
```

2. Add the following text to Podfile and save：

```objectivec
target 'your project target' do
  use_frameworks!
  pod 'MapxusMapSDK'
end
```

3. Execute the command：

```objectivec
pod install
```

4. After the integration is successful, open the project through the file which the suffix is .xcworkspace.



## 3. Create a Map

### 3.1 Register for Map Service

Register your map service in **AppDelegate**:

```objectivec
import MapxusBaseSDK

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[MXMMapServices sharedServices] registerWithApiKey:@"your apiKey" secret:@"your secret"];

    return YES;

}
```

### 3.2 The Easy Way to Create Your Map

Add your map in ViewController（**Remarks:  delegate of MGLMapView is not allowed to be nil**）：

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
    //initialize MGLMapView
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
