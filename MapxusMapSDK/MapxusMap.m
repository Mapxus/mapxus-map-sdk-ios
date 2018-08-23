//
//  MapxusMap.m
//  MapxusMapSDK
//
//  Created by Chenghao Guo on 2018/7/16.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import <YYModel/YYModel.h>
#import "MXMConstants.h"
#import "MapxusMap+Private.h"
#import "MXMMapServices+Private.h"
#import "MGLMapView+MXMSwizzle.h"
#import "MXMPointAnnotation+Private.h"



@implementation MapxusMap


#pragma mark - access

- (UIButton *)buildingSelectBtn
{
    if (!_buildingSelectBtn) {
        _buildingSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buildingSelectBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSBundle *bundle = [NSBundle bundleForClass:[MapxusMap class]];
        UIImage *image = [UIImage imageNamed:@"selectBuilding" inBundle:bundle compatibleWithTraitCollection:nil];
        [_buildingSelectBtn setImage:image forState:UIControlStateNormal];
        [_buildingSelectBtn addTarget:self action:@selector(selectBuildingOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buildingSelectBtn;
}

- (MXMFloorSelectorBar *)floorBar
{
    if (!_floorBar) {
        _floorBar = [[MXMFloorSelectorBar alloc] init];
        _floorBar.translatesAutoresizingMaskIntoConstraints = NO;
        _floorBar.delegate = self;
    }
    return _floorBar;
}

- (UIImageView *)MXMLogo
{
    if (!_MXMLogo) {
        NSBundle *bundle = [NSBundle bundleForClass:[MapxusMap class]];
        UIImage *image = [UIImage imageNamed:@"mapxusLogo" inBundle:bundle compatibleWithTraitCollection:nil];
        _MXMLogo = [[UIImageView alloc] initWithImage:image];
        _MXMLogo.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _MXMLogo;
}

- (UIButton *)openStreetSourceBtn
{
    if (!_openStreetSourceBtn) {
        _openStreetSourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openStreetSourceBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _openStreetSourceBtn.backgroundColor = [UIColor clearColor];
        _openStreetSourceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_openStreetSourceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_openStreetSourceBtn setTitle:@"© OpenStreetMap contributors" forState:UIControlStateNormal];
        [_openStreetSourceBtn addTarget:self action:@selector(showOpenStreeSourceWeb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openStreetSourceBtn;
}

- (void)showOpenStreeSourceWeb
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.openstreetmap.org/copyright"]];
}

- (NSMutableDictionary *)buildingSelectFloorDic
{
    if (!_buildingSelectFloorDic) {
        _buildingSelectFloorDic = [NSMutableDictionary dictionary];
    }
    return _buildingSelectFloorDic;
}

- (NSMutableArray<NSString *> *)historicalBuildingIds
{
    if (!_historicalBuildingIds) {
        _historicalBuildingIds = [NSMutableArray arrayWithCapacity:100];
    }
    return _historicalBuildingIds;
}

- (NSMutableArray *)mxmPointAnnotations
{
    if (!_mxmPointAnnotations) {
        _mxmPointAnnotations = [NSMutableArray array];
    }
    return _mxmPointAnnotations;
}

#pragma mark end




- (instancetype)initWithMapView:(MGLMapView *)mapView
{
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.mapView.mxmMap = self;
        [self commonInit];
    }
    return self;
}

- (NSLayoutConstraint *)constraintWithIndientifer:(NSString *)identifer InView:(UIView *)view {
    NSLayoutConstraint * constraintToFind = nil;
    for (NSLayoutConstraint * constraint in view.constraints ) {
        if([constraint.identifier isEqualToString:identifer]) {
            constraintToFind = constraint;
            break;
        }
    }
    return constraintToFind;
}

- (void)setSelectorPosition:(MXMSelectorPosition)selectorPosition
{
    _selectorPosition = selectorPosition;

    NSLayoutConstraint *floorBarXLc = [self constraintWithIndientifer:@"floorBarXLc" InView:self.mapView];
    if (floorBarXLc) [self.mapView removeConstraint:floorBarXLc];
    NSLayoutConstraint *floorBarYLc = [self constraintWithIndientifer:@"floorBarYLc" InView:self.mapView];
    if (floorBarYLc) [self.mapView removeConstraint:floorBarYLc];
    NSLayoutConstraint *buildingBtnXLc = [self constraintWithIndientifer:@"buildingBtnXLc" InView:self.mapView];
    if (buildingBtnXLc) [self.mapView removeConstraint:buildingBtnXLc];

    switch (selectorPosition) {
        case MXMSelectorPositionCenterLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionCenterRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionUpperLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionUpperRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1.0f constant:100];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionLowerLeft:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-50];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;
        case MXMSelectorPositionLowerRight:
        {
            floorBarXLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
            floorBarXLc.identifier = @"floorBarXLc";
            [self.mapView addConstraint:floorBarXLc];
            
            floorBarYLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-50];
            floorBarYLc.identifier = @"floorBarYLc";
            [self.mapView addConstraint:floorBarYLc];
            
            buildingBtnXLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-6];
            buildingBtnXLc.identifier = @"buildingBtnXLc";
            [self.mapView addConstraint:buildingBtnXLc];
        }
            break;

        default:
            break;
    }
    [self.mapView layoutIfNeeded];
}

