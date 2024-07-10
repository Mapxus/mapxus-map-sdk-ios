//
//  KxMenu.m
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 Some ideas was taken from QBPopupMenu project by Katsuma Tanaka.
 https://github.com/questbeat/QBPopupMenu
 */

#import "KxMenu.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kArrowSize = 12.f;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface KxMenuView : UIView
@property (nonatomic, assign) BOOL isShowing;
- (void)dismissMenu:(BOOL) animated;
@end

@interface KxMenuOverlay : UIView
@end

@implementation KxMenuOverlay

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    //        UITapGestureRecognizer
    //        UIPinchGestureRecognizer
    //        UIRotationGestureRecognizer
    //        UISwipeGestureRecognizer
    //        UIPanGestureRecognizer
    //        UIScreenEdgePanGestureRecognizer
    //        UILongPressGestureRecognizer
    //
    UITapGestureRecognizer *gestureRecognizer;
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(singleTap:)];
    [self addGestureRecognizer:gestureRecognizer];
    
    UIPinchGestureRecognizer *pinchgestureRecognizer;
    pinchgestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(singleTap:)];
    [self addGestureRecognizer:pinchgestureRecognizer];
    
    UIRotationGestureRecognizer *rotationgestureRecognizer;
    rotationgestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(singleTap:)];
    [self addGestureRecognizer:rotationgestureRecognizer];
    
    UISwipeGestureRecognizer *swipegestureRecognizer;
    swipegestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(singleTap:)];
    [self addGestureRecognizer:swipegestureRecognizer];
    
    UIPanGestureRecognizer *pangestureRecognizer;
    pangestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(singleTap:)];
    [self addGestureRecognizer:pangestureRecognizer];
    
    UIScreenEdgePanGestureRecognizer *screengestureRecognizer;
    screengestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(singleTap:)];
    [self addGestureRecognizer:screengestureRecognizer];
    
    UILongPressGestureRecognizer *longgestureRecognizer;
    longgestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(singleTap:)];
    [self addGestureRecognizer:longgestureRecognizer];
    
  }
  return self;
}

// thank horaceho https://github.com/horaceho
// for his solution described in https://github.com/kolyvan/kxmenu/issues/9

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
  for (UIView *v in self.subviews) {
    if ([v isKindOfClass:[KxMenuView class]] && [v respondsToSelector:@selector(dismissMenu:)]) {
      CGPoint touchPoint = [recognizer locationInView:self];
      if (!CGRectContainsPoint(v.frame, touchPoint))
        [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
    }
  }
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation KxMenuItem

+ (instancetype) menuItem:(NSString *)title
               identifier:(NSString *)identifier
                    image:(UIImage *)image
                   target:(id)target
                   action:(SEL)action
{
  return [[KxMenuItem alloc] init:title
                       identifier:identifier
                            image:image
                           target:target
                           action:action];
}

- (id) init:(NSString *) title
 identifier:(NSString *)identifier
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
  NSParameterAssert(title.length || image);
  
  self = [super init];
  if (self) {
    _identifier = identifier;
    _title = title;
    _image = image;
    _target = target;
    _action = action;
  }
  return self;
}

- (BOOL) enabled
{
  return _target != nil && _action != NULL;
}

