//
//  MXMBuildingSelectorButton.m
//  MapxusMapSDK
//
//  Created by chenghao guo on 2021/2/3.
//  Copyright © 2021 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMBuildingSelectorButton.h"
#import "KxMenu.h"

@interface MXMBuildingSelectorButton ()

@property (nonatomic, copy) NSArray *buildings;
@end

@implementation MXMBuildingSelectorButton

@synthesize mxmDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSBundle *bundle = [NSBundle bundleForClass:[MXMBuildingSelectorButton class]];
        UIImage *image = [UIImage imageNamed:@"selectBuilding" inBundle:bundle compatibleWithTraitCollection:nil];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selectBuildingOnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.hidden = YES;
    }
    return self;
}

- (void)selectBuildingOnClick:(UIButton *)sender {
    NSTextAlignment alig = NSTextAlignmentLeft;
//    switch (self.selectorPosition) {
//        case MXMSelectorPositionTopRight:
//        case MXMSelectorPositionCenterRight:
//        case MXMSelectorPositionBottomRight:
//            alig = NSTextAlignmentRight;
//            break;
//        default:
//            break;
//    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.buildings.count];
    for (MXMGeoBuilding *b in self.buildings) {
        KxMenuItem *item = [KxMenuItem menuItem:b.name
                                     identifier:b.identifier
                                          image:nil
                                         target:self
                                         action:@selector(chooseItem:)];
        item.alignment = alig;
        [arr addObject:item];
    }
    [KxMenu showMenuInView:sender.superview fromRect:sender.frame menuItems:arr];
}

- (void)chooseItem:(KxMenuItem *)sender
{
    [self.mxmDelegate didSelectBuilding:sender.identifier];
}

- (void)refreshBuildingList:(NSArray<MXMGeoBuilding *> *)list {
    self.buildings = list;
}

- (void)selectedBuildig:(MXMGeoBuilding *)building {
    [KxMenu setDefaultItemIdentifier:building.identifier];
}

- (void)setSelectorHidden:(BOOL)isHidden {
    self.hidden = isHidden;
}

- (void)updateConstraintsList:(NSArray *)list {
}

@end