- (void)commonInit
{
    self.indoorControllerAlwaysHidden = NO;
    self.mapView.attributionButton.hidden = YES;
    self.mapView.logoView.hidden = YES;
    
    
    [self.mapView addSubview:self.openStreetSourceBtn];
    NSLayoutConstraint *openStreetRightLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:openStreetRightLc];
    NSLayoutConstraint *openStreetBottomLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:openStreetBottomLc];
    NSLayoutConstraint *openStreetWLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:190.0f];
    [self.openStreetSourceBtn addConstraint:openStreetWLc];
    NSLayoutConstraint *openStreetHLc = [NSLayoutConstraint constraintWithItem:self.openStreetSourceBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:13.0f];
    [self.openStreetSourceBtn addConstraint:openStreetHLc];
    
    
    [self.mapView addSubview:self.MXMLogo];
    NSLayoutConstraint *logoLeftLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    [self.mapView addConstraint:logoLeftLc];
    NSLayoutConstraint *logoBottomLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-10.0f];
    [self.mapView addConstraint:logoBottomLc];
    NSLayoutConstraint *logoWLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:78.0f];
    [self.MXMLogo addConstraint:logoWLc];
    NSLayoutConstraint *logoHLc = [NSLayoutConstraint constraintWithItem:self.MXMLogo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:14.0f];
    [self.MXMLogo addConstraint:logoHLc];
    
    
    // 添加楼层选择栏与约束
    [self.mapView addSubview:self.floorBar];
    NSLayoutConstraint *floorBarLeftLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    floorBarLeftLc.identifier = @"floorBarXLc";
    [self.mapView addConstraint:floorBarLeftLc];
    NSLayoutConstraint *floorBarBottomLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30];
    floorBarBottomLc.identifier = @"floorBarYLc";
    [self.mapView addConstraint:floorBarBottomLc];
    NSLayoutConstraint *floorBarWLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:42];
    [self.floorBar addConstraint:floorBarWLc];
    NSLayoutConstraint *floorBarHLc = [NSLayoutConstraint constraintWithItem:self.floorBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:200.0f];
    [self.floorBar addConstraint:floorBarHLc];

    
    // 添加建筑选择按钮与约束
    [self.mapView addSubview:self.buildingSelectBtn];
    NSLayoutConstraint *buiSelLeftLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:6];
    buiSelLeftLc.identifier = @"buildingBtnXLc";
    [self.mapView addConstraint:buiSelLeftLc];
    NSLayoutConstraint *buiSelBottomLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.floorBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:-4];
    [self.mapView addConstraint:buiSelBottomLc];
    NSLayoutConstraint *buiSelWLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectBtn addConstraint:buiSelWLc];
    NSLayoutConstraint *buiSelHLc = [NSLayoutConstraint constraintWithItem:self.buildingSelectBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:kNilOptions multiplier:1.0f constant:50.0f];
    [self.buildingSelectBtn addConstraint:buiSelHLc];
    
    
    // 设默认样式
    [self setMapSytle:MXMStyleCOMMON];
    // 添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToDo:)];
    tap.delegate = self;
    [self.mapView addGestureRecognizer:tap];
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.8;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
    // 长按失败才检测单击事件
    [tap requireGestureRecognizerToFail:longPress];
}