- (void) performAction
{
  __strong id target = self.target;
  
  if (target && [target respondsToSelector:_action]) {
    
    [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
  }
}

- (NSString *) description
{
  return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

typedef NS_ENUM(NSUInteger, KxMenuViewArrowDirection) {
  KxMenuViewArrowDirectionNone,
  KxMenuViewArrowDirectionUp,
  KxMenuViewArrowDirectionDown,
  KxMenuViewArrowDirectionLeft,
  KxMenuViewArrowDirectionRight,
};

@implementation KxMenuView {
  
  KxMenuViewArrowDirection    _arrowDirection;
  CGFloat                     _arrowPosition;
  UIView                      *_contentView;
  NSArray                     *_menuItems;
}

- (id)init
{
  self = [super initWithFrame:CGRectZero];
  if(self) {
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    self.alpha = 0;
    
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 2;
  }
  
  return self;
}

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (void)setupFrameInView:(UIView *)view
                fromRect:(CGRect)fromRect
{
  const CGSize contentSize = _contentView.frame.size;
  
  const CGFloat outerWidth = view.bounds.size.width;
  const CGFloat outerHeight = view.bounds.size.height;
  
  const CGFloat rectX0 = fromRect.origin.x;
  const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
  const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
  const CGFloat rectY0 = fromRect.origin.y;
  const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
  const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
  
  const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
  const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
  const CGFloat widthHalf = contentSize.width * 0.5f;
  const CGFloat heightHalf = contentSize.height * 0.5f;
  
  const CGFloat kMargin = 5.f;
  
  if (widthPlusArrow < (outerWidth - rectX1)) {
    
    _arrowDirection = KxMenuViewArrowDirectionLeft;
    CGPoint point = (CGPoint){
      rectX1,
      rectYM - heightHalf
    };
    
    if (point.y < kMargin)
      point.y = kMargin;
    
    if ((point.y + contentSize.height + kMargin) > outerHeight)
      point.y = outerHeight - contentSize.height - kMargin;
    
    _arrowPosition = rectYM - point.y;
    _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
    
    self.frame = (CGRect) {
      
      point,
      contentSize.width + kArrowSize,
      contentSize.height
    };
    
  } else if (widthPlusArrow < rectX0) {
    
    _arrowDirection = KxMenuViewArrowDirectionRight;
    CGPoint point = (CGPoint){
      rectX0 - widthPlusArrow,
      rectYM - heightHalf
    };
    
    if (point.y < kMargin)
      point.y = kMargin;
    
    if ((point.y + contentSize.height + 5) > outerHeight)
      point.y = outerHeight - contentSize.height - kMargin;
    
    _arrowPosition = rectYM - point.y;
    _contentView.frame = (CGRect){CGPointZero, contentSize};
    
    self.frame = (CGRect) {
      
      point,
      contentSize.width  + kArrowSize,
      contentSize.height
    };
    
  } else if (heightPlusArrow < (outerHeight - rectY1)) {
    
    _arrowDirection = KxMenuViewArrowDirectionUp;
    CGPoint point = (CGPoint){
      rectXM - widthHalf,
      rectY1
    };
    
    if (point.x < kMargin)
      point.x = kMargin;
    
    if ((point.x + contentSize.width + kMargin) > outerWidth)
      point.x = kMargin;
    
    _arrowPosition = rectXM - point.x;
    //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
    _contentView.frame = (CGRect){0, kArrowSize, contentSize};
    
    self.frame = (CGRect) {
      
      point,
      contentSize.width,
      contentSize.height + kArrowSize
    };
    
  } else if (heightPlusArrow < rectY0) {
    
    _arrowDirection = KxMenuViewArrowDirectionDown;
    CGPoint point = (CGPoint){
      rectXM - widthHalf,
      rectY0 - heightPlusArrow
    };
    
    if (point.x < kMargin)
      point.x = kMargin;
    
    if ((point.x + contentSize.width + kMargin) > outerWidth)
      point.x = kMargin;
    
    _arrowPosition = rectXM - point.x;
    _contentView.frame = (CGRect){CGPointZero, contentSize};
    
    self.frame = (CGRect) {
      
      point,
      contentSize.width,
      contentSize.height + kArrowSize
    };
    
  } else {
    
    _arrowDirection = KxMenuViewArrowDirectionNone;
    
    CGFloat fx = (outerWidth - contentSize.width)   * 0.5f;
    if ((fx + contentSize.width + kMargin) > outerWidth)
      fx = kMargin;
    
    self.frame = (CGRect) {
      
      fx,
      (outerHeight - contentSize.height) * 0.5f,
      contentSize,
    };
  }
  [self setNeedsDisplay];
}

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
{
  self.isShowing = YES;
  _menuItems = menuItems;
  
  CGFloat maxWidth = CGRectGetWidth(view.frame) - 60;
  _contentView = [self mkContentViewMaxWidth:maxWidth maxHeight:CGRectGetHeight(view.frame)/2];
  [self addSubview:_contentView];
  
  [self setupFrameInView:view fromRect:rect];
  
  KxMenuOverlay *overlay = [[KxMenuOverlay alloc] initWithFrame:view.bounds];
  [overlay addSubview:self];
  [view addSubview:overlay];
  
  _contentView.hidden = YES;
  const CGRect toFrame = self.frame;
  self.frame = (CGRect){self.arrowPoint, 1, 1};
  
  __weak UIView *weakContentView = _contentView;
  [UIView animateWithDuration:0.2
                   animations:^(void) {
    
    self.alpha = 1.0f;
    self.frame = toFrame;
    
  } completion:^(BOOL completed) {
    weakContentView.hidden = NO;
  }];
  
}

- (void)updateMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems {
  _menuItems = menuItems;
  
  CGFloat maxWidth = CGRectGetWidth(view.frame) - 60;
  _contentView = [self mkContentViewMaxWidth:maxWidth maxHeight:CGRectGetHeight(view.frame)/2];
  [self addSubview:_contentView];
  
  [self setupFrameInView:view fromRect:rect];
}

- (void)dismissMenu:(BOOL) animated
{
  self.isShowing = NO;
  if (self.superview) {
    
    if (animated) {
      
      _contentView.hidden = YES;
      const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
      
      [UIView animateWithDuration:0.2
                       animations:^(void) {
        
        self.alpha = 0;
        self.frame = toFrame;
        
      } completion:^(BOOL finished) {
        
        if ([self.superview isKindOfClass:[KxMenuOverlay class]])
          [self.superview removeFromSuperview];
        [self removeFromSuperview];
      }];
      
    } else {
      
      if ([self.superview isKindOfClass:[KxMenuOverlay class]])
        [self.superview removeFromSuperview];
      [self removeFromSuperview];
    }
  }
}

- (void)performAction:(id)sender
{
  for (id view in _contentView.subviews) {
    if ([view isKindOfClass:[UIButton class]]) {
      ((UIButton *)view).selected = NO;
    }
  }
  [self dismissMenu:YES];
  
  UIButton *button = (UIButton *)sender;
  KxMenuItem *menuItem = _menuItems[button.tag];
  [menuItem performAction];
}

- (UIView *) mkContentViewMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
  for (UIView *v in self.subviews) {
    [v removeFromSuperview];
  }
  
  if (!_menuItems.count)
    return nil;
  
  const CGFloat kMinMenuItemHeight = 32.f;
  const CGFloat kMinMenuItemWidth = 32.f;
  const CGFloat kMarginX = 10.f;
  const CGFloat kMarginY = 8.f;
  
  UIFont *titleFont = [KxMenu titleFont];
  if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:18];
  
  CGFloat maxImageWidth = 0;
  CGFloat maxItemHeight = 0;
  CGFloat maxItemWidth = 0;
  
  for (KxMenuItem *menuItem in _menuItems) {
    
    const CGSize imageSize = menuItem.image.size;
    if (imageSize.width > maxImageWidth)
      maxImageWidth = imageSize.width;
  }
  
  if (maxImageWidth) {
    maxImageWidth += kMarginX;
  }
  
  for (KxMenuItem *menuItem in _menuItems) {
    
    const CGRect titleSize = [menuItem.title boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName:titleFont}
                                                          context:nil];
    const CGSize imageSize = menuItem.image.size;
    
    const CGFloat itemHeight = MAX(titleSize.size.height, imageSize.height) + kMarginY * 2;
    // 因不使用图片，去除图片边距
    const CGFloat itemWidth = ceil(((!menuItem.enabled && !menuItem.image) ? titleSize.size.width : maxImageWidth + titleSize.size.width) + kMarginX * 2);
    
    menuItem.itemHeight = MAX(itemHeight, kMinMenuItemHeight);
    if (itemHeight > maxItemHeight)
      maxItemHeight = itemHeight;
    
    if (itemWidth > maxItemWidth)
      maxItemWidth = itemWidth;
  }
  
  maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
  maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
  
  //    const CGFloat titleX = kMarginX * 2 + maxImageWidth;
  //    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX * 2;
  
  UIImage *selectedImage = [KxMenuView selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
  
  UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
  contentView.autoresizingMask = UIViewAutoresizingNone;
  contentView.backgroundColor = [UIColor clearColor];
  contentView.opaque = NO;
  
  CGFloat itemY = 5;
  NSUInteger itemNum = 0;
  
  for (KxMenuItem *menuItem in _menuItems) {
    double height = menuItem.itemHeight;
    const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, height};
    
    UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
    itemView.titleLabel.numberOfLines = 0;
    itemView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    itemView.tag = itemNum;
    itemView.frame = itemFrame;
    itemView.enabled = menuItem.enabled;
    itemView.backgroundColor = [UIColor clearColor];
    itemView.opaque = NO;
    itemView.autoresizingMask = UIViewAutoresizingNone;
    if ([menuItem.identifier isEqualToString:[KxMenu defaultItemIdentifier]]) {
      itemView.selected = YES;
    }
    [itemView addTarget:self
                 action:@selector(performAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    itemView.titleLabel.font = titleFont;
    if (menuItem.alignment == NSTextAlignmentLeft) {
      itemView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      itemView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    } else {
      itemView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
      itemView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    [itemView setTitle:menuItem.title forState:UIControlStateNormal];
    [itemView setTitleColor:(menuItem.foreColor ? menuItem.foreColor : [UIColor lightGrayColor]) forState:UIControlStateNormal];
    [itemView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [itemView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [itemView setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [itemView setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    [contentView addSubview:itemView];
    
    if (menuItem.image) {
      
      const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
      imageView.image = menuItem.image;
      imageView.clipsToBounds = YES;
      imageView.contentMode = UIViewContentModeCenter;
      imageView.autoresizingMask = UIViewAutoresizingNone;
      [itemView addSubview:imageView];
    }
    
    itemY += height;
    ++itemNum;
  }
  
  contentView.contentSize = CGSizeMake(maxItemWidth, itemY+5);
  contentView.frame = (CGRect){0, 0, maxItemWidth, MIN(itemY+5, maxHeight-50)};
  
  return contentView;
}

- (CGPoint) arrowPoint
{
  CGPoint point;
  
  if (_arrowDirection == KxMenuViewArrowDirectionUp) {
    
    point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
    
    point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
    
    point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
    
    point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
    
  } else {
    
    point = self.center;
  }
  
  return point;
}

+ (UIImage *) selectedImage: (CGSize) size
{
  const CGFloat locations[] = {0,1};
  const CGFloat components[] = {
    0.29, 0.69, 0.83, 1,
    0.29, 0.69, 0.83, 1,
  };
  
  return [self gradientImageWithSize:size locations:locations components:components count:2];
}


+ (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count
{
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
  CGColorSpaceRelease(colorSpace);
  CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
  CGGradientRelease(colorGradient);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)drawRect:(CGRect)rect
{
  [self drawBackground:self.bounds
             inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
  CGFloat R0 = 1, G0 = 1, B0 = 1;
  CGFloat R1 = 1, G1 = 1, B1 = 1;
  
  UIColor *tintColor = [KxMenu tintColor];
  if (tintColor) {
    
    CGFloat a;
    [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
  }
  
  CGFloat X0 = frame.origin.x;
  CGFloat X1 = frame.origin.x + frame.size.width;
  CGFloat Y0 = frame.origin.y;
  CGFloat Y1 = frame.origin.y + frame.size.height;
  
  // render arrow
  
  UIBezierPath *arrowPath = [UIBezierPath bezierPath];
  
  // fix the issue with gap of arrow's base if on the edge
  //    const CGFloat kEmbedFix = 3.f;
  
  if (_arrowDirection == KxMenuViewArrowDirectionUp) {
    
    const CGFloat arrowXM = 0;//_arrowPosition;
    const CGFloat arrowX0 = 0;//arrowXM - kArrowSize;
    const CGFloat arrowX1 = 0;//arrowXM + kArrowSize;
    const CGFloat arrowY0 = 0;//Y0;
    const CGFloat arrowY1 = 0;//Y0 + kArrowSize + kEmbedFix;
    
    [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
    
    [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
    
    Y0 += kArrowSize;
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
    
    const CGFloat arrowXM = 0;//_arrowPosition;
    const CGFloat arrowX0 = 0;//arrowXM - kArrowSize;
    const CGFloat arrowX1 = 0;//arrowXM + kArrowSize;
    const CGFloat arrowY0 = 0;//Y1 - kArrowSize - kEmbedFix;
    const CGFloat arrowY1 = 0;//Y1;
    
    [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
    
    [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
    
    Y1 -= kArrowSize;
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
    
    const CGFloat arrowYM = 0;//_arrowPosition;
    const CGFloat arrowX0 = 0;//X0;
    const CGFloat arrowX1 = 0;//X0 + kArrowSize + kEmbedFix;
    const CGFloat arrowY0 = 0;//arrowYM - kArrowSize;;
    const CGFloat arrowY1 = 0;//arrowYM + kArrowSize;
    
    [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
    
    [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
    
    X0 += kArrowSize;
    
  } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
    
    const CGFloat arrowYM = 0;//_arrowPosition;
    const CGFloat arrowX0 = 0;//X1;
    const CGFloat arrowX1 = 0;//X1 - kArrowSize - kEmbedFix;
    const CGFloat arrowY0 = 0;//arrowYM - kArrowSize;;
    const CGFloat arrowY1 = 0;//arrowYM + kArrowSize;
    
    [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
    [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
    [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
    
    [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
    
    X1 -= kArrowSize;
  }
  
  [arrowPath fill];
  
  // render body
  
  const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
  
  UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                        cornerRadius:0];
  
  const CGFloat locations[] = {0, 1};
  const CGFloat components[] = {
    R0, G0, B0, 1,
    R1, G1, B1, 1,
  };
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                               components,
                                                               locations,
                                                               sizeof(locations)/sizeof(locations[0]));
  CGColorSpaceRelease(colorSpace);
  
  
  [borderPath addClip];
  
  CGPoint start, end;
  
  if (_arrowDirection == KxMenuViewArrowDirectionLeft ||
      _arrowDirection == KxMenuViewArrowDirectionRight) {
    
    start = (CGPoint){X0, Y0};
    end = (CGPoint){X1, Y0};
    
  } else {
    
    start = (CGPoint){X0, Y0};
    end = (CGPoint){X0, Y1};
  }
  
  CGContextDrawLinearGradient(context, gradient, start, end, 0);
  
  CGGradientRelease(gradient);
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

static KxMenu *gMenu;
static UIColor *gTintColor;
static UIFont *gTitleFont;
static NSString *gDefaultItemIdentifier;

@implementation KxMenu {
  
  KxMenuView *_menuView;
  BOOL        _observing; // 是否注册了监听
}

+ (instancetype) sharedMenu
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    gMenu = [[KxMenu alloc] init];
  });
  return gMenu;
}

- (id) init
{
  NSAssert(!gMenu, @"singleton object");
  
  self = [super init];
  if (self) {
  }
  return self;
}

- (void) dealloc
{
  if (_observing) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
  NSParameterAssert(view);
  NSParameterAssert(menuItems.count);
  
  if (_menuView) {
    
    [_menuView dismissMenu:NO];
    _menuView = nil;
  }
  
  if (!_observing) {
    
    _observing = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationWillChange:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
  }
  
  
  _menuView = [[KxMenuView alloc] init];
  [_menuView showMenuInView:view fromRect:rect menuItems:menuItems];
}

- (void)updateMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems {
  [_menuView updateMenuInView:view fromRect:rect menuItems:menuItems];
}

- (void) dismissMenu
{
  if (_menuView) {
    
    [_menuView dismissMenu:NO];
    _menuView = nil;
  }
  
  if (_observing) {
    
    _observing = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
}

- (void) orientationWillChange: (NSNotification *) n
{
  [self dismissMenu];
}

- (BOOL)innerMenuViewShowing {
  return _menuView.isShowing;
}

+ (BOOL)menuViewShowing {
  return [[self sharedMenu] innerMenuViewShowing];
}

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
  [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems];
}

+ (void)updateMenuInView:(UIView *)view
                fromRect:(CGRect)rect
               menuItems:(NSArray *)menuItems {
  [[self sharedMenu] updateMenuInView:view fromRect:rect menuItems:menuItems];
}


+ (void)setDefaultItemIdentifier:(NSString *)identifier
{
  if (identifier != gDefaultItemIdentifier) {
    gDefaultItemIdentifier = identifier;
  }
}

+ (NSString *)defaultItemIdentifier
{
  return gDefaultItemIdentifier;
}

+ (void) dismissMenu
{
  [[self sharedMenu] dismissMenu];
}

+ (UIColor *) tintColor
{
  return gTintColor;
}

+ (void) setTintColor: (UIColor *) tintColor
{
  if (tintColor != gTintColor) {
    gTintColor = tintColor;
  }
}

+ (UIFont *) titleFont
{
  return gTitleFont;
}

+ (void) setTitleFont: (UIFont *) titleFont
{
  if (titleFont != gTitleFont) {
    gTitleFont = titleFont;
  }
}

@end