- (void)setMapSytle:(MXMStyle)style
{
    [[MXMMapServices sharedServices] getTokenComplete:^(NSString *token) {
        switch (style) {
            case MXMStyleCOMMON:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/vector_tiles/topic/common_v2/style?token=%@", MXMHOSTURL, token]];
                break;
            case MXMStyleCHRISTMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/vector_tiles/topic/christmas_v2/style?token=%@", MXMHOSTURL, token]];
                break;
            case MXMStyleHALLOWMAS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/vector_tiles/topic/halloween_v2/style?token=%@", MXMHOSTURL, token]];
                break;
            case MXMStyleMAPPYBEE:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/vector_tiles/topic/mappy_bee_v2/style?token=%@", MXMHOSTURL, token]];
                break;
            case MXMStyleMAPXUS:
                self.mapView.styleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/vector_tiles/topic/mapxus_v2/style?token=%@", MXMHOSTURL, token]];
                break;
            default:
                break;
        }
//        NSLog(@"%@", self.mapView.styleURL.absoluteString);
    }];
}


#pragma mark - 手势响应

// 单击手势响应
- (void)singleTapToDo:(id)sender
{
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didSingleTappedAtCoordinate:)]) {
        [self.delegate mapView:self didSingleTappedAtCoordinate:coor];
    }
    [self findOutPOIAtPoint:point];
    // 切换建筑
    NSArray *pointBuildingList = [self findOutBuildingAtPoint:point];
    MXMGeoBuilding *building = pointBuildingList.firstObject;
    [self selectBuilding:building.identifier];
}

// 点击查找POI信息
- (void)findOutPOIAtPoint:(CGPoint)point
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『m』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive"] && [theLayer isKindOfClass:[MGLSymbolStyleLayer class]]){
            [identifiersSet addObject:identifier];
        }
    }
    // 获取中心矩形内的建筑信息
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiersSet predicate:nil];
    id<MGLFeature> fristM = theFeatures.firstObject;
    MXMGeoPOI *poi = [MXMGeoPOI yy_modelWithJSON:fristM.attributes];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didTappedOnPOI:)]) {
        [self.delegate mapView:self didTappedOnPOI:poi];
    }
}

// 长按手势响应
- (void)longPressAction:(id)sender
{
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coor = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didLongPressedAtCoordinate:)]) {
        [self.delegate mapView:self didLongPressedAtCoordinate:coor];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark end




#pragma mark - 中心点室内数据筛选

- (void)automaticAnalyseOfIndoorData
{
    // 查找当前中心view坐标的Building队列
    self.buildings = [self findOutBuildingIntheRect];
    // 设置建筑选择按钮和楼层选择按钮是否显示
    self.buildingSelectBtn.hidden = self.indoorControllerAlwaysHidden || !((self.buildings.count>=2)&&(self.mapView.zoomLevel>15));
    self.floorBar.hidden = self.indoorControllerAlwaysHidden || !((self.buildings.count>=1)&&(self.mapView.zoomLevel>15));
    self.isIndoor = !self.floorBar.isHidden;
    // 默认选中building，规则为优先选中之前选过的
    MXMGeoBuilding *defaultBuilding = [self electDefaultBuildingRecently];
    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:defaultBuilding.identifier];
    [self selectBuilding:defaultBuilding.identifier floor:defaultFloor shouldChangeUserTrackingMode:NO];
}

- (NSDictionary *)findOutBuildingIntheRect
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『mBuilding』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive-building-fill"]) {
            [identifiersSet addObject:identifier];
        }
    }
    // 获取中心矩形内的建筑信息
    CGSize mapSize = self.mapView.bounds.size;
    CGRect rect = CGRectMake(mapSize.width/4, mapSize.height/4, mapSize.width/2, mapSize.height/2);
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:identifiersSet predicate:nil];
    // 建筑信息去重
    NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in theFeatures) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            [resultBuildings setObject:[MXMGeoBuilding yy_modelWithJSON:feature.attributes] forKey:theId];
        }
    }
    return [NSDictionary dictionaryWithDictionary:resultBuildings];
}


// 地图跟踪时使用
- (NSArray<MXMGeoBuilding *> *)findOutBuildingAtPoint:(CGPoint)point
{
    // 生成layer.identifier的存储集合
    NSMutableSet *identifiersSet = [NSMutableSet set];
    // 获取已加载style中的layers
    NSArray<MGLStyleLayer *> *theLayers = self.mapView.style.layers;
    // 筛选出『mBuilding』开头的layer
    for (MGLStyleLayer *theLayer in theLayers) {
        NSString *identifier = theLayer.identifier;
        if ([identifier hasPrefix:@"maphive-building-fill"]) {
            [identifiersSet addObject:identifier];
        }
    }
    // 获取中心点的建筑信息
    NSArray<id <MGLFeature>> *theFeatures = [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:identifiersSet];
    // 建筑信息去重
    NSMutableDictionary *resultBuildings = [NSMutableDictionary dictionary];
    for (id <MGLFeature> feature in theFeatures) {
        NSString *theId = [feature attributeForKey:@"id"];
        if (theId) {
            [resultBuildings setObject:[MXMGeoBuilding yy_modelWithJSON:feature.attributes] forKey:theId];
        }
    }
    return [resultBuildings allValues];
}
#pragma mark end

#pragma mark - 控件筛选建筑

- (void)selectBuildingOnClick:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.buildings.count];
    for (MXMGeoBuilding *b in [self.buildings allValues]) {
        [arr addObject:[KxMenuItem menuItem:b.name
                                 identifier:b.identifier
                                      image:nil
                                     target:self
                                     action:@selector(chooseItem:)]];
    }
    [KxMenu setDefaultItemIdentifier:self.building.identifier];
    [KxMenu showMenuInView:self.mapView fromRect:sender.frame menuItems:arr];
}

- (void)chooseItem:(KxMenuItem *)sender
{
    MXMGeoBuilding *b = [self.buildings objectForKey:sender.identifier];
    [self selectBuilding:b.identifier];
}

- (void)floorSelectorBarDidSelectFloor:(NSString *)floorName
{
    [self selectFloor:floorName];
}
#pragma mark end


#pragma mark - 建筑筛选
// 选举默认选中楼层，参考历史选中
- (nullable NSString *)electDefaultFloorWithBuildingId:(nullable NSString *)buildingId
{
    if (buildingId == nil) {
        return nil;
    }
    NSString *defaultElectFloor = self.buildingSelectFloorDic[buildingId];
    if (defaultElectFloor == nil) {
        MXMGeoBuilding *b = [self.buildings objectForKey:buildingId];
        defaultElectFloor = b.ground_floor;
    }
    return defaultElectFloor;
}

// 选举默认选中建筑，参考历史选中
- (nullable MXMGeoBuilding *)electDefaultBuildingRecently
{
    NSArray *values = [self.buildings allValues];
    // 取出默认第一个
    MXMGeoBuilding *result = values.firstObject;
    // 与历史ID匹对
    for (NSString *buildingId in self.historicalBuildingIds) {
        for (MXMGeoBuilding *building in values) {
            if ([building.identifier isEqualToString:buildingId]) {
                result = building;
                return result;
            }
        }
    }
    return result;
}

- (void)selectBuilding:(NSString *)buildingId
{
    NSString *defaultFloor = [self electDefaultFloorWithBuildingId:buildingId];
    [self selectBuilding:buildingId floor:defaultFloor];
}

- (void)selectFloor:(NSString *)floor
{
    [self.floorBar selectRow:floor];
    [self selectBuilding:self.building.identifier floor:floor];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor
{
    [self selectBuilding:buildingId floor:floor shouldChangeUserTrackingMode:YES];
}

- (void)selectBuilding:(nullable NSString *)buildingId floor:(nullable NSString *)floor shouldChangeUserTrackingMode:(BOOL)changeUserTrackingMode
{
    MXMGeoBuilding *building = [self.buildings objectForKey:buildingId];
    // 没选中则不进行后续操作
    if (building == nil || floor == nil) {
        return;
    }
    // 判断楼层名是否正确
    if (![building.floors containsObject:floor]) {
        return;
    }
    // 已选中则不进行后续操作
    if ([building.identifier isEqualToString:self.building.identifier] &&
        [floor isEqualToString:self.floor] &&
        !self.isMapReload) {
        return;
    }
    if (changeUserTrackingMode && (self.mapView.userTrackingMode != MGLUserTrackingModeNone)) {
        [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
    }
    // 设置FloorSelectorBar
    [self.floorBar resetItems:building.floors defaultSelectRow:floor];
    self.isMapReload = NO;
    // 保存当前选中
    self.building = building;
    // 保存id到选中队列，并取100条数据
    [self.historicalBuildingIds insertObject:building.identifier atIndex:0];
    if (self.historicalBuildingIds.count>100) {
        [self.historicalBuildingIds removeLastObject];
    }
    // 保存当前选中楼层
    self.floor = floor;
    // 保持建筑的选择楼层，下次作为默认选中楼层
    [self.buildingSelectFloorDic setObject:floor forKey:building.identifier];
    // 配置对应的Filter
    [self filerBuildingId:building.identifier Floor:floor];
    // 回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:didChangeFloor:atBuilding:)]) {
        [self.delegate mapView:self didChangeFloor:self.floor atBuilding:self.building];
    }
    [self updageLocationView];
    [self filterMXMAnnotations];
}

// 定位标注的显示状态
- (void)updageLocationView
{
    // 切换楼层时
    if (!self.mapView.showsUserLocation) {
        return;
    }
    UIView *locationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
    if (self.mapView.userLocation.location.floor) {
        NSUInteger gf = [self.building.floors indexOfObject:self.building.ground_floor];
        NSUInteger cf = [self.building.floors indexOfObject:self.floor];
        if (self.mapView.userLocation.location.floor.level == (cf-gf)) {
            locationView.alpha = 1.0f;
        } else {
            locationView.alpha = 0.5f;
        }
    } else {
        locationView.alpha = 1.0f;
    }
}

// annotation过滤
- (void)filterMXMAnnotations
{
    NSMutableArray *MXMAnns = [NSMutableArray array];
    for (MXMPointAnnotation *ann in self.mxmPointAnnotations) {
        if (self.isIndoor) {
            if ([ann.buildingId isEqualToString:self.building.identifier]) {
                if ([ann.floor isEqualToString:self.floor]) {
                    ann.hidden = NO;
                    [MXMAnns addObject:ann];
                } else {
                    ann.hidden = YES;
                }
            } else {
                ann.hidden = NO;
                [MXMAnns addObject:ann];
            }
        } else {
            ann.hidden = NO;
            [MXMAnns addObject:ann];
        }
    }
    // 找交集
    NSMutableSet *all = [NSMutableSet setWithArray:self.mapView.annotations];
    NSMutableSet *mxms = [NSMutableSet setWithArray:self.mxmPointAnnotations];
    [all intersectSet:mxms];
    NSArray *intersection = all.allObjects;
    // 移除公共部分
    [self.mapView removeAnnotations:intersection];
    // 添加不隐藏的marker
    [self.mapView addAnnotations:MXMAnns];
}

// 地图数据过滤
- (void)filerBuildingId:(NSString *)buildingId Floor:(NSString *)floor {
    NSArray *arr = self.mapView.style.layers;
    for (MGLStyleLayer *k in arr) {
        // 过滤不需要处理的layer
        if (![k isKindOfClass:[MGLVectorStyleLayer class]]) {
            continue;
        }
        MGLVectorStyleLayer *vk = (MGLVectorStyleLayer *)k;
        NSString *ident = vk.identifier;
        if (![ident hasPrefix:@"maphive"] || [ident hasPrefix:@"maphive-building"]) {
            continue;
        }
        
        // 处理剩下需要添加filter的layer
        id originalPredicate = vk.predicate;
        NSMutableArray *mu = [NSMutableArray arrayWithCapacity:0];
        if ([originalPredicate isKindOfClass:[NSCompoundPredicate class]]) {
            NSArray *sub = ((NSCompoundPredicate *)originalPredicate).subpredicates;
            for (NSCompoundPredicate *s in sub) {
                NSString *str = s.predicateFormat;
                if (![str containsString:@"floor =="] && ![str containsString:@"ref:building =="]) {
                    [mu addObject:s];
                }
            }
        } else {
            [mu addObject:originalPredicate];
        }
        NSPredicate *f = [NSPredicate predicateWithFormat:@"floor == %@", floor];
        [mu addObject:f];
        NSPredicate *b = [NSPredicate predicateWithFormat:@"%K == %@", @"ref:building", buildingId];
        [mu addObject:b];
        NSCompoundPredicate *reSetPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:mu];
        // 重置过滤
        vk.predicate = reSetPredicate;
    }
}


- (void)addMXMPointAnnotations:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.mxmPointAnnotations addObjectsFromArray:annotations];
    [self.mapView addAnnotations:annotations];
    [self filterMXMAnnotations];
}

- (void)removeMXMPointAnnotaions:(NSArray<MXMPointAnnotation *> *)annotations
{
    [self.mxmPointAnnotations removeObjectsInArray:annotations];
    [self.mapView removeAnnotations:annotations];
}
#pragma mark end

@end
